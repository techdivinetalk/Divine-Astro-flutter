import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/main.dart';
import 'package:divine_astrologer/model/live/blocked_customer_list_res.dart';
import 'package:divine_astrologer/repository/astrologer_profile_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/live_global_singleton.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';

class LiveTipsController extends GetxController {
  CameraController? controller;

  var pref = Get.find<SharedPreferenceService>();
  String astroId = "", name = "", image = "";
  FirebaseDatabase database = FirebaseDatabase.instance;
  var isFrontCamera = true.obs;

  final AstrologerProfileRepository liveRepository =
      AstrologerProfileRepository();

  final StreamController<bool> streamController =
      StreamController<bool>.broadcast()..add(false);

  final UserRepository _userRepository = Get.put(UserRepository());

  // final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  @override
  void onInit() {
    controller = CameraController(
      cameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front),
      ResolutionPreset.max,
    );
    DeviceOrientation portraitMode = DeviceOrientation.portraitUp;
    controller?.lockCaptureOrientation(portraitMode);
    controller!.initialize().then((_) {
      controller?.lockCaptureOrientation(portraitMode);
      if (!Get.context!.mounted) {
        CameraLensDirection.front;
        return;
      }
      update();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    streamController.close();
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  void onReady() {
    var data = pref.getUserDetail();
    astroId = data!.id.toString();
    name = data.name ?? "";
    image = data.image ?? "";
    super.onReady();
  }

  Future<void> astroOnlineAPI({
    required bool entering,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = {
      "type": 3,
      "role_id": 7,
      "device_token": pref.getDeviceToken() ?? "",
    };
    entering == true ? param["check_in"] = 1 : param["check_out"] = 1;
    await _userRepository.astroOnlineAPIForLive(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    return Future<void>.value();
  }

  Future<void> furtherProcedure() async {
    final String userId = (pref.getUserDetail()?.id ?? "").toString();
    final String userName = pref.getUserDetail()?.name ?? "";
    final String awsURL = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    final String avatar = isValidImageURL(imageURL: "$awsURL/$image");
    final List<String> blockedCustomerList = await callBlockedCustomerListRes();
    CollectionReference live = FirebaseFirestore.instance.collection(livePath);
    CollectionReference liveCount =
        FirebaseFirestore.instance.collection(liveCountPath);

    await live.doc(userId).set(
      {
        "id": userId,
        "isAvailable": true,
        "blockList": blockedCustomerList,
      },
    ).then((value) async {
      print("Astrologer node added");
      await liveCount.doc(userId).set({
        "astroId": userId,
        "astroName": userName,
        "astroAvtar": avatar,
      }).then((value) async {
        print("successfully added");
        LiveGlobalSingleton().isInLiveScreen = true;
        await Get.offNamed(RouteName.liveDharamScreen, arguments: userId);
        LiveGlobalSingleton().isInLiveScreen = false;
      });
      // LiveGlobalSingleton().isInLiveScreen = true;
      // await Get.offNamed(RouteName.liveDharamScreen, arguments: userId);
      // LiveGlobalSingleton().isInLiveScreen = false;
    }).catchError((error) {
      print("Failed to add node: $error");
    });

    return Future<void>.value();
  }

  Future<List<String>> callBlockedCustomerListRes() async {
    final List<String> blockedCustomerList = [];
    final Map<String, dynamic> param = <String, dynamic>{"role_id": 7};
    BlockedCustomerListRes res = BlockedCustomerListRes();
    res = await liveRepository.blockedCustomerListAPI(
      params: param,
      successCallBack: log,
      failureCallBack: log,
    );
    res.statusCode == HttpStatus.ok
        ? BlockedCustomerListRes.fromJson(res.toJson())
        : BlockedCustomerListRes.fromJson(BlockedCustomerListRes().toJson());
    res.data?.forEach(
      (element) {
        blockedCustomerList.add((element.customerId ?? 0).toString());
      },
    );
    return Future<List<String>>.value(blockedCustomerList);
  }

  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "https://robohash.org/details";
      }
    }
  }

  // jumpToLivePage(bool front) {
  //   database.ref().child("live/$astroId").update({
  //     "id": astroId,
  //     "name": name,
  //     "image": image,
  //     "isEngaged": 0,
  //     "isAvailable": true,
  //     "callType": "",
  //     "duration": 0,
  //     "callStatus": 0,
  //     "userId": 0,
  //     "userName": "",
  //     "speciality": getSpecialAbilityInString(),
  //   }).then((value) {
  //     Get.to(
  //             LivePage(
  //               liveID: astroId.toString(),
  //               isHost: true,
  //               localUserID: astroId,
  //               astrologerImage: image,
  //               astrologerName: name,
  //               isFrontCamera: front,
  //               astrologerSpeciality: getSpecialAbilityInString(),
  //             ),
  //             routeName: "livepage")
  //         ?.then((value) {
  //       Future.delayed(const Duration(milliseconds: 300)).then((value) {
  //         database.ref().child("live/$astroId").remove();
  //       });
  //     });
  //   });
  // }

  // String getSpecialAbilityInString() {
  //   String allData = pref.getSpecialAbility() ?? "";
  //   Map m = jsonDecode(allData);
  //   List data = m["data"];
  //   List nameList = [];
  //   for (var element in data) {
  //     nameList.add(element["name"]);
  //   }
  //   return nameList.join(", ");
  // }

  giftPopup(BuildContext context) async {
    await openBottomSheet(
      context,
      functionalityWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: appColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),

                      // Image border
                      child: Assets.images.bgUserTmpPro
                          .image(height: 70.h, width: 70.h, fit: BoxFit.cover)),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "congratulations".tr,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: appColors.darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    "You've Have Received 4 Gifts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20.h),
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: 2,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Assets.images.icBoyKundli.svg(
                                  height: 50.h, width: 50.h, fit: BoxFit.cover),
                              SizedBox(
                                width: 15.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rahul",
                                    style: AppTextStyle.textStyle16(
                                        fontColor: appColors.darkBlue),
                                  ),
                                  Text(
                                    "has given you 3 hearts",
                                    style: AppTextStyle.textStyle12(
                                        fontColor: appColors.darkBlue),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  Text(
                                    "₹15",
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600,
                                        fontColor: appColors.darkBlue),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Assets.images.bgHeart
                                      .image(height: 48.h, width: 48.h),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "totalEarning".tr,
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "₹2115",
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
