import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../gen/fonts.gen.dart';
import '../../screens/live_page/constant.dart';
import '../../screens/signature_module/view/face_verification_screen.dart';
import 'on_boarding_controller.dart';

class OnBoarding4Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoarding4 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
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
            body: Column(
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
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Astrologer’s Agreement",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.pdfPath != null
                      ? FutureBuilder<String>(
                          future: controller.pdfPath,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading PDF'));
                            } else {
                              return SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: PDFView(
                                  filePath: snapshot.data!,
                                  fitEachPage: false,
                                  fitPolicy: FitPolicy.BOTH,
                                  autoSpacing: false,
                                  onError: (error) {
                                    print(
                                        "objectobjectobjectobjectobject--${error}");
                                  },
                                  onPageChanged: (page, total) {
                                    print("totalpage---$total");
                                    print("page---$page");
                                    if (total == (page! + 1)) {
                                      controller.isLastPage = true;
                                    } else {
                                      controller.isLastPage = false;
                                    }
                                    controller.update();
                                  },

                                  // pageFling: true,
                                  // pageSnap: true,
                                ),
                              );
                            }
                          },
                        )
                      : SizedBox(),
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
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.stage4Submitting.value == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (onBoardingAgrrementSigned.value ==
                                        false) {
                                      Get.to(
                                          () => const FaceVerificationScreen(),
                                          arguments: "onBoarding");
                                    } else {
                                      controller.submitStage4();
                                    }

                                    // Get.offNamed(
                                    //   RouteName.addBankAutoMation,
                                    // );

                                    // onBoardingList.clear();
                                    // onBoardingList.add(1);
                                    // controller.navigateToStage();
                                    // controller.submittingDetails();
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        color:
                                            onBoardingAgrrementSigned.value ==
                                                    false
                                                ? appColors.white
                                                : appColors.red,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color:
                                              onBoardingAgrrementSigned.value ==
                                                      false
                                                  ? appColors.darkBlue
                                                      .withOpacity(0.8)
                                                  : appColors.red,
                                        )),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        onBoardingAgrrementSigned.value == false
                                            ? "Sign the Agreement"
                                            : "I Accept",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                          color:
                                              onBoardingAgrrementSigned.value ==
                                                      false
                                                  ? AppColors().darkBlue
                                                  : AppColors().white,
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
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.red,
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
