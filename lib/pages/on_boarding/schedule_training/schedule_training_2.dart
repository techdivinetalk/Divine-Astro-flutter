import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/schedule_training/schedule_training_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/colors.dart';
import '../../../common/common_image_view.dart';
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
      init: ScheduleTrainingController(),
      assignId: true,
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
              //       controller.getAstroTra();
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
            body: controller.getCurrentTraining.value == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.astrologerTrainingSessionResponse == null
                    ? Center()
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            controller.astrologerTrainingSessionResponse ==
                                        null ||
                                    controller
                                        .astrologerTrainingSessionResponse!
                                        .data!
                                        .isEmpty ||
                                    controller
                                            .astrologerTrainingSessionResponse!
                                            .data ==
                                        null
                                ? SizedBox()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      // Parse the DateTime string
                                      DateTime parsedDateTime = DateTime.parse(
                                          controller
                                              .astrologerTrainingSessionResponse!
                                              .data![index]
                                              .meetingDate);

                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.5,
                                              color: appColors.grey
                                                  .withOpacity(0.4),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CommonImageView(
                                                    imagePath: controller
                                                                .preference
                                                                .getAmazonUrl() ==
                                                            null
                                                        ? Assets.images
                                                            .defaultProfile.path
                                                        : controller.preference
                                                                    .getUserDetail()!
                                                                    .image ==
                                                                null
                                                            ? Assets
                                                                .images
                                                                .defaultProfile
                                                                .path
                                                            : controller
                                                                    .preference
                                                                    .getAmazonUrl()
                                                                    .toString() +
                                                                controller
                                                                    .preference
                                                                    .getUserDetail()!
                                                                    .image
                                                                    .toString(),
                                                    height: 50,
                                                    width: 50,
                                                    placeHolder: Assets.images
                                                        .defaultProfile.path,
                                                  ),
                                                ),
                                                title: Text(
                                                  controller.preference
                                                          .getUserDetail()!
                                                          .name ??
                                                      "Astrologer",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.poppins,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.sp,
                                                    color: appColors.black,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  controller.specialityNames,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.poppins,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp,
                                                    color: appColors.grey,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: appColors.red
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4, bottom: 4),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month_outlined,
                                                              color:
                                                                  appColors.red,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              controller.formatDate(
                                                                  parsedDateTime
                                                                      .toString()),
                                                              // DateFormat(
                                                              //         'yyyy-MM-dd')
                                                              //     .format(
                                                              //         parsedDateTime)
                                                              //     .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .poppins,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.sp,
                                                                color: appColors
                                                                    .red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          child:
                                                              VerticalDivider(
                                                            width: 1,
                                                            color:
                                                                appColors.red,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .timer_outlined,
                                                              color:
                                                                  appColors.red,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                      'hh:mm a')
                                                                  .format(
                                                                      parsedDateTime)
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .poppins,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.sp,
                                                                color: appColors
                                                                    .red,
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
                                      );
                                    },
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
                      ),
            bottomNavigationBar: controller.astrologerTrainingSessionResponse ==
                        null ||
                    controller.astrologerTrainingSessionResponse!.data ==
                        null ||
                    controller.getCurrentTraining.value == true
                ? SizedBox(
                    height: 10,
                  )
                : Padding(
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
                                onTap: () async {
                                  if (controller.remaing2.isNegative) {
                                    Fluttertoast.showToast(
                                        msg: "Meeting has been ended");
                                  } else if (controller
                                              .astrologerTrainingSessionResponse!
                                              .data!
                                              .first
                                              .status
                                              .toString() ==
                                          "1" &&
                                      controller.remaing.isNegative) {
                                    String meetingLink = controller
                                        .astrologerTrainingSessionResponse!
                                        .data!
                                        .first
                                        .link;
                                    debugPrint("test_url: $meetingLink");

                                    if (await canLaunch(meetingLink)) {
                                      await launch(meetingLink);
                                    } else {
                                      throw 'Could not launch $meetingLink';
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Meeting is not started");
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: controller.remaing2.isNegative
                                        ? appColors.grey.withOpacity(0.4)
                                        : controller.astrologerTrainingSessionResponse!
                                                        .data!.first.status
                                                        .toString() ==
                                                    "1" &&
                                                controller.remaing.isNegative
                                            ? appColors.red
                                            : appColors.grey.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller
                                                  .astrologerTrainingSessionResponse!
                                                  .data!
                                                  .first
                                                  .meeting_date_epoch ==
                                              null
                                          ? "Join Training Session"
                                          : controller.remaing.isNegative
                                              ? controller.remaing2.isNegative
                                                  ? "Meeting Ended"
                                                  : "Join Training Session"
                                              : controller.formatDuration(
                                                  controller.remaing),
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
