import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/schedule_training/schedule_training_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

class ScheduleTraining1 extends GetView<ScheduleTrainingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleTrainingController>(
      assignId: true,
      init: ScheduleTrainingController(),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool) async {
            controller.showExitAppDialog();
          },
          child: Scaffold(
            backgroundColor: appColors.white,
            appBar: AppBar(
              backgroundColor: AppColors().white,
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              // leading: Padding(
              //   padding: const EdgeInsets.only(bottom: 2.0),
              //   child: IconButton(
              //     visualDensity: const VisualDensity(horizontal: -4),
              //     constraints: BoxConstraints.loose(Size.zero),
              //     icon:
              //         Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
              titleSpacing: 20,
              title: Text(
                "Schedule Training",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                ),
              ),
            ),
            body: controller.loadingTrainingssss == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.astroTrainingSessionModel == null
                    ? Center()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 10),
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
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller
                                  .astroTrainingSessionModel!.data!.length,
                              itemBuilder: (context, index) {
                                var data = controller
                                    .astroTrainingSessionModel!.data![index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, bottom: 6, top: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data.meetingDate.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            color: appColors.darkBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: SizedBox(
                                        height: 35,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: data.detail!.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.only(
                                                  left: 20,
                                                ),
                                                itemBuilder: (context, indx) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      right:
                                                          15, // Add right padding only to the last item
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                                .selectedTime =
                                                            data.detail![indx]
                                                                .id;
                                                        controller.update();
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: controller
                                                                      .selectedTime ==
                                                                  data
                                                                      .detail![
                                                                          indx]
                                                                      .id
                                                              ? appColors
                                                                  .appRedColour
                                                                  .withOpacity(
                                                                      0.2)
                                                              : appColors.white,
                                                          border: Border.all(
                                                            color: controller
                                                                        .selectedTime ==
                                                                    data
                                                                        .detail![
                                                                            indx]
                                                                        .id
                                                                ? appColors
                                                                    .appRedColour
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            data.detail![indx]
                                                                .meetingTime
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: controller
                                                                          .selectedTime ==
                                                                      data
                                                                          .detail![
                                                                              indx]
                                                                          .id
                                                                  ? appColors
                                                                      .appRedColour
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 13.sp,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .poppins,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Container(
                          //           height: 15,
                          //           width: 15,
                          //           decoration: BoxDecoration(
                          //               color: appColors.grey.withOpacity(0.5),
                          //               shape: BoxShape.circle,
                          //               border: Border.all(
                          //                 color:
                          //                     appColors.grey.withOpacity(0.5),
                          //               )),
                          //         ),
                          //         SizedBox(
                          //           width: 7,
                          //         ),
                          //         Text(
                          //           "Not Available",
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.sp,
                          //             fontFamily: FontFamily.poppins,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Container(
                          //           height: 15,
                          //           width: 15,
                          //           decoration: BoxDecoration(
                          //               color: appColors.white,
                          //               shape: BoxShape.circle,
                          //               border: Border.all(
                          //                 color: appColors.black,
                          //               )),
                          //         ),
                          //         SizedBox(
                          //           width: 7,
                          //         ),
                          //         Text(
                          //           "Available",
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.sp,
                          //             fontFamily: FontFamily.poppins,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Container(
                          //           height: 15,
                          //           width: 15,
                          //           decoration: BoxDecoration(
                          //               color: appColors.red.withOpacity(0.5),
                          //               shape: BoxShape.circle,
                          //               border: Border.all(
                          //                 color: appColors.red,
                          //               )),
                          //         ),
                          //         SizedBox(
                          //           width: 7,
                          //         ),
                          //         Text(
                          //           "Selected",
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.sp,
                          //             fontFamily: FontFamily.poppins,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
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
                                  // Handle

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
                            if (controller.selectedTime == null) {
                              Fluttertoast.showToast(msg: "Please Select Time");
                            } else {
                              controller.submittingTraings();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: appColors.red,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: controller.submittingTrainingss == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Align(
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
          ),
        );
      },
    );
  }
}
