// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../common/app_exception.dart';
import '../../common/block_success.dart';
import '../../common/co-host_request.dart';
import '../../common/waitlist_sheet.dart';
import '../../di/shared_preference_service.dart';
import '../../model/res_blocked_customers.dart';
import '../../repository/user_repository.dart';

class LiveController extends GetxController {
  var pref = Get.find<SharedPreferenceService>();

  LiveController(this.userRepository);

  final UserRepository userRepository;

  var svgaAnime = [
    "blue_lover.svga",
    "box_of_roses.svga",
    "box_of_roses_second.svga",
    "christmas_reindeer_and_sleigh.svga",
    "lovers.svga",
    "new_year_countdown.svga",
    "new_year_gifts.svga",
    "sports_car.svga",
    "white_horse.svga"
  ];

  @override
  void dispose() {
    total = 0;
    duration.value = "";
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
    plugins: [ZegoUIKitSignalingPlugin()],
  )
    ..durationConfig.isVisible = false
    ..previewConfig.pageBackIcon = const SizedBox()
    ..previewConfig.beautyEffectIcon = const SizedBox()
    ..previewConfig.switchCameraIcon = const SizedBox()
    ..startLiveButtonBuilder = (context, VoidCallback startLive) {
      return const SizedBox();
    }
    ..previewConfig.showPreviewForHost = false;

  Timer? _timer;
  ZegoUIKitUser? coHostUser;
  var msg = TextEditingController();
  var isCoHosting = false.obs;
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
  var isCallOnOff = true.obs;
  var duration = "".obs;
  var typeOfNextUserCall = "";
  var typeOfCall = "";
  var audioStream = false;
  int total = 0;
  var blockIds = <String>[];
  FirebaseDatabase database = FirebaseDatabase.instance;
  ResBlockedCustomers? blockedUserData;
  var blockCustomer = <AstroBlockCustomer>[].obs;
  String? astroId;
  var nextPerson = {}.obs;
  var nextuserid = "";
  var scrollController = ScrollController();

  jumpToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 10),
      curve: Curves.linear,
    );
  }

  getBlockedCustomerList() async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0
    };
    try {
      var blockedUserData = await userRepository.getBlockedCustomerList(params);
      blockIds.clear();
      blockCustomer.clear();
      if (blockedUserData.data != null && blockedUserData.data!.isNotEmpty) {
        var data = blockedUserData.data;
        if (data?.first.astroBlockCustomer != null &&
            data!.first.astroBlockCustomer!.isNotEmpty) {
          blockCustomer.addAll(
              data.first.astroBlockCustomer as Iterable<AstroBlockCustomer>);
          for (var element in data.first.astroBlockCustomer!) {
            blockIds.add(element.customerId.toString());
            database.ref().child("live/$astroId/").update({
              "blockUser": {
                element.customerId: {"id": element.customerId}
              }
            });
          }
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  unblockUser({required String customerId, required String name}) async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 0
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been Unblocked!");
          });
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  blockUser({required String customerId, required String name}) async {
    Map<String, dynamic> params = {
      "role_id": pref.getUserDetail()?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 1
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);
      showDialog(
          context: Get.context!,
          builder: (builder) {
            return BlockSuccess(text: "$name has been blocked!");
          });
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  removeFromWaitList() async {
    var data = await database.ref().child("live/$astroId/waitList").get();
    var first = data.children.toList().first;
    var value = first.value as Map;
    database.ref().child("live/$astroId/waitList/${value["id"]}").remove();
    nextuserid = value["id"];
    typeOfNextUserCall = value["callType"];
    database.ref().child("live/$astroId/").update({
      "nextUser": {
        value["id"]: {
          "id": value["id"],
          "name": value["name"],
          "callType": value["callType"],
          "duration": 9
        }
      }
    });
  }
  bool dialogOpen = false;
  bool dialogOpen2 = false;
  listenWaitList(ZegoUIKitPrebuiltLiveStreamingController controller) {
    database
        .ref()
        .child("live/$astroId/nextUser/$nextuserid")
        .onValue
        .listen((event) async {
      var data = await database
          .ref()
          .child("live/$astroId/nextUser/$nextuserid")
          .get();
      if (data.value != null && !dialogOpen) {
        var user = data.value as Map;
        nextPerson.value = user;
        var id = user["id"];
        var name = user["name"];
        if (nextPerson.isNotEmpty) {
          showCupertinoModalPopup(
              context: Get.context!,
              builder: (BuildContext context) {
                dialogOpen = true;
                return WaitList(
                  astroId: astroId,
                  onAccept: () {
                    dialogOpen = false;
                    database
                        .ref()
                        .child("live/$astroId/")
                        .update({"callStatus": 2,"userId":id,"userName":name});
                  },
                );
              });
        }
      }
    });
  }

  listenCallStatus() {
    database
        .ref()
        .child("live/$astroId/callStatus/")
        .onValue
        .listen((event) async {
      var data = await database.ref().child("live/$astroId/").get();
      if (data.value != null) {
        var userData = data.value as Map;
        if (userData["callStatus"] == 1 && !dialogOpen2) {
          typeOfCall = userData["callType"];
          showCupertinoModalPopup(
              context: Get.context!,
              builder: (BuildContext context) {
                dialogOpen2 = true;
                return CoHostRequest(
                    name: userData["userName"],
                    onAccept: () {
                      dialogOpen2 = false;
                      database
                          .ref()
                          .child("live/$astroId/")
                          .update({"callStatus": 2});
                    });
              });
        }
      }
    });
  }

  stopStream(String id) {
    Get.back();
    database.ref().child("live/$id").remove();
  }

  setCallType(String id) {
    database.ref().child("live/$id").update({"callType": ""});
  }

  var timeDuration = const Duration();
  setAvailibility(String id, bool available, CustomTimerController controller) {
    database.ref().child("live/$id").update({"isAvailable": available});
    database.ref().child("live/$id/coHostUser").onValue.listen((event) async {
      final user = event.snapshot.value as String? ?? "";
      if (user.isEmpty) {
        isCoHosting.value = false;
        controller.reset();
      }else{
        var coHost = await database.ref().child("live/$astroId/coHost").get();
        if(coHost.value != null){
          var user = coHost.value as Map;
          coHostUser = ZegoUIKitUser(id: user["id"], name: user["name"]);
        }
        var data = await database.ref().child("live/$astroId/nextUser").get();
        var type = data.value == null ? typeOfCall : typeOfNextUserCall;
        print("calltype"+type);
        setVisibilityCoHost(type);
        var duration = await database.ref().child("live/$astroId/duration").get();
        intToTimeLeft(duration.value as int ?? 0);
        controller.begin = timeDuration;
        isCoHosting.value = true;
        controller.start();
      }
    });
  }

  setCallStatus(){
    database
        .ref()
        .child("live/$astroId/")
        .update({"callStatus": 0});
  }

  setBusyStatus(String id, int status, {customerId}) {
    database.ref().child("live/$id").update({"isEngaged": status});
    database.ref().child("live/$id").update({"coHostUser": customerId});
  }

  Future<String> getCallType(String id) async {
    var snapShot = await database.ref().child("live/$id").get();
    return (snapShot.value as Map)["callType"];
  }

  Future<int> getDuration(String id) async {
    var snapShot = await database.ref().child("live/$id").get();
    return (snapShot.value as Map)["duration"];
  }

  setVisibilityCoHost(String type) {
    if (type == "video") {
      hostConfig.audioVideoViewConfig.visible = (
        ZegoUIKitUser localUser,
        ZegoLiveStreamingRole localRole,
        ZegoUIKitUser targetUser,
        ZegoLiveStreamingRole targetUserRole,
      ) {
        if (ZegoLiveStreamingRole.host == localRole) {
          /// host can see all user's view
          return true;
        }

        /// comment below if you want the co-host hide their own audio-video view.
        if (localUser.id == targetUser.id) {
          /// local view
          return true;
        }

        /// if user is a co-host, only show host's audio-video view
        return targetUserRole == ZegoLiveStreamingRole.host;
      };
    } else {
      hostConfig.audioVideoViewConfig.visible = (
        ZegoUIKitUser localUser,
        ZegoLiveStreamingRole localRole,
        ZegoUIKitUser targetUser,
        ZegoLiveStreamingRole targetUserRole,
      ) {
        /// if user is a co-host, only show host's audio-video view
        return targetUserRole == ZegoLiveStreamingRole.host;
      };
    }
  }

  void endCall(String orderId, bool isAccept) async {
    Map<String, dynamic> json = {
      "order_id": orderId,
      "duration": "",
      "amount": "walletBalance",
      "offer_id": orderId,
      "role_id": pref.getUserDetail()?.roleId ?? -1,
    };
    final response = await userRepository.endCall(json);
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String result = "$h:$m:$s";
    timeDuration = Duration(hours: h,minutes: m,seconds: s);
    return result;
  }
}
