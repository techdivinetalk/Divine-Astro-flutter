import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_progress_dialog.dart';
import 'package:divine_astrologer/model/resignation/ResignationReasonModel.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/common_functions.dart';
import 'new_registration_controller.dart';

class NewRegstrationScreen extends GetView<NewRegistrationController> {
  NewRegstrationScreen({super.key});

  List<String> _list = [
    'Law Earning',
    'Health Issues',
    'Better Opportunity',
    'Personal Reason',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRegistrationController>(
      init: NewRegistrationController(UserRepository()),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: controller.isLoading.value == true
              ? const Center(
                  child: LoadingWidget(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    controller.loadingReasons.value == true ||
                            controller.resignationReasonModel == null
                        ? const Center(
                            child: LoadingWidget(),
                          )
                        : AbsorbPointer(
                            absorbing:
                                controller.resignationStatus!.isResign == true
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
                                    log(newValue.id.toString());
                                    controller.updateSelectReason(newValue);
                                  },
                                  items: controller.resignationReasonModel?.data
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
                    controller.selectedReasonData == null
                        ? SizedBox()
                        : controller.selectedReasonData!.haveComment == false
                            ? SizedBox()
                            : AbsorbPointer(
                                absorbing:
                                    controller.resignationStatus!.isResign ==
                                            true
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Having Issues? ',
                              style: AppTextStyle.textStyle14(),
                              // Single tapped.
                            ),
                            TextSpan(
                              text: 'Call Now!',
                              style: AppTextStyle.textStyle14(
                                fontColor: AppColors().red,
                              ).copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    controller.resignationStatus!.status == "pending" ||
                            controller.resignationStatus!.isResign == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Resignation Status - ',
                                      style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: "Metropolis"),
                                      // Single tapped.
                                    ),
                                    TextSpan(
                                      text: controller.resignationStatus!
                                                  .data['status'] ==
                                              "pending"
                                          ? 'Pending'
                                          : controller.resignationStatus!
                                              .data['approval_date'],
                                      style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w500,
                                        fontColor: AppColors().red,
                                      ).copyWith(fontFamily: "Metropolis"),
                                    ),
                                  ],
                                ),
                              ),
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
                                      controller.showRichText(false);
                                      controller.getResignationCancel();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Cancel Resignation",
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
                                  } else {
                                    controller.postResignationSubmit();
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Submit Resignation",
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

// MyDropDown(
//   shape: RoundedRectangleBorder(
//       side: const BorderSide(color: colorBlack, width: 1),
//       borderRadius: constants.borderRadius),
//   color: colorBgLight,
//   borderWidth: 0.0,
//   icon: const Icon(
//     Icons.keyboard_arrow_down_rounded,
//     size: 30,
//     color: colorBlack,
//   ),
//   hintText: 'Select Subject',
//   defaultValue:  controller.selectedSubject.value,
//   style: AppTextStyle.smallText.copyWith(
//       color: Colors.black45, fontWeight: FontWeight.bold),
//   onChange: (value) {
//     controller.selectedSubject(value);
//   },
//   array: _list,
// ),
