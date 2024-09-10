import 'package:divine_astrologer/pages/on_boarding/widgets/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/common_image_view.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import 'on_boarding_controller.dart';

class OnBoarding2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoarding2 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      assignId: true,
      init: OnBoardingController(),
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
              // padding: const EdgeInsets.only(bottom: 2.0),
              // child: IconButton(
              //   visualDensity: const VisualDensity(horizontal: -4),
              //   constraints: BoxConstraints.loose(Size.zero),
              //   icon:
              //       Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
              //   onPressed: () {
              //     Get.until(
              //       (route) {
              //         return Get.currentRoute == RouteName.dashboard;
              //       },
              //     );
              //   },
              // ),
              // ),
              titleSpacing: 20,
              title: Text(
                "Onboarding Process",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: pageWidget('2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Basic\nDetails",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: appColors.black.withOpacity(0.7),
                          ),
                        ),
                        buildSpace(),
                        Text(
                          "Upload\nDocuments",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: appColors.black.withOpacity(0.7),
                          ),
                        ),
                        buildSpace(),
                        Text(
                          "Upload\nPictures",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: appColors.black.withOpacity(0.7),
                          ),
                        ),
                        buildSpace(),
                        Text(
                          "Signing\nAgreement",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: appColors.black.withOpacity(0.7),
                          ),
                        ),
                        buildSpace(),
                        Text(
                          "Awaiting\nApproval",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: appColors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upload Aadhar Card",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CustomTextField(
                      controller: controller.aadharController,
                      focusNode: controller.aadharNode,
                      onFieldSubmitted: (value) {
                        controller.aadharNode.unfocus();
                      },
                      keyboardType: TextInputType.number,
                      prefix: Icon(
                        Icons.verified_user_outlined,
                        color: appColors.black.withOpacity(0.5),
                      ),
                      readOnly: false,
                      hint: "Aadhar Card Number",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                controller.getImage("af");
                              },
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: AppColors().grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: controller.verifyAadharFront != null &&
                                        controller.selectedAadharFront == null
                                    ? CommonImageView(
                                        imagePath: controller.verifyAadharFront,
                                        fit: BoxFit.cover,
                                        placeHolder:
                                            Assets.images.defaultProfile.path,
                                        radius: BorderRadius.circular(20.h),
                                      )
                                    : controller.photoUrlAadharFront != null
                                        ? CommonImageView(
                                            imagePath:
                                                controller.photoUrlAadharFront,
                                            fit: BoxFit.cover,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                            radius: BorderRadius.circular(20.h),
                                          )
                                        : controller.selectedAadharFront != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.h),
                                                child: Image.file(
                                                  controller
                                                      .selectedAadharFront,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Icon(
                                                Icons.add,
                                                color: AppColors().white,
                                                size: 80,
                                              ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Front Side",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: AppColors().grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                controller.getImage("ab");
                              },
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: AppColors().grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: controller.verifyAadharBack != null &&
                                        controller.selectedAadharBack == null
                                    ? CommonImageView(
                                        imagePath: controller.verifyAadharBack,
                                        fit: BoxFit.cover,
                                        placeHolder:
                                            Assets.images.defaultProfile.path,
                                        radius: BorderRadius.circular(20.h),
                                      )
                                    : controller.photoUrlAadharBack != null
                                        ? CommonImageView(
                                            imagePath:
                                                controller.photoUrlAadharBack,
                                            fit: BoxFit.cover,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                            radius: BorderRadius.circular(20.h),
                                          )
                                        : controller.selectedAadharBack != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.h),
                                                child: Image.file(
                                                  controller.selectedAadharBack,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Icon(
                                                Icons.add,
                                                color: AppColors().white,
                                                size: 80,
                                              ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Back Side",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: AppColors().grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upload Pan Card",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CustomTextField(
                      controller: controller.pancardController,
                      focusNode: controller.pancardNode,
                      onFieldSubmitted: (value) {
                        controller.aadharNode.unfocus();
                      },
                      keyboardType: TextInputType.text,
                      prefix: Icon(
                        Icons.verified_user_outlined,
                        color: appColors.black.withOpacity(0.5),
                      ),
                      readOnly: false,
                      hint: "Pancard Number",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                controller.getImage('panFront');
                              },
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: AppColors().grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: controller.verifyPanFront != null &&
                                        controller.selectedPanFront == null
                                    ? CommonImageView(
                                        imagePath: controller.verifyPanFront,
                                        fit: BoxFit.cover,
                                        placeHolder:
                                            Assets.images.defaultProfile.path,
                                        radius: BorderRadius.circular(20.h),
                                      )
                                    : controller.photoUrlPanFront != null
                                        ? CommonImageView(
                                            imagePath:
                                                controller.photoUrlPanFront,
                                            fit: BoxFit.cover,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                            radius: BorderRadius.circular(20.h),
                                          )
                                        : controller.selectedPanFront != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.h),
                                                child: Image.file(
                                                  controller.selectedPanFront,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Icon(
                                                Icons.add,
                                                color: AppColors().white,
                                                size: 80,
                                              ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Front Side",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: AppColors().grey,
                                  ),
                                ),
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
                            if (controller.selectedAadharBack == null ||
                                controller.selectedAadharFront == null ||
                                controller.selectedPanFront == null) {
                              Fluttertoast.showToast(
                                  msg: "Image is not selected");
                            } else {
                              // if (controller.photoUrlPanFront == null ||
                              //     controller.photoUrlAadharBack == null ||
                              //
                              //     controller.photoUrlAadharBack == null) {
                              //   print("uploadinggggg");
                              //   for (int i = 0; i < 3; i++) {
                              //     // Your code here will run 3 times
                              //     if (i == 1) {
                              //       controller.uploadImage(
                              //           controller.selectedAadharFront,
                              //           "aadharFront");
                              //       print("Iteration: ${i + 1}");
                              //     } else if (i == 2) {
                              //       controller.uploadImage(
                              //           controller.selectedAadharBack,
                              //           "aadharBack");
                              //       print("Iteration: ${i + 1}");
                              //     } else {
                              //       controller.uploadImage(
                              //           controller.selectedAadharFront,
                              //           "aadharFront");
                              //     }
                              //   }
                              // } else {
                              if (controller.aadharController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Aadhar card is not valid");
                              } else if (controller
                                  .pancardController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Pancard card is not valid");
                              } else {
                                controller.submitStage2();
                              }

                              // if (isRejected.value == true) {
                              //   controller.submitStage2();
                              // } else {
                              //   controller.navigateToStage();
                              // }
                              // }
                            }
                          },
                          child: controller.stage2Submitting.value == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: controller.selectedAadharBack ==
                                                null ||
                                            controller.selectedAadharFront ==
                                                null ||
                                            controller.selectedPanFront == null
                                        ? appColors.grey.withOpacity(0.4)
                                        : appColors.red,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: controller.stage2Submitting == true
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: appColors.white,
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Next",
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

Widget pageWidget(page) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "1",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.white,
          ),
        ),
      ),
      buildLine(isActive: true),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "2",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: AppColors().red,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "3",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "5",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
    ],
  );
}

Widget buildLine({required bool isActive}) {
  return Expanded(
    child: Container(
      height: 2,
      color: isActive ? Colors.red : appColors.grey.withOpacity(0.7),
    ),
  );
}

Widget buildSpace() {
  return Expanded(
    child: Container(
      height: 2,
    ),
  );
}
