// ignore_for_file: must_be_immutable, deprecated_member_use, deprecated_member_use_from_same_package

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/custom_text.dart';
import '../../di/shared_preference_service.dart';
import '../../repository/user_repository.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'package:file_picker/file_picker.dart';

class ProfileUI extends GetView<ProfilePageController> {
  ProfileUI({Key? key}) : super(key: key);
  var preference = Get.find<SharedPreferenceService>();

  @override
  Widget build(BuildContext context) {
    Get.put(ProfilePageController(Get.put(UserRepository())));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: commonAppbar(title: "profile".tr, trailingWidget: Container()),
      drawer: const SideMenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                  padding: EdgeInsets.all(12.h),
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 6, color: AppColors.appYellowColour),
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.updateProfileImage(context);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Obx(
                                    () => CachedNetworkImage(
                                      imageUrl:
                                          controller.userProfileImage.value,
                                      fit: BoxFit.cover,
                                      height: 70.h,
                                      width: 70.h,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(Assets
                                              .images.defaultProfile.path),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.userData?.name ?? "",
                                        style: AppTextStyle.textStyle20(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.darkBlue),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(RouteName.editProfileUI);
                                        },
                                        child: Row(children: [
                                          Text(
                                            'editProfile'.tr,
                                            style: AppTextStyle.textStyle10(
                                                fontWeight: FontWeight.w500,
                                                fontColor:
                                                    AppColors.appYellowColour),
                                          ),
                                          Icon(
                                            Icons.arrow_right,
                                            size: 18.h,
                                            color: AppColors.appYellowColour,
                                          )
                                        ]),
                                      )
                                    ]),
                                SizedBox(height: 3.h),
                                Text(
                                  '+91- ${controller.userData?.phoneNo ?? ""}',
                                  style: AppTextStyle.textStyle14(
                                      fontWeight: FontWeight.w400,
                                      fontColor: AppColors.darkBlue),
                                ),
                                SizedBox(height: 3.h),
                                Row(children: [
                                  Text("${"customerId".tr}-",
                                      style: AppTextStyle.textStyle14(
                                          fontWeight: FontWeight.w400,
                                          fontColor: AppColors.darkBlue)),
                                  SizedBox(width: 5.h),
                                  Expanded(
                                    child: Text(
                                        "${controller.userData?.id ?? ""}",
                                        style: AppTextStyle.textStyle14(
                                            fontWeight: FontWeight.w400,
                                            fontColor: AppColors.darkBlue)),
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
                      fontColor: AppColors.darkBlue),
                ),
              ),
              profileOptions(),
              SizedBox(height: 10.h),
              Obx(() => controller.reviewDataSync.value == true
                  ? controller.ratingsData?.data?.totalRating != 0
                      ? ratingsView()
                      : const SizedBox()
                  : const SizedBox()),
              SizedBox(height: 20.h),
              Obx(() => controller.reviewDataSync.value == true
                  ? (controller.ratingsData?.data?.allReviews?.isNotEmpty ??
                          false)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.blackColor.withOpacity(0.2),
                                    blurRadius: 1.0,
                                    offset: const Offset(0.0, 3.0)),
                              ],
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "userReview".tr,
                                style: AppTextStyle.textStyle20(),
                              ),
                              SizedBox(height: 10.h),
                              listOfReviews()
                            ],
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  Widget profileOptions() {
    return MediaQuery.removePadding(
      context: Get.context!,
      removeLeft: true,
      removeBottom: true,
      removeTop: true,
      removeRight: true,
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: controller.profileList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 20.h, mainAxisSpacing: 15.h),
        itemBuilder: (BuildContext context, int index) {
          ProfileOptionModelClass item = controller.profileList[index];
          return GridTile(
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
                                    color: AppColors.white, width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                color: AppColors.white.withOpacity(0.1)),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 0.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50.0)),
                            color: AppColors.white,
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
                                    itemCount: controller.languageList.length,
                                    itemBuilder: (context, index) {
                                      ChangeLanguageModelClass item =
                                          controller.languageList[index];
                                      return GetBuilder<ProfilePageController>(
                                          id: "set_language",
                                          builder: (controller) {
                                            return GestureDetector(
                                              onTap: () {
                                                controller
                                                    .selectedLanguageData(item);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: item.isSelected
                                                        ? Border.all(
                                                            width: 1,
                                                            color: Colors.grey)
                                                        : Border.all(
                                                            width: 0,
                                                            color:
                                                                Colors.white)),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        item.colors!
                                                            .withOpacity(0),
                                                        item.colors!
                                                            .withOpacity(0.2),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            item.languagesMain
                                                                .toString(),
                                                            style: AppTextStyle
                                                                .textStyle20(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          SizedBox(
                                                              height: 10.h),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: AppColors.lightYellow,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Center(
                                            child: Text(
                                              'okay'.tr,
                                              style: AppTextStyle.textStyle16(
                                                  fontWeight: FontWeight.w600,
                                                  fontColor:
                                                      AppColors.brownColour),
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
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.video,
                    allowCompression: false,
                  );
                  if (result != null) {
                    Get.toNamed(RouteName.uploadStoryUi,
                        arguments: "${result.files.single.path}");
                  }
                } else if (item.nav != "") {
                  Get.toNamed(item.nav.toString());
                }
              },
              child: Container(
                // height: 130.h,
                // width: 116.h,
                padding: EdgeInsets.all(10.h),
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
                child: Center(
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
                            fontColor: AppColors.darkBlue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ratingsView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.blackColor.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.h))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ratings".tr,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.h),
                          child: Text(
                            "${controller.ratingsData?.data?.totalRating}",
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
                            color: AppColors.appYellowColour),
                        SizedBox(width: 8.w),
                        Text(
                          "${controller.ratingsData?.data?.totalRating ?? 0} ${"total".tr}",
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
                      Assets.images.icFiveStar.svg(width: 80.w),
                      LinearPercentIndicator(
                        width: 100.w,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        lineHeight: 10.0,
                        animationDuration: 2000,
                        percent: controller.getReviewPercentage(
                            ratingNumbers:
                                controller.ratingsData?.data?.i5Rating ?? 0,
                            totalReviews:
                                ((controller.ratingsData?.data?.totalReviews ??
                                        0)
                                    .toDouble())),
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor: AppColors.lightYellow.withOpacity(0.4),
                        progressColor: AppColors.lightYellow,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  //4
                  Row(
                    children: [
                      Assets.images.icFourStar.svg(width: 70.w),
                      LinearPercentIndicator(
                        width: 100.w,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        lineHeight: 10.0,
                        animationDuration: 2000,
                        percent: controller.getReviewPercentage(
                            ratingNumbers:
                                controller.ratingsData?.data?.i4Rating ?? 0,
                            totalReviews:
                                (controller.ratingsData?.data?.totalReviews ??
                                        0)
                                    .toDouble()),
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor: AppColors.lightYellow.withOpacity(0.4),
                        progressColor: AppColors.lightYellow,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  //3
                  Row(
                    children: [
                      Assets.images.icThreeStar.svg(width: 55.w),
                      LinearPercentIndicator(
                        width: 100.w,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        lineHeight: 10.0,
                        animationDuration: 2000,
                        percent: controller.getReviewPercentage(
                            ratingNumbers:
                                controller.ratingsData?.data?.i3Rating ?? 0,
                            totalReviews:
                                (controller.ratingsData?.data?.totalReviews ??
                                        0)
                                    .toDouble()),
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor: AppColors.lightYellow.withOpacity(0.4),
                        progressColor: AppColors.lightYellow,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  //2
                  Row(
                    children: [
                      Assets.images.icTwoStar.svg(
                        width: 35.w,
                      ),
                      LinearPercentIndicator(
                        width: 100.w,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        lineHeight: 10.0,
                        animationDuration: 2000,
                        percent: controller.getReviewPercentage(
                            ratingNumbers:
                                controller.ratingsData?.data?.i2Rating ?? 0,
                            totalReviews:
                                (controller.ratingsData?.data?.totalReviews ??
                                        0)
                                    .toDouble()),
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor: AppColors.lightYellow.withOpacity(0.4),
                        progressColor: AppColors.lightYellow,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  //1
                  Row(
                    children: [
                      Assets.images.icOneStar.svg(
                        width: 15.w,
                      ),
                      LinearPercentIndicator(
                        width: 100.w,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        lineHeight: 10.0,
                        animationDuration: 2000,
                        percent: controller.getReviewPercentage(
                            ratingNumbers:
                                controller.ratingsData?.data?.i1Rating ?? 0,
                            totalReviews:
                                (controller.ratingsData?.data?.totalReviews ??
                                        0)
                                    .toDouble()),
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor: AppColors.lightYellow.withOpacity(0.4),
                        progressColor: AppColors.lightYellow,
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

  listOfReviews() {
    return ListView.builder(
      itemCount: controller.ratingsData?.data?.allReviews?.length ?? 0,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        TextEditingController replyController = TextEditingController();
        var reviewData = controller.ratingsData?.data?.allReviews?[index];

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${ApiProvider.imageBaseUrl}${reviewData?.customerImage}",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset(Assets.images.defaultProfile.path),
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
                            "${reviewData?.customerName}",
                            style: AppTextStyle.textStyle14(),
                          ),
                          Row(
                            children: [
                              RatingBar.readOnly(
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star,
                                emptyColor:
                                    AppColors.appYellowColour.withOpacity(0.3),
                                filledColor: AppColors.appYellowColour,
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
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);

                                      showCupertinoModalPopup(
                                        barrierColor:
                                            AppColors.darkBlue.withOpacity(0.5),
                                        context: context,
                                        builder: (context) => ReportPostReasons(
                                            reviewData!.id.toString()),

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
                        style: AppTextStyle.textStyle12(),
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
                        replyTextView(
                            textController: replyController,
                            reviewId: reviewData?.id ?? 0),
                      if (reviewData?.replyData != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${ApiProvider.imageBaseUrl}${reviewData?.replyData?.astrologerImage}",
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
                                    controller.userData?.name ?? "",
                                    style: AppTextStyle.textStyle14(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "${reviewData?.replyData?.replyDate}",
                                    style: AppTextStyle.textStyle12(),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    "${reviewData?.replyData?.reply}",
                                    style: AppTextStyle.textStyle12(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              child: const Divider(),
            )
          ],
        );
      },
    );
  }

  Widget replyTextView(
      {required TextEditingController textController, required int reviewId}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.10)),
      ),
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: TextFormField(
        controller: textController,
        onFieldSubmitted: (text) {
          controller.getReplyOnReview(reviewId: reviewId, textMsg: text.trim());
        },
        decoration: const InputDecoration(
            hintText: "Reply here...",
            hintStyle: TextStyle(color: AppColors.greyColor),
            border: InputBorder.none),
      ),
    );
  }
}

class ReportPostReasons extends StatefulWidget {
  String reviewID;

  ReportPostReasons(this.reviewID, {super.key});

  @override
  State<ReportPostReasons> createState() => _ReportPostReasonsState();
}

class _ReportPostReasonsState extends State<ReportPostReasons> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
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
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GetBuilder<ProfilePageController>(builder: (controller) {
            return Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  Assets.images.report.svg(),
                  SizedBox(height: 20.h),
                  CustomText("reportingQue".tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      fontColor: AppColors.darkBlue),
                  SizedBox(height: 20.h),
                  MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeRight: true,
                    removeLeft: true,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: controller.reportReason.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        var report = controller.reportReason[index];
                        return Padding(
                          padding: EdgeInsets.all(12.h),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    controller.reportReviews(
                                        report.first, widget.reviewID);
                                  },
                                  child: Text(
                                    report.first.tr,
                                    style: AppTextStyle.textStyle16(
                                        fontColor: AppColors.darkBlue,
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
            );
          }),
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
      color: AppColors.transparent,
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
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CustomText("thankYouForReporting".tr,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: AppColors.darkBlue),
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
                    onPressed: () {
                      Get.back();
                    },
                    color: AppColors.yellow,
                    child: Text(
                      "okay".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.brownColour,
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
