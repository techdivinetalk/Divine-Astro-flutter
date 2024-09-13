import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/common_image_view.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../screens/live_page/constant.dart';
import 'on_boarding_controller.dart';

class OnBoarding3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoarding3 extends GetView<OnBoardingController> {
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
            body: SingleChildScrollView(
              controller: controller.scrollController3,
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
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upload Your Profile Picture",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: controller.scrollController3,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 2 boxes per row
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: controller.userImages.length,
                            itemBuilder: (context, index) {
                              var item = controller.userImages[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  controller.getImage(index);
                                },
                                child: Container(
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                    color: AppColors().grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: controller.userImages[index] is String
                                      ? CommonImageView(
                                          imagePath:
                                              controller.userImages[index],
                                          fit: BoxFit.cover,
                                          placeHolder:
                                              Assets.images.defaultProfile.path,
                                          radius: BorderRadius.circular(20.h),
                                        )
                                      : controller.userImages[index] is int
                                          ? Icon(
                                              Icons.add,
                                              color: AppColors().white,
                                              size: 80,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                controller.userImages[index],
                                                fit: BoxFit.cover,
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
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "*Atleast Upload 2 Images",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: appColors.red,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "*Valid Profile Picture Examples",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: appColors.grey,
                        ),
                      ),
                    ),
                  ),
                  controller.demoImage.isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  controller: controller.scrollController3,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 3 boxes per row
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.5,
                                  ),
                                  itemCount: controller.demoImage.length,
                                  itemBuilder: (context, index) {
                                    print(
                                        "images printing ------ ${controller.demoImage}");
                                    // Fetch the image path or fallback to default
                                    String imagePath = controller
                                            .demoImage.isNotEmpty
                                        ? controller.preference
                                                .getAmazonUrl()
                                                .toString() +
                                            "/" +
                                            controller.demoImage[index]['path']
                                        : Assets.images.defaultProfile.path;
                                    return Column(
                                      children: [
                                        CommonImageView(
                                          imagePath: imagePath,
                                          height: 90.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          fit: BoxFit.cover,
                                          placeHolder:
                                              Assets.images.defaultProfile.path,
                                          radius: BorderRadius.circular(20.h),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: controller
                                                      .demoImage[index]
                                                          ['status']
                                                      .toString() ==
                                                  "1"
                                              ? appColors.green
                                              : appColors.appRedColour,
                                          child: Icon(
                                            controller.demoImage[index]
                                                            ['status']
                                                        .toString() ==
                                                    "1"
                                                ? Icons.check
                                                : Icons.clear,
                                            color: appColors.white,
                                            size: 15,
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         CommonImageView(
                  //           imagePath: "assets/images/demo-1.png",
                  //           height: 80.h,
                  //           width: 80.h,
                  //           placeHolder: Assets.images.defaultProfile.path,
                  //           radius: BorderRadius.circular(20.h),
                  //         ),
                  //         SizedBox(
                  //           height: 8,
                  //         ),
                  //         CircleAvatar(
                  //           radius: 12,
                  //           backgroundColor: appColors.appRedColour,
                  //           child: Icon(
                  //             Icons.clear,
                  //             color: appColors.white,
                  //             size: 15,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         CommonImageView(
                  //           imagePath: "assets/images/demo-2.png",
                  //           height: 80.h,
                  //           width: 80.h,
                  //           placeHolder: Assets.images.defaultProfile.path,
                  //           radius: BorderRadius.circular(20.h),
                  //         ),
                  //         SizedBox(
                  //           height: 8,
                  //         ),
                  //         CircleAvatar(
                  //           radius: 12,
                  //           backgroundColor: appColors.appRedColour,
                  //           child: Icon(
                  //             Icons.clear,
                  //             color: appColors.white,
                  //             size: 15,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         CommonImageView(
                  //           imagePath: "assets/images/demo-3.png",
                  //           height: 80.h,
                  //           width: 80.h,
                  //           placeHolder: Assets.images.defaultProfile.path,
                  //           radius: BorderRadius.circular(20.h),
                  //         ),
                  //         SizedBox(
                  //           height: 8,
                  //         ),
                  //         CircleAvatar(
                  //           radius: 12,
                  //           backgroundColor: appColors.green,
                  //           child: Icon(
                  //             Icons.check,
                  //             color: appColors.white,
                  //             size: 15,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: onboarding_training_videoData == "" ||
                        onboarding_training_videoData == null ||
                        onboarding_training_videoData.contains("null")
                    ? 60
                    : 110,
                child: Column(
                  children: [
                    onboarding_training_videoData == "" ||
                            onboarding_training_videoData == null ||
                            onboarding_training_videoData.contains("null")
                        ? SizedBox()
                        : Padding(
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
                            controller.checkSelectedImages();
                          },
                          child: Obx(() {
                            return controller.stage3Submitting.value == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: appColors.red,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Align(
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
                                  );
                          }),
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
            color: AppColors().white,
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
