import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/schedule_training/schedule_training_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/common_image_view.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';

class ScheduleTraining2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScheduleTrainingController());
  }
}

class ScheduleTraining2 extends GetView<ScheduleTrainingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleTrainingController>(
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: appColors.white,
          appBar: AppBar(
            backgroundColor: AppColors().white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4),
                constraints: BoxConstraints.loose(Size.zero),
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titleSpacing: 0,
            title: Text(
              "Schedule Training",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.darkBlue,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Upcoming Training",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: appColors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: appColors.grey.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CommonImageView(
                            imagePath: Assets.images.defaultProfile.path,
                            height: 50,
                            width: 50,
                            placeHolder: Assets.images.defaultProfile.path,
                          ),
                        ),
                        title: Text(
                          "Himansi",
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: appColors.black,
                          ),
                        ),
                        subtitle: Text(
                          "Tarot",
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: appColors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: appColors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: appColors.red,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "24th, Aug 24",
                                      style: TextStyle(
                                        fontFamily: FontFamily.poppins,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: appColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                  child: VerticalDivider(
                                    width: 1,
                                    color: appColors.red,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: appColors.red,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      controller.selectedTime == null
                                          ? "01:00 p.m"
                                          : controller.selectedTime.toString(),
                                      style: TextStyle(
                                        fontFamily: FontFamily.poppins,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: appColors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, bottom: 10, top: 10, right: 10),
                child: Text(
                  "Your training is scheduled. You can join the session at the scheduled time using the button below.",
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: appColors.grey,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        text:
                            '* Confused? Don’t worry, We are here to help you! ',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: appColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Click here for a tutorial video.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.poppins,
                              fontWeight: FontWeight.w400,
                              color: appColors.red,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle tap
                                print('Link tapped');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteName.addBankAutoMation,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: appColors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Join Training Session",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
