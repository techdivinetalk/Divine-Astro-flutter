import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_bottomsheet.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'profile_controller.dart';

class ProfileUI extends GetView<ProfilePageController> {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),

                              // Image border
                              child: Assets.images.bgUserTmpPro.image(
                                  height: 70.h,
                                  width: 70.h,
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Paras',
                                style: AppTextStyle.textStyle20(
                                    fontWeight: FontWeight.w600,
                                    fontColor: AppColors.darkBlue),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RouteName.editProfileUI);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'editProfile'.tr,
                                      style: AppTextStyle.textStyle10(
                                          fontWeight: FontWeight.w500,
                                          fontColor: AppColors.appYellowColour),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      size: 18.h,
                                      color: AppColors.appYellowColour,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            '+91- 9876543210',
                            style: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "${"customerId".tr}-",
                                style: AppTextStyle.textStyle14(
                                    fontWeight: FontWeight.w400,
                                    fontColor: AppColors.darkBlue),
                              ),
                              SizedBox(
                                width: 5.h,
                              ),
                              Expanded(
                                child: Text(
                                  '1234567891',
                                  style: AppTextStyle.textStyle14(
                                      fontWeight: FontWeight.w400,
                                      fontColor: AppColors.darkBlue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  "profileOptions".tr,
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.darkBlue),
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeLeft: true,
                removeBottom: true,
                removeTop: true,
                removeRight: true,
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.profileList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20.h,
                      mainAxisSpacing: 15.h),
                  itemBuilder: (BuildContext context, int index) {
                    ProfileOptionModelClass item =
                        controller.profileList[index];
                    return GridTile(
                      child: InkWell(
                        onTap: () {
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
                                              color: AppColors.white,
                                              width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          color:
                                              AppColors.white.withOpacity(0.1)),
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
                                              itemCount: controller
                                                  .languageList.length,
                                              itemBuilder: (context, index) {
                                                ChangeLanguageModelClass item =
                                                    controller
                                                        .languageList[index];
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
                                                              shape: BoxShape
                                                                  .circle,
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
                                                              shape: BoxShape
                                                                  .circle,
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
                                                                    Text(
                                                                      item.languagesMain
                                                                          .toString(),
                                                                      style: AppTextStyle.textStyle20(
                                                                          fontWeight:
                                                                              FontWeight.w700),
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
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        GetBuilder<ProfilePageController>(
                                            id: "set_lang",
                                            builder: (controller1) {
                                              return InkWell(
                                                onTap: () {
                                                  controller1
                                                      .getSelectedLanguage();
                                                  Get.back();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.lightYellow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15.0),
                                                    child: Center(
                                                      child: Text(
                                                        'okay'.tr,
                                                        style: AppTextStyle
                                                            .textStyle16(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontColor: AppColors
                                                                    .brownColour),
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
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
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
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                      "4.5 ",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 22.h,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Assets.images.icUser.svg(
                                      height: 20.h,
                                      width: 20.h,
                                      // ignore: deprecated_member_use_from_same_package
                                      color: AppColors.appYellowColour),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "16045 ${"total".tr}",
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
                                Assets.images.icFiveStar.svg(
                                  width: 80.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.6,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //4
                            Row(
                              children: [
                                Assets.images.icFourStar.svg(
                                  width: 70.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.2,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //3
                            Row(
                              children: [
                                Assets.images.icThreeStar.svg(
                                  width: 55.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.5,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
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
                                  percent: 0.8,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
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
                                  percent: 0.5,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
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
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "userReview".tr,
                      style: AppTextStyle.textStyle20(),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListView.builder(
                      itemCount: 2,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Assets.images.bgUserProfile.svg(
                                  height: 45.h,
                                  width: 45.h,
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Rahul Shah",
                                            style: AppTextStyle.textStyle14(),
                                          ),
                                          Row(
                                            children: [
                                              RatingBar.readOnly(
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star,
                                                emptyColor: AppColors
                                                    .appYellowColour
                                                    .withOpacity(0.3),
                                                filledColor:
                                                    AppColors.appYellowColour,
                                                initialRating: 4,
                                                size: 15.h,
                                                maxRating: 5,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              PopupMenuButton(
                                                surfaceTintColor:
                                                    Colors.transparent,
                                                color: Colors.white,
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "reportComment".tr,
                                                      style: AppTextStyle
                                                          .textStyle13(),
                                                    ),
                                                  )),
                                                ],
                                                child: const Icon(
                                                    Icons.more_vert_rounded),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Text(
                                        "12 Feb 2021, 03:00 PM",
                                        style: AppTextStyle.textStyle12(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "It was really nice, talking to Pushpak sir it made me more confident.",
                                        style: AppTextStyle.textStyle12(),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      // TextFieldCustom(
                                      //     "Reply here...",
                                      //     TextInputType.text,
                                      //     TextInputAction.done),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Pushpak",
                                                  style:
                                                      AppTextStyle.textStyle14(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                Text(
                                                  "12 Feb 2021, 03:10 PM",
                                                  style: AppTextStyle
                                                      .textStyle12(),
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Text(
                                                  "It was really nice, talking to Pushpak sir it made me more confident.",
                                                  style: AppTextStyle
                                                      .textStyle12(),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
