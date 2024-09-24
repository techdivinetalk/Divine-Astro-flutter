import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';
import 'package:divine_astrologer/pages/profile/widget/report_post_reason_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/common_functions.dart';
import '../../common/custom_widgets.dart';
import '../../common/permission_handler.dart';
import '../../di/shared_preference_service.dart';
import '../../model/res_review_ratings.dart';

class ProfileUI extends GetView<ProfilePageController> {
  final preference = Get.find<SharedPreferenceService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePageController>(
      assignId: true,
      init: ProfilePageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: appColors.white,
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            title: Text("profile".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          // drawer: const SideMenuDrawer(),
          body: ListView(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(15.0),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3.0,
                        offset: const Offset(0.0, 3.0),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 6,
                                  color: appColors.guideColor,
                                ),
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: InkWell(
                                  onTap: () async {
                                    /// Told to remove
                                    /* if (await PermissionHelper()
                                  .askMediaPermission()) {
                                controller.updateProfileImage();
                              }*/
                                  },
                                  child: /*ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Obx(
                                          () =>
                                          CachedNetworkPhoto(
                                            url: controller.userProfileImage
                                                .value,
                                            fit: BoxFit.cover,
                                            height: 70.h,
                                            width: 70.h,
                                          ),
                                    ),*/
                                      controller.userProfileImage
                                                  .contains("null") ||
                                              controller.userProfileImage.value
                                                  .isEmpty
                                          ? SizedBox(
                                              height: 70.h,
                                              width: 70.h,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.h),
                                                  child: Image.asset(Assets
                                                      .images
                                                      .defaultProfile
                                                      .path)),
                                            )
                                          : CommonImageView(
                                              imagePath: controller
                                                  .userProfileImage.value,
                                              fit: BoxFit.cover,
                                              height: 70.h,
                                              width: 70.h,
                                              placeHolder: Assets
                                                  .images.defaultProfile.path,
                                              radius:
                                                  BorderRadius.circular(100.h),
                                            )),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(RouteName.editProfileUI);
                                      },
                                      child: Row(children: [
                                        Text(
                                          'editProfile'.tr,
                                          style: AppTextStyle.textStyle10(
                                              fontWeight: FontWeight.w500,
                                              fontColor: appColors.textColor),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          size: 18.h,
                                          color: appColors.guideColor,
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          controller.userData?.name ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: AppTextStyle.textStyle20(
                                              fontWeight: FontWeight.w600,
                                              fontColor: appColors.darkBlue),
                                        ),
                                      ),
                                      // const SizedBox(width: 5),
                                    ]),
                                /*SizedBox(height: 3.h),
                                  Text(
                                    '+91- ${controller.userData?.phoneNo ?? ""}',
                                    style: AppTextStyle.textStyle14(
                                        fontWeight: FontWeight.w400,
                                        fontColor: appColors.darkBlue),
                                  ),*/
                                // SizedBox(height: 3.h),
                                Row(children: [
                                  Text("${"astrologerId".tr}-",
                                      style: AppTextStyle.textStyle14(
                                          fontWeight: FontWeight.w400,
                                          fontColor: appColors.darkBlue)),
                                  SizedBox(width: 5.h),
                                  Expanded(
                                    child: Text(
                                        "${controller.userData?.uniqueNo ?? ""}",
                                        style: AppTextStyle.textStyle14(
                                            fontWeight: FontWeight.w400,
                                            fontColor: appColors.darkBlue)),
                                  ),
                                ]),
                              ]),
                        )
                      ])),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  "profileOptions".tr,
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue),
                ),
              ),
              profileOptions(controller: controller),
              controller.isGettingReviews.value == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Obx(() => controller.reviewDataSync.value == true
                      ? controller.ratingsData.value.data?.totalRating != 0
                          ? ratingsView(controller: controller)
                          : const SizedBox()
                      : const SizedBox()),
              Obx(() => controller.reviewDataSync.value == true
                  ? (controller
                              .ratingsData.value.data?.allReviews?.isNotEmpty ??
                          false)
                      ? Column(
                          children: [
                            SizedBox(height: 20.h),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          appColors.blackColor.withOpacity(0.2),
                                      blurRadius: 1.0,
                                      offset: const Offset(0.0, 3.0)),
                                ],
                                color: appColors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "userReview".tr,
                                    style: AppTextStyle.textStyle20(),
                                  ),
                                  SizedBox(height: 10.h),
                                  listOfReviews(controller: controller),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                  : const SizedBox()),
              SizedBox(height: 20.h),
              feedbackWidget(controller: controller),
            ],
          ),
        );
      },
    );
  }

  Widget profileOptions({ProfilePageController? controller}) {
    return MediaQuery.removePadding(
      context: Get.context!,
      removeLeft: true,
      removeBottom: true,
      removeTop: true,
      removeRight: true,
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        controller: controller!.scrollController,
        itemCount: controller.profileList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 20.h, mainAxisSpacing: 15.h),
        itemBuilder: (BuildContext context, int index) {
          ProfileOptionModelClass item = controller.profileList[index];
          return item.isCheck == true
              ? SizedBox(
                  height: 107.h,
                  width: 116.w,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3.0,
                            offset: const Offset(0.0, 3.0)),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Material(
                        color: appColors.transparent,
                        child: InkWell(
                          onTap: () async {
                            print("objectobjectobjectobjectobject----${index}");
                            if (index == 3) {
                              openBottomSheet(
                                context,
                                functionalityWidget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: appColors.white,
                                                width: 1.5),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50.0)),
                                            color: appColors.white
                                                .withOpacity(0.1)),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 0.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(50.0)),
                                        color: appColors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'chooseYourAppLanguage'.tr,
                                            style: AppTextStyle.textStyle20(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 32.h),
                                          SizedBox(
                                            child: GridView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 30.h,
                                                  crossAxisSpacing: 30.h,
                                                ),
                                                itemCount: controller
                                                    .languageList.length,
                                                itemBuilder: (context, index) {
                                                  ChangeLanguageModelClass
                                                      item = controller
                                                          .languageList[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .selectedLanguageData(
                                                              item);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: item
                                                                  .isSelected
                                                              ? Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey)
                                                              : Border.all(
                                                                  width: 0,
                                                                  color: Colors
                                                                      .white)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              item.colors!
                                                                  .withOpacity(
                                                                      0),
                                                              item.colors!
                                                                  .withOpacity(
                                                                      0.2),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CustomText(
                                                                  item.languagesMain
                                                                      .toString(),
                                                                  fontSize:
                                                                      18.5.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        10.h),
                                                                Text(
                                                                  item.languages
                                                                      .toString(),
                                                                  style: AppTextStyle
                                                                      .textStyle16(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          SizedBox(height: 30.h),
                                          InkWell(
                                            onTap: () {
                                              controller.getSelectedLanguage();
                                              Get.back();
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: appColors.guideColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                child: Center(
                                                  child: Text(
                                                    'okay'.tr,
                                                    style: AppTextStyle
                                                        .textStyle16(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontColor: appColors
                                                                .white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (index == 1) {
                              // if (await PermissionHelper()
                              //     .askStoragePermission(Permission.videos)) {
                              //   FilePickerResult? result =
                              //       await FilePicker.platform.pickFiles(
                              //     type: FileType.video,
                              //     allowCompression: false,
                              //   );
                              //   if (result != null) {
                              //     Get.toNamed(RouteName.uploadStoryUi,
                              //         arguments: "${result.files.single.path}");
                              //   }
                              // }
                              controller.pickingFileLoading = true;
                              if (controller.isFilePickerActive) {
                                print(
                                    "File picker is already active. Please wait.");
                                controller.pickingFileLoading = true;
                                return;
                              }
                              controller.update();
                              if (await PermissionHelper()
                                  .askStoragePermission(Permission.videos)) {
                                controller.isFilePickerActive = true;

                                try {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.video,
                                    allowCompression: false,
                                    allowMultiple: false,
                                  );
                                  controller.pickingFileLoading = false;
                                  if (result != null) {
                                    Get.toNamed(RouteName.uploadStoryUi,
                                        arguments:
                                            "${result.files.single.path}");
                                  }
                                  controller.update();
                                } catch (e) {
                                  controller.pickingFileLoading = false;
                                  controller.update();
                                  print("An error occurred: $e");
                                } finally {
                                  controller.pickingFileLoading = false;

                                  controller.isFilePickerActive = false;
                                  controller.update();
                                }
                              }
                            }
                            // else if (index == 3) {
                            //   controller.whatsapp();
                            // }
                            else if (item.nav != "" && index == 2) {
                              if (item.name == "uploadYourPhotosUi") {
                                if (await PermissionHelper()
                                    .askStoragePermission(Permission.photos)) {
                                  Get.toNamed(item.nav.toString());
                                }
                              } else {
                                Get.toNamed(item.nav.toString());
                              }
                            } else if (index == 0) {
                              Get.toNamed(RouteName.bankDetailsUI);
                            } else if (index == 4) {
                              Get.toNamed(RouteName.faq);
                            } else if (index == 7) {
                              Get.toNamed(RouteName.puja);
                            } else if (index == 8) {
                              log("index ----");
                              Get.toNamed(RouteName.customProduct);
                            } else if (index == 5) {
                              Get.toNamed(RouteName.numberChangeReqUI);
                            } else if (index == 6) {
                              Get.toNamed(RouteName.blockedUser);
                            } else if(index == 9){
                              controller.whatsapp();
                            }
                            /*else if (index == 10) {
                        log("index ----");
                        Get.toNamed(RouteName.passbook);
                      }*/
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: index == 1
                                ? controller.pickingFileLoading == true
                                    ? const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          item.widget ?? const SizedBox(),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            item.name.toString(),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.textStyle10(
                                                fontWeight: FontWeight.w500,
                                                fontColor: appColors.darkBlue),
                                          ),
                                        ],
                                      )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      item.widget ?? const SizedBox(),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        item.name.toString(),
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.textStyle10(
                                            fontWeight: FontWeight.w500,
                                            fontColor: appColors.darkBlue),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null;
        },
      ),
    );
  }

  ratingsView({ProfilePageController? controller}) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: appColors.blackColor.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: appColors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.h))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ratings".tr,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.h),
                              child: Text(
                                "${controller!.ratingsData.value.data?.totalRating ?? "0.0"}",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Icon(Icons.star, size: 22.h)
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Assets.images.icUser.svg(
                              height: 20.h,
                              width: 20.h,
                              colorFilter: ColorFilter.mode(
                                  appColors.guideColor, BlendMode.srcIn),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "total".trParams({
                                "count":
                                    "${controller.ratingsData.value.data?.totalReviews}"
                              }),
                              style: AppTextStyle.textStyle14(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //5
                      Row(
                        children: [
                          Assets.images.icFiveStar
                              .svg(width: 80.w, color: appColors.guideColor),
                          LinearPercentIndicator(
                            width: 100.w,
                            barRadius: const Radius.circular(50),
                            animation: true,
                            lineHeight: 6.h,
                            animationDuration: 2000,
                            percent: controller.getReviewPercentage(
                                ratingNumbers: controller
                                        .ratingsData.value.data?.i5Rating ??
                                    0,
                                totalReviews: ((controller.ratingsData.value
                                            .data?.totalReviews ??
                                        0)
                                    .toDouble())),
                            backgroundColor:
                                appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      //4
                      Row(
                        children: [
                          Assets.images.icFourStar
                              .svg(width: 70.w, color: appColors.guideColor),
                          LinearPercentIndicator(
                            width: 100.w,
                            barRadius: const Radius.circular(50),
                            animation: true,
                            lineHeight: 6.h,
                            animationDuration: 2000,
                            percent: controller.getReviewPercentage(
                                ratingNumbers: controller
                                        .ratingsData.value.data?.i4Rating ??
                                    0,
                                totalReviews: (controller.ratingsData.value.data
                                            ?.totalReviews ??
                                        0)
                                    .toDouble()),
                            backgroundColor:
                                appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      //3
                      Row(
                        children: [
                          Assets.images.icThreeStar
                              .svg(width: 55.w, color: appColors.guideColor),
                          LinearPercentIndicator(
                            width: 100.w,
                            barRadius: const Radius.circular(50),
                            animation: true,
                            lineHeight: 6.h,
                            animationDuration: 2000,
                            percent: controller.getReviewPercentage(
                                ratingNumbers: controller
                                        .ratingsData.value.data?.i3Rating ??
                                    0,
                                totalReviews: (controller.ratingsData.value.data
                                            ?.totalReviews ??
                                        0)
                                    .toDouble()),
                            backgroundColor:
                                appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      //2
                      Row(
                        children: [
                          Assets.images.icTwoStar
                              .svg(width: 35.w, color: appColors.guideColor),
                          LinearPercentIndicator(
                            width: 100.w,
                            barRadius: const Radius.circular(50),
                            animation: true,
                            lineHeight: 6.h,
                            animationDuration: 2000,
                            percent: controller.getReviewPercentage(
                                ratingNumbers: controller
                                        .ratingsData.value.data?.i2Rating ??
                                    0,
                                totalReviews: (controller.ratingsData.value.data
                                            ?.totalReviews ??
                                        0)
                                    .toDouble()),
                            backgroundColor:
                                appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      //1
                      Row(
                        children: [
                          Assets.images.icOneStar
                              .svg(width: 15.w, color: appColors.guideColor),
                          LinearPercentIndicator(
                            width: 100.w,
                            barRadius: const Radius.circular(50),
                            animation: true,
                            lineHeight: 6.h,
                            animationDuration: 2000,
                            percent: controller.getReviewPercentage(
                                ratingNumbers: controller
                                        .ratingsData.value.data?.i1Rating ??
                                    0,
                                totalReviews: (controller.ratingsData.value.data
                                            ?.totalReviews ??
                                        0)
                                    .toDouble()),
                            backgroundColor:
                                appColors.guideColor.withOpacity(0.4),
                            progressColor: appColors.guideColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  listOfReviews({ProfilePageController? controller}) {
    return ListView.separated(
      itemCount: controller!.allReviews.length + 1 ?? 0,
      primary: false,
      shrinkWrap: true,
      controller: controller.scrollController,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(8.h),
        child: Divider(color: appColors.extraLightGrey),
      ),
      itemBuilder: (context, index) {
        if (index < controller.allReviews.length) {
          TextEditingController replyController = TextEditingController();
          AllReviews reviewData = controller.allReviews[index];

          String shortenName(reviewData) {
            if (reviewData == null || reviewData.customerName == null) {
              return "";
            } else {
              return reviewData.customerName.length > 15
                  ? "${reviewData.customerName.substring(0, 15)}..."
                  : reviewData.customerName;
            }
          }

          bool isFirstOccurrence = !controller.uniqueUsers
              .contains(reviewData.customerId.toString());
          if (isFirstOccurrence) {
            controller.uniqueUsers.add(reviewData.customerId.toString());
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkPhoto(
                  url: reviewData?.customerImage != null
                      ? "${controller.preference.getBaseImageURL()}/${reviewData?.customerImage}"
                      : "",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.25),
                          child: Text(
                            shortenName(reviewData),
                            style: AppTextStyle.textStyle14(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (reviewData.level != null && reviewData.level != ""
                            // && isFirstOccurrence
                        )
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: LevelWidget(level: reviewData.level ?? ""),
                          ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.readOnly(
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star,
                              emptyColor: appColors.guideColor.withOpacity(0.3),
                              filledColor: appColors.guideColor,
                              initialRating:
                                  double.tryParse("${reviewData?.rating}") ?? 0,
                              size: 15.h,
                              maxRating: 5,
                            ),
                            const SizedBox(width: 10),
                            PopupMenuButton(
                              surfaceTintColor: Colors.transparent,
                              color: Colors.white,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);

                                    showCupertinoModalPopup(
                                      barrierColor:
                                          appColors.darkBlue.withOpacity(0.5),
                                      context: context,
                                      builder: (context) => ReportPostReasons(
                                        reviewData?.id.toString() ?? '',
                                        controller: controller,
                                      ),

                                      // builder: (context) => ReportPostReasons(reviewData?.id.),
                                    );
                                  },
                                  child: Text(
                                    "reportComment".tr,
                                    style: AppTextStyle.textStyle13(),
                                  ),
                                )),
                              ],
                              child: const Icon(Icons.more_vert_rounded),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "${reviewData?.reviewDate}",
                      style:
                          AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                    ),
                    if (reviewData?.comment != null) const SizedBox(height: 5),
                    if (reviewData?.comment != null)
                      Text(
                        "${reviewData?.comment}",
                        style: AppTextStyle.textStyle12(),
                      ),
                    SizedBox(height: 15.h),
                    if (reviewData?.replyData == null &&
                        reviewData?.comment != null)
                      Stack(
                        children: [
                          Visibility(
                            visible: !controller.isLoading.value,
                            child: replyTextView(
                              textController: replyController,
                              reviewId: reviewData?.id ?? 0,
                              onSendPressed: () {
                                controller.getReplyOnReview(
                                    reviewId: reviewData?.id ?? 0,
                                    textMsg: replyController.text.trim());
                                controller.reviewDataSync.value = true;
                              },
                            ),
                          ),
                          Visibility(
                            visible: controller.isLoading.value,
                            child: CircularProgressIndicator(
                                color: appColors.guideColor),
                          ),
                        ],
                      ),
                    if (reviewData?.replyData != null)
                      Obx(() {
                        return Visibility(
                          visible: controller.reviewDataSync.value,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: CachedNetworkPhoto(
                                  url:
                                      "${controller.preference.getBaseImageURL()}/${reviewData?.replyData?.astrologerImage}",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.userData?.name != null
                                          ? (controller.userData?.name ?? "")
                                          : "",
                                      style: AppTextStyle.textStyle14(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "${reviewData?.replyData?.replyDate}",
                                      style: AppTextStyle.textStyle12(),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "${reviewData?.replyData?.reply}",
                                      style: AppTextStyle.textStyle12(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Obx(() => !controller.isLoadMoreReview.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onTap: () {
                        if (!controller.isNoMoreReview.value) {
                          controller.isLoadMoreReview.value = true;
                          controller.getMoreReviewRating();
                        } else {
                          divineSnackBar(data: "No more reviews to load");
                        }
                      },
                      child: Text(
                        "Load More Reviews".tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          // decoration: TextDecoration.underline,
                          decorationColor: appColors.textColor,
                          color: appColors.textColor,
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.0)));
        }
      },
    );
  }

  Widget replyTextView({
    required TextEditingController textController,
    required int reviewId,
    required VoidCallback
        onSendPressed, // Callback for handling send button press
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: appColors.darkBlue.withOpacity(0.10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textController,
              /* onFieldSubmitted: (text) {
                // You can still keep the existing logic here if needed
                controller.getReplyOnReview(reviewId: reviewId, textMsg: text.trim());
              },*/
              onTapOutside: (event) => FocusScope.of(Get.context!).unfocus(),
              decoration: InputDecoration(
                hintText: "${'replyHere'.tr}...",
                isDense: true,
                hintStyle:
                    TextStyle(color: appColors.greyColor, fontSize: 12.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              size: 20,
              color: appColors.black,
            ),
            onPressed: onSendPressed,
          ),
        ],
      ),
    );
  }

  Widget feedbackWidget({ProfilePageController? controller}) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffEDEDED),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3.0,
              offset: const Offset(0.3, 3.0)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "anyFeedbacks".tr,
              style: AppTextStyle.textStyle16(fontColor: appColors.darkBlue),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "feedbacksText".tr,
              style: AppTextStyle.textStyle14(fontColor: appColors.darkBlue),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(Get.context!).viewInsets.bottom + 160),
                maxLines: 6,
                maxLength: 96,
                keyboardType: TextInputType.text,
                controller: controller!.feedBackText,
                textInputAction: TextInputAction.done,
                onTapOutside: (value) => FocusScope.of(Get.context!).unfocus(),
                decoration: InputDecoration(
                  hintText: "feedbackHintText".tr,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: appColors.lightGrey,
                  ),
                  helperStyle: AppTextStyle.textStyle16(),
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: appColors.white,
                        width: 1.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: appColors.guideColor,
                        width: 1.0,
                      )),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                if (controller.feedBackText.text.isEmpty) {
                  divineSnackBar(
                      data: "${'feedbackValidation'.tr}.",
                      color: appColors.redColor);
                } else {
                  controller.sendFeedbackAPI(controller.feedBackText.text);
                }
              },
              child: Center(
                child: Container(
                    width: ScreenUtil().screenWidth / 1.5,
                    height: 56,
                    decoration: BoxDecoration(
                        color: appColors.guideColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      "submitFeedback".tr,
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.white),
                    ))),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
