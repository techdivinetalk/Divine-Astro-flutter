import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/common_image_view.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import 'on_boarding_controller.dart';

class OnBoarding5Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoarding5 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    controller.getStatusFromFir();
    controller.update();

    return GetBuilder<OnBoardingController>(
      assignId: true,
      init: OnBoardingController(),
      builder: (OnBoardingController controller) {
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
              //     icon: Icon(Icons.arrow_back_ios,
              //         color: Colors.black, size: 14),
              //     onPressed: () {
              //       Get.until(
              //         (route) {
              //           return Get.currentRoute == RouteName.dashboard;
              //         },
              //       );
              //     },
              //   ),
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
                    child: pageWidget("3"),
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
                  SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: CommonImageView(
                      imagePath: "assets/images/profile_review.png",
                      height: 100,
                      width: 100,
                      placeHolder: Assets.images.defaultProfile.path,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: appColors.grey.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Awaiting Approval",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: appColors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Our team is reviewing your documents. Once approved, you’ll be able to schedule your training.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: appColors.black,
                      ),
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
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // controller.getStatusFromFir();
                              // controller.update();
                              // if (controller.enableOrDisable.value.toString() ==
                              //         "0" ||
                              //     controller.enableOrDisable.value == null) {
                              // } else {
                              //   controller.updatePage(5);
                              //   controller.updateDonePage(4);
                              //   controller.currentPage = 5;
                              //   Get.offNamed(
                              //     RouteName.addBankAutoMation,
                              //   );
                              // }

                              Get.offNamed(
                                RouteName.onBoardingScreen2,
                              );
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: controller.enableOrDisable.value
                                                .toString() ==
                                            "0" ||
                                        controller.enableOrDisable.value == null
                                    ? appColors.grey.withOpacity(0.3)
                                    : appColors.red,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Add Bank Details",
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
                      );
                    }),
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
            color: AppColors().red,
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
            color: AppColors().white,
          ),
        ),
      ),
      buildLine(isActive: true),
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
          "3",
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
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
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
              color: appColors.red,
              width: 1,
            )),
        padding: EdgeInsets.all(6),
        child: Icon(
          Icons.timer_outlined,
          color: appColors.red,
          size: 20,
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
