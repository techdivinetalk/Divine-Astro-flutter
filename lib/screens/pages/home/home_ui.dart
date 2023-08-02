import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/common/switch_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'home_controller.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹100000",
                      style: AppTextStyle.textStyle20(
                          fontColor: AppColors.appRedColour,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      AppString.today,
                      style: AppTextStyle.textStyle16(
                          fontColor: AppColors.darkGreen,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "₹100000",
                          style: AppTextStyle.textStyle20(
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
                          fontColor: AppColors.darkGreen,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "₹100000",
                          style: AppTextStyle.textStyle20(
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
                      AppString.followers,
                      style: AppTextStyle.textStyle16(
                          fontColor: AppColors.darkGreen,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.noticeBoard,
                    style: AppTextStyle.textStyle16(
                        fontColor: AppColors.darkGreen,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    AppString.viewAll,
                    style: AppTextStyle.textStyle12(
                        fontColor: AppColors.darkGreen,
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
                    color: AppColors.borderColour,
                    border: Border.all(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.gradientTop, AppColors.gradientBottom],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppString.goLive,
                      style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.brownColour),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                  height: 1.h,
                  color: AppColors.lightGreyColour.withOpacity(0.5)),
              SizedBox(height: 10.h),
              sessionTypeWidget(),
              SizedBox(height: 10.h),
              offterTypeWidget(),
              SizedBox(height: 10.h),
              fullScreenBtnWidget(
                  btnTitle: "Refer an Astrologer ", onbtnTap: () {}),
              SizedBox(height: 10.h),
              fullScreenBtnWidget(btnTitle: "E-commerce", onbtnTap: () {}),
              SizedBox(height: 10.h),
            ],
          ),
        ),
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
          border: Border.all(color: AppColors.borderColour)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sender Category",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
              ),
              Text(
                "07:16 pm  23/06/2023",
                style: AppTextStyle.textStyle10(
                    fontWeight: FontWeight.w400,
                    fontColor: AppColors.darkGreen),
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
            trimExpandedText: AppString.showLess,
            moreStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xffFDD48E)),
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
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
              ),
              SizedBox(height: 16.h),
              Text(
                AppString.chat,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkGreen,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "₹25/Min",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkGreen,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16.h),
              Text(
                AppString.call,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkGreen,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "₹25/Min",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkGreen,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppString.status,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
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
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
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
                  child: Text(
                    "Schedule Now",
                    style: AppTextStyle.textStyle10(
                        fontColor: AppColors.brownColour,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "31st May 2023, 2:30 Pm",
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkGreen,
                    fontWeight: FontWeight.w400),
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
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
              ),
              Text(
                AppString.status,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.darkGreen),
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
                    fontWeight: FontWeight.w700,
                    fontColor: AppColors.darkGreen),
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
                        fontColor: AppColors.darkGreen),
                  ),
                  Text(
                    "  (₹5/Min)",
                    style: AppTextStyle.textStyle10(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkGreen),
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
      {required String? btnTitle, required VoidCallback? onbtnTap}) {
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
              const Icon(Icons.share),
              SizedBox(width: 5.w),
              Text(
                btnTitle ?? "",
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.darkGreen),
              )
            ],
          ),
        ));
  }
}

