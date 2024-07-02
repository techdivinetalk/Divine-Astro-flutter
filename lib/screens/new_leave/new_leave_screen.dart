import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/leave/LeaveReasonsModel.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/new_leave/new_leave_controller.dart';
import 'package:divine_astrologer/screens/new_leave/widgets/select_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common_functions.dart';
import '../../common/custom_progress_dialog.dart';

class NewLeaveScreen extends GetView<NewLeaveController> {
  NewLeaveScreen({super.key});

  List<String> _list = [
    'Law Earning',
    'Health Issues',
    'Better Opportunity',
    'Personal Reason',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewLeaveController>(
      init: NewLeaveController(UserRepository()),
      builder: (_) {
        return controller.isLoading.value == true
            ? const Center(
                child: LoadingWidget(),
              )
            : Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AbsorbPointer(
                          absorbing: controller.leaveStatus!.isOnLeave == true
                              ? true
                              : false,
                          child: InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: Get.context!,
                                  builder: (context) {
                                    return showSelectStartAndEndDate(
                                      looping: true,
                                      buttonTitle: "Confirm",
                                      initialStartDate: DateTime.now(),
                                      initialEndDate: DateTime.now(),
                                      onConfirmStart: (String value) {
                                        controller.setStartDate(value);
                                      },
                                      onConfirmEnd: (String value) {
                                        controller.setEndDate(value);
                                      },
                                      onEndChange: (String value) {
                                        controller.setEndDate(value);
                                      },
                                      onStartChange: (String value) {
                                        controller.setStartDate(value);
                                      },
                                    );
                                  });
                            },
                            child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.4,
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors().greyColor2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColors().black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          controller.leaveStatus!.data == null
                                              ? controller.startDate == null
                                                  ? "Start Date"
                                                  : controller.parseDate(
                                                      controller.startDate
                                                          .toString())
                                              : controller.leaveStatus!
                                                  .data!['start_date']
                                                  .toString(),
                                          style: AppTextStyle.textStyle14(
                                            fontWeight: FontWeight.w500,
                                            fontColor: AppColors().grey,
                                          ).copyWith(fontFamily: "Poppins"),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: controller.leaveStatus!.isOnLeave == true
                              ? true
                              : false,
                          child: InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: Get.context!,
                                  builder: (context) {
                                    return showSelectStartAndEndDate(
                                      looping: true,
                                      buttonTitle: "Confirm",
                                      initialStartDate: DateTime.now(),
                                      initialEndDate: DateTime.now(),
                                      onConfirmStart: (String value) {
                                        controller.setStartDate(value);
                                      },
                                      onConfirmEnd: (String value) {
                                        controller.setEndDate(value);
                                      },
                                      onEndChange: (String value) {
                                        controller.setEndDate(value);
                                      },
                                      onStartChange: (String value) {
                                        controller.setStartDate(value);
                                      },
                                    );
                                  });
                            },
                            child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.4,
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors().greyColor2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColors().black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          controller.leaveStatus!.data == null
                                              ? controller.endDate == null
                                                  ? "End Date"
                                                  : controller.parseDate(
                                                      controller.endDate
                                                          .toString())
                                              : controller.leaveStatus!
                                                  .data!['end_date']
                                                  .toString(),
                                          style: AppTextStyle.textStyle14(
                                            fontWeight: FontWeight.w500,
                                            fontColor: AppColors().grey,
                                          ).copyWith(fontFamily: "Poppins"),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    controller.loadingReasons.value == true ||
                            controller.leaveReasonModel == null
                        ? const Center(
                            child: LoadingWidget(),
                          )
                        : AbsorbPointer(
                            absorbing: controller.leaveStatus!.isOnLeave == true
                                ? true
                                : false,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors().greyColor2)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DropdownButton<Data>(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  hint: Text('Select Type'),
                                  value: controller.selectedReasonData,
                                  onChanged: (Data? newValue) {
                                    log(newValue!.reason.toString());
                                    log(newValue.haveComment.toString());

                                    log(newValue.id.toString());
                                    controller.updateSelectReason(newValue);
                                  },
                                  items: controller.leaveReasonModel?.data
                                      ?.map<DropdownMenuItem<Data>>(
                                          (Data reason) {
                                    return DropdownMenuItem<Data>(
                                      value: reason,
                                      child: Text(reason.reason!),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       border: Border.all(color: AppColors().greyColor2)),
                    //   child: CustomDropdown<String>(
                    //     decoration: CustomDropdownDecoration(
                    //         headerStyle: AppTextStyle.textStyle16(),
                    //         listItemStyle: AppTextStyle.textStyle16()),
                    //     closedHeaderPadding:
                    //         EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    //     hintText: 'Select job role',
                    //     items: _list,
                    //     initialItem: _list[0],
                    //     onChanged: (value) {},
                    //   ),
                    // ),
                    controller.selectedReasonData == null
                        ? SizedBox()
                        : controller.selectedReasonData!.haveComment == false
                            ? const SizedBox()
                            : AbsorbPointer(
                                absorbing:
                                    controller.leaveStatus!.isOnLeave == true
                                        ? true
                                        : false,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, right: 16, left: 16),
                                  child: TextFormField(
                                    controller: controller.textController,
                                    onChanged: (value) {
                                      controller.selectedReason = value;
                                      log(controller.selectedReason);
                                    },

                                    maxLines:
                                        3, // Adjust the number of lines as needed
                                    decoration: InputDecoration(
                                      hintText: "Reason here.....",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      hintStyle: AppTextStyle.textStyle16(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors().greyColor2),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors().greyColor2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors().greyColor2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors().greyColor2),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors().greyColor2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    Spacer(),
                    controller.leaveStatus!.data != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 15, bottom: 20),
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors().red)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: Colors.red.withOpacity(0.5),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      controller.getLeaveCancel();
                                      controller.textController.clear();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Cancel Leave",
                                        style: AppTextStyle.textStyle16(
                                          fontWeight: FontWeight.w500,
                                          fontColor: AppColors().red,
                                        ).copyWith(fontFamily: "Metropolis"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors().red)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.red.withOpacity(0.5),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (controller.selectedReasonData!
                                              .haveComment ==
                                          true &&
                                      controller.textController.text.isEmpty) {
                                    divineSnackBar(
                                        data: "Please add reason",
                                        color: appColors.redColor);
                                  } else if (controller.startDate == null ||
                                      controller.endDate == null) {
                                    divineSnackBar(
                                        data: "Please select Date",
                                        color: appColors.redColor);
                                  } else {
                                    controller.postLeaveSubmit();
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Submit Leave",
                                    style: AppTextStyle.textStyle16(
                                      fontWeight: FontWeight.w500,
                                      fontColor: AppColors().red,
                                    ).copyWith(fontFamily: "Metropolis"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
      },
    );
  }
}

appbarSmall1(BuildContext context, String title,
    {PreferredSizeWidget? bottom, Color? backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors().white,
    bottom: bottom,
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
      title,
      style: AppTextStyle.textStyle16(),
    ),
    // centerTitle: true,
  );
}
