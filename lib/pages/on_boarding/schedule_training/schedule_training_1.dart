import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/schedule_training/schedule_training_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/routes.dart';

class ScheduleTraining1 extends GetView<ScheduleTrainingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleTrainingController>(
      assignId: true,
      init: ScheduleTrainingController(),
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
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
                child: Text(
                  "Please choose a convenient date and time for your onboarding training.",
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: appColors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Availability",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: appColors.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: appColors.grey.withOpacity(0.6),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "23rd, August 2024",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: appColors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: controller.times.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (controller.times2[index]['isEnabled'] == false) {
                          } else {
                            controller.selectedTime =
                                controller.times[index]['time'];
                            controller.update();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: controller.selectedTime ==
                                    controller.times[index]['time']
                                ? appColors.red.withOpacity(0.4)
                                : controller.times[index]['isEnabled'] == false
                                    ? appColors.grey.withOpacity(0.5)
                                    : appColors.white,
                            border: Border.all(
                              color: controller.selectedTime ==
                                      controller.times[index]['time']
                                  ? appColors.red
                                  : controller.times[index]['isEnabled'] ==
                                          false
                                      ? appColors.grey.withOpacity(0.1)
                                      : Colors.black,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.times[index]['time'] ?? "",
                              style: TextStyle(
                                color: controller.selectedTime ==
                                        controller.times[index]['time']
                                    ? appColors.red
                                    : controller.times[index]['isEnabled'] ==
                                            false
                                        ? appColors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.poppins,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "24th, August 2024",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: appColors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: controller.times2.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (controller.times2[index]['isEnabled'] == false) {
                          } else {
                            controller.selectedTime =
                                controller.times2[index]['time'];
                            controller.update();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: controller.selectedTime ==
                                    controller.times2[index]['time']
                                ? appColors.red.withOpacity(0.4)
                                : controller.times2[index]['isEnabled'] == false
                                    ? appColors.grey.withOpacity(0.5)
                                    : appColors.white,
                            border: Border.all(
                              color: controller.selectedTime ==
                                      controller.times2[index]['time']
                                  ? appColors.red
                                  : controller.times2[index]['isEnabled'] ==
                                          false
                                      ? appColors.grey.withOpacity(0.1)
                                      : Colors.black,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.times2[index]['time'] ?? "",
                              style: TextStyle(
                                color: controller.selectedTime ==
                                        controller.times2[index]['time']
                                    ? appColors.red
                                    : controller.times2[index]['isEnabled'] ==
                                            false
                                        ? appColors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.poppins,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            color: appColors.grey.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: appColors.grey.withOpacity(0.5),
                            )),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "No Available",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.poppins,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: appColors.black,
                            )),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Available",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.poppins,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            color: appColors.red.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: appColors.red,
                            )),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Selected",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.poppins,
                        ),
                      ),
                    ],
                  ),
                ],
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
                            RouteName.scheduleTraining2,
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
                              "Schedule Training",
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
