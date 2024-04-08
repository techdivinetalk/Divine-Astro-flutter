import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/common_image_view.dart';

import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/custom_widgets.dart';
import '../../di/shared_preference_service.dart';
import '../../repository/user_repository.dart';
import '../../screens/side_menu/side_menu_ui.dart';

class ProfileUI extends GetView<ProfilePageController> {
  final preference = Get.find<SharedPreferenceService>();

  // var homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePageController>(
      assignId: true,
      init: Get.put(ProfilePageController(Get.put(UserRepository()))),
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
                              if (await PermissionHelper()
                                  .askMediaPermission()) {
                                controller.updateProfileImage();
                              }
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
                                controller
                                    .userProfileImage.value.isEmpty
                                ? SizedBox(
                              height: 70.h,
                              width: 70.h,
                              child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(
                                      100.h),
                                  child: Image.asset(Assets.images
                                      .defaultProfile.path)),
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
                        crossAxisAlignment: CrossAxisAlignment
                            .start,
                        children: [
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                      RouteName.editProfileUI);
                                },
                                child: Row(children: [
                                  Text(
                                    'editProfile'.tr,
                                    style: AppTextStyle.textStyle10(
                                        fontWeight: FontWeight.w500,
                                        fontColor: appColors
                                            .textColor),
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
                                        fontColor: appColors
                                            .darkBlue),
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
                                  "${controller.userData?.id ??
                                      ""}",
                                  style: AppTextStyle.textStyle14(
                                      fontWeight: FontWeight.w400,
                                      fontColor: appColors
                                          .darkBlue)),
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
              SizedBox(height: 10.h),
              Obx(() =>
              controller.reviewDataSync.value == true
                  ? controller.ratingsData?.data?.totalRating != 0
                  ? ratingsView(controller: controller)
                  : const SizedBox()
                  : const SizedBox()),
              SizedBox(height: 20.h),
              Obx(() =>
              controller.reviewDataSync.value == true
                  ? (controller.ratingsData?.data?.allReviews?.isNotEmpty ??
                  false)
                  ? Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: appColors.blackColor.withOpacity(0.2),
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
              )
                  : const SizedBox()
                  : const SizedBox()),
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
        itemCount: controller!.profileList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 20.h, mainAxisSpacing: 15.h),
        itemBuilder: (BuildContext context, int index) {
          ProfileOptionModelClass item = controller.profileList[index];
          return SizedBox(
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

                      if (index == 4) {
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
                                          color: appColors.white, width: 1.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: appColors.white.withOpacity(0.1)),
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
                                  borderRadius: const BorderRadius.vertical(
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
                                          itemCount:
                                          controller.languageList.length,
                                          itemBuilder: (context, index) {
                                            ChangeLanguageModelClass item =
                                            controller.languageList[index];
                                            return GetBuilder<
                                                ProfilePageController>(
                                                id: "set_language",
                                                builder: (controller) {
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
                                                                  item
                                                                      .languagesMain
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
                                                });
                                          }),
                                    ),
                                    SizedBox(height: 30.h),
                                    GetBuilder<ProfilePageController>(
                                        id: "set_lang",
                                        builder: (controller1) {
                                          return InkWell(
                                            onTap: () {
                                              controller1.getSelectedLanguage();
                                              Get.back();
                                            },
                                            child: Container(
                                              width: MediaQuery
                                                  .of(context)
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
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 1) {
                        if (await PermissionHelper()
                            .askStoragePermission(Permission.videos)) {
                          FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                          );
                          if (result != null) {
                            Get.toNamed(RouteName.uploadStoryUi,
                                arguments: "${result.files.single.path}");
                          }
                        }
                      } else if (index == 3) {
                        controller.whatsapp();
                      } else if (item.nav != "") {
                        if (item.name == "bankDetails".tr ||
                            item.name == "uploadYourPhoto".tr) {
                          if (await PermissionHelper()
                              .askStoragePermission(Permission.photos)) {
                            Get.toNamed(item.nav.toString());
                          }
                        } else {
                          Get.toNamed(item.nav.toString());
                        }
                      } else if (index == 5) {
                        Get.toNamed(RouteName.faq);
                      } else if (index == 8) {
                        print("index ---- ${index == 8}");
                        Get.toNamed(RouteName.puja);
                      } /*else if (index == 10) {
                        Get.toNamed(RouteName.remedies);
                      }*/
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
          );
        },
      ),
    );
  }

  ratingsView({ProfilePageController? controller}) {
    return Container(
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
                            "${controller!.ratingsData?.data?.totalRating ??
                                "0.0"}",
                            style: TextStyle(
                                fontSize: 17.sp, fontWeight: FontWeight.w400),
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
                            "${controller.ratingsData?.data?.totalReviews}"
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
                            ratingNumbers:
                            controller.ratingsData?.data?.i5Rating ?? 0,
                            totalReviews:
                            ((controller.ratingsData?.data?.totalReviews ??
                                0)
                                .toDouble())),
                        backgroundColor: appColors.guideColor.withOpacity(0.4),
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
                            ratingNumbers:
                            controller.ratingsData?.data?.i4Rating ?? 0,
                            totalReviews:
                            (controller.ratingsData?.data?.totalReviews ??
                                0)
                                .toDouble()),
                        backgroundColor: appColors.guideColor.withOpacity(0.4),
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
                            ratingNumbers:
                            controller.ratingsData?.data?.i3Rating ?? 0,
                            totalReviews:
                            (controller.ratingsData?.data?.totalReviews ??
                                0)
                                .toDouble()),
                        backgroundColor: appColors.guideColor.withOpacity(0.4),
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
                            ratingNumbers:
                            controller.ratingsData?.data?.i2Rating ?? 0,
                            totalReviews:
                            (controller.ratingsData?.data?.totalReviews ??
                                0)
                                .toDouble()),
                        backgroundColor: appColors.guideColor.withOpacity(0.4),
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
                            ratingNumbers:
                            controller.ratingsData?.data?.i1Rating ?? 0,
                            totalReviews:
                            (controller.ratingsData?.data?.totalReviews ??
                                0)
                                .toDouble()),
                        backgroundColor: appColors.guideColor.withOpacity(0.4),
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
    );
  }

  listOfReviews({ProfilePageController? controller}) {
    return ListView.separated(
      itemCount: controller!.ratingsData?.data?.allReviews?.length ?? 0,
      primary: false,
      shrinkWrap: true,
      separatorBuilder: (context, index) =>
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Divider(color: appColors.extraLightGrey),
          ),
      itemBuilder: (context, index) {
        TextEditingController replyController = TextEditingController();
        var reviewData = controller.ratingsData?.data?.allReviews?[index];

        String shortenName(reviewData) {
          if (reviewData == null || reviewData.customerName == null) {
            return "";
          } else {
            return reviewData.customerName.length > 15
                ? "${reviewData.customerName.substring(0, 15)}..."
                : reviewData.customerName;
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkPhoto(
                url: reviewData?.customerImage != null
                    ? "${controller.preference
                    .getBaseImageURL()}/${reviewData?.customerImage}"
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shortenName(reviewData),
                        style: AppTextStyle.textStyle14(),
                      ),
                      Row(
                        children: [
                          RatingBar.readOnly(
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star,
                            emptyColor:
                            appColors.guideColor.withOpacity(0.3),
                            filledColor: appColors.guideColor,
                            initialRating:
                            double.tryParse("${reviewData?.rating}") ??
                                0,
                            size: 15.h,
                            maxRating: 5,
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton(
                            surfaceTintColor: Colors.transparent,
                            color: Colors.white,
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);

                                      showCupertinoModalPopup(
                                        barrierColor:
                                        appColors.darkBlue.withOpacity(0.5),
                                        context: context,
                                        builder: (context) =>
                                            ReportPostReasons(
                                                reviewData?.id.toString() ??
                                                    '',controller: controller,),

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
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500),
                  ),
                  if (reviewData?.comment != null)
                    const SizedBox(height: 5),
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
                                "${controller.preference
                                    .getBaseImageURL()}/${reviewData
                                    ?.replyData?.astrologerImage}",
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
}

class ReportPostReasons extends StatefulWidget {
  final String reviewID;
  final ProfilePageController? controller;

  const ReportPostReasons(this.reviewID, {super.key, this.controller});

  @override
  State<ReportPostReasons> createState() => _ReportPostReasonsState();
}

class _ReportPostReasonsState extends State<ReportPostReasons> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: appColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: appColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              children: [
                Assets.images.report.svg(),
                SizedBox(height: 20.h),
                CustomText("${'reportingQue'.tr}?",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: appColors.darkBlue),
                SizedBox(height: 20.h),
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeRight: true,
                  removeLeft: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.controller!.reportReason.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var report = widget.controller!.reportReason[index];
                      return Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                  widget.controller!.reportReviews(
                                      report.first, widget.reviewID);
                                },
                                child: Text(
                                  report.first.tr,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.textStyle15(
                                      fontColor: appColors.darkBlue,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThankYouReportUI extends GetView<ProfilePageController> {
  const ThankYouReportUI({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: appColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: appColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CustomText("thankYouForReporting".tr,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: appColors.darkBlue),
                SizedBox(height: 20.h),
                Text(
                  "thankYouDes".tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 30.h),
                MaterialButton(
                    elevation: 0,
                    height: 56,
                    minWidth: Get.width,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    onPressed: onPressed,
                    color: appColors.guideColor,
                    child: Text(
                      "okay".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.brownColour,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
