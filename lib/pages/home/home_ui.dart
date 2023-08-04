import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/common/switch_component.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../common/appbar.dart';
import '../../../common/routes.dart';
import '../../common/common_bottomsheet.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'home_controller.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenuDrawer(),
      appBar: commonAppbar(
          title: controller.appbarTitle.value,
          trailingWidget: Obx(() => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                    onTap: () {
                      controller.isShowTitle.value =
                          !controller.isShowTitle.value;
                    },
                    child: controller.isShowTitle.value
                        ? Assets.images.icVisibility.svg()
                        : Assets.images.icVisibilityOff.svg()),
              ))),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Obx(() => controller.isShowTitle.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹100000",
                                    style: AppTextStyle.textStyle16(
                                        fontColor: AppColors.appRedColour,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    AppString.today,
                                    style: AppTextStyle.textStyle16(
                                        fontColor: AppColors.darkBlue,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15.w),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RouteName.yourEarning);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "₹100000",
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.appRedColour,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                    Text(
                                      AppString.total,
                                      style: AppTextStyle.textStyle16(
                                          fontColor: AppColors.darkBlue,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                width: 116.w,
                                height: 54.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 1.0,
                                        offset: const Offset(0.0, 3.0)),
                                  ],
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.gradientTop,
                                      AppColors.gradientBottom
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(RouteName.checkKundli);
                                    },
                                    child: Text(
                                      "Check Kundli",
                                      style: AppTextStyle.textStyle14(
                                          fontColor: AppColors.brownColour,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ])
                      : Container()),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.noticeBoard,
                        style: AppTextStyle.textStyle16(
                            fontColor: AppColors.darkBlue,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        AppString.viewAll,
                        style: AppTextStyle.textStyle12(
                            fontColor: AppColors.darkBlue,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  senderCategoryWidget(),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        border: Border.all(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.gradientTop,
                            AppColors.gradientBottom
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.images.icGoLive.svg(),
                          const SizedBox(width: 15),
                          Text(
                            AppString.goLive,
                            style: AppTextStyle.textStyle20(
                                fontWeight: FontWeight.w700,
                                fontColor: AppColors.brownColour),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                      height: 1.h, color: AppColors.darkBlue.withOpacity(0.5)),
                  SizedBox(height: 10.h),
                  sessionTypeWidget(),
                  SizedBox(height: 10.h),
                  offterTypeWidget(),
                  SizedBox(height: 10.h),
                  fullScreenBtnWidget(
                      imageName: Assets.images.icReferAFriend.svg(),
                      btnTitle: "Refer an Astrologer ",
                      onbtnTap: () {
                        Get.toNamed(RouteName.referAstrologer);
                      }),
                  SizedBox(height: 10.h),
                  trainingVideoWidget(),
                  SizedBox(height: 10.h),
                  fullScreenBtnWidget(
                      imageName: Assets.images.icEcommerce.svg(),
                      btnTitle: "E-commerce",
                      onbtnTap: () {}),
                  SizedBox(height: 10.h),
                  feedbackWidget(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          Positioned(
              right: 10.0,
              top: Get.height * 0.4,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightYellow,
                  borderRadius: BorderRadius.circular(25.0),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.gradientTop, AppColors.gradientBottom],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.icHelp.svg(),
                      Text(
                        AppString.help,
                        style: AppTextStyle.textStyle10(
                            fontColor: AppColors.brownColour,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget senderCategoryWidget() {
    return Container(
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
          border: Border.all(color: AppColors.lightYellow)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sender Category",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              Text(
                "07:16 pm  23/06/2023",
                style: AppTextStyle.textStyle10(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              )
            ],
          ),
          const SizedBox(height: 10),
          ReadMoreText(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and",
            trimLines: 4,
            colorClickableText: AppColors.blackColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: AppString.readMore,
            trimExpandedText: " ${AppString.showLess}",
            moreStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
            lessStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget sessionTypeWidget() {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.sessionType,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              SizedBox(height: 16.h),
              Text(
                AppString.chat.toUpperCase(),
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w700),
              ),
              Text(
                "₹25/Min",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16.h),
              Text(
                AppString.call.toUpperCase(),
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w700),
              ),
              Text(
                "₹25/Min",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppString.status,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              SizedBox(height: 18.h),
              Obx(() => SwitchWidget(
                    onTap: () {
                      controller.chatSwitch.value =
                          !controller.chatSwitch.value;
                    },
                    switchValue: controller.chatSwitch.value,
                  )),
              SizedBox(height: 20.h),
              Obx(() => SwitchWidget(
                    onTap: () {
                      controller.callSwitch.value =
                          !controller.callSwitch.value;
                    },
                    switchValue: controller.callSwitch.value,
                  )),
            ],
          ),
          Column(
            children: [
              Text(
                AppString.nextOnlineTiming,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              SizedBox(height: 18.h),
              Container(
                width: 128.w,
                height: 31.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1.0,
                        offset: const Offset(0.0, 3.0)),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.gradientTop, AppColors.gradientBottom],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      selectDateOrTime(Get.context!,
                          title: "Select Your Date of Birth",
                          btnTitle: "Confirm Date of Birth",
                          pickerStyle: "DateCalendar",
                          looping: true);
                    },
                    child: Text(
                      "Schedule Now",
                      style: AppTextStyle.textStyle10(
                          fontColor: AppColors.brownColour,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "31st May 2023, 2:30 Pm",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget offterTypeWidget() {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.offerType,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              Text(
                AppString.status,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.firstFreeOffer,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w700, fontColor: AppColors.darkBlue),
              ),
              Obx(() => SwitchWidget(
                    onTap: () {
                      controller.consultantOfferSwitch.value =
                          !controller.consultantOfferSwitch.value;
                    },
                    switchValue: controller.consultantOfferSwitch.value,
                  )),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppString.promotionOffer,
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.darkBlue),
                  ),
                  Text(
                    "  (₹5/Min)",
                    style: AppTextStyle.textStyle10(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
              Obx(() => SwitchWidget(
                    onTap: () {
                      controller.promotionOfferSwitch.value =
                          !controller.promotionOfferSwitch.value;
                    },
                    switchValue: controller.promotionOfferSwitch.value,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget fullScreenBtnWidget(
      {required Widget imageName,
      required String? btnTitle,
      required VoidCallback? onbtnTap}) {
    return Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          onTap: onbtnTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageName,
              SizedBox(width: 5.w),
              Text(
                btnTitle ?? "",
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w600, fontColor: AppColors.darkBlue),
              )
            ],
          ),
        ));
  }

  Widget trainingVideoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 210.h,
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkYellow, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Training Videos",
                style: AppTextStyle.textStyle16(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.greyColor,
                              borderRadius: BorderRadius.circular(10)),
                          height: 150.h,
                          width: 110.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget feedbackWidget() {
    return Container(
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffEDEDED)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Any Feedbacks?",
              style: AppTextStyle.textStyle16(fontColor: AppColors.darkBlue),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "You are free to share your thoughts in order to help us improve.",
              style: AppTextStyle.textStyle14(fontColor: AppColors.darkBlue),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3.0,
                        offset: const Offset(0.3, 3.0)),
                  ]),
              child: TextFormField(
                maxLines: 6,
                // maxLength: 96,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Type your feedback here! ",
                  helperStyle: AppTextStyle.textStyle16(),
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.darkYellow,
                        width: 1.0,
                      )),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Container(
                  width: ScreenUtil().screenWidth / 1.5,
                  height: 56,
                  decoration: BoxDecoration(
                      color: AppColors.lightYellow,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    "Submit Feedback",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.brownColour),
                  ))),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
