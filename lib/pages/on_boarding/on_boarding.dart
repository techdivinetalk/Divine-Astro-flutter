import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/routes.dart';
import 'on_boarding_controller.dart';

class OnBoarding extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      assignId: true,
      init: OnBoardingController(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  pageWidget("1", "Upload\nDocuments",
                      controller.currentPage.toString()),
                  pageWidget("2", "Upload\nPictures",
                      controller.currentPage.toString()),
                  pageWidget("3", "Signing\nAgreement",
                      controller.currentPage.toString()),
                  pageWidget("4", "Awaiting\nApproval",
                      controller.currentPage.toString()),
                ],
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
                            child: controller.selectedAadharFront != null
                                ? Image.file(
                                    controller.selectedAadharFront,
                                    fit: BoxFit.cover,
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
                            child: controller.selectedAadharBack != null
                                ? Image.file(
                                    controller.selectedAadharBack,
                                    fit: BoxFit.cover,
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
                            controller.getImage('pan');
                          },
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: AppColors().grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: controller.selectedPanFront != null
                                ? Image.file(
                                    controller.selectedPanFront,
                                    fit: BoxFit.cover,
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: controller.selectedPanFront == null ||
                          controller.selectedAadharFront == null ||
                          controller.selectedAadharBack == null
                      ? () {
                          log("----");
                        }
                      : () {
                          Get.toNamed(
                            RouteName.OnBoardingUploadImages,
                          );
                        },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: controller.selectedPanFront == null ||
                              controller.selectedAadharFront == null ||
                              controller.selectedAadharBack == null
                          ? appColors.grey.withOpacity(0.4)
                          : appColors.red,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget pageWidget(page, detail, selectedPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: selectedPage == page ? AppColors().red : appColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      selectedPage == page ? AppColors().red : appColors.grey,
                  width: 1,
                )),
            padding: EdgeInsets.all(12),
            child: Text(
              page,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: selectedPage == page ? appColors.white : appColors.grey,
              ),
            ),
          ),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: appColors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
      page == "4"
          ? SizedBox()
          : Container(
              height: 2,
              width: MediaQuery.of(Get.context!).size.width * 0.1,
              color: AppColors().grey,
            ),
    ],
  );
}
