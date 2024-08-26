import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../on_boarding_controller.dart';

class OnBoardingUploadImagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}

class OnBoardingUploadImages extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      builder: (OnBoardingController controller) {
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
                      controller.currentPage.toString(), appColors.red),
                  pageWidget("2", "Upload\nPictures",
                      controller.currentPage.toString(), appColors.grey),
                  pageWidget("3", "Signing\nAgreement",
                      controller.currentPage.toString(), appColors.grey),
                  pageWidget("4", "Awaiting\nApproval",
                      controller.currentPage.toString(), appColors.grey),
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
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                color: AppColors().grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: controller.userImages.isEmpty ||
                                      controller.userImages.contains(1) ||
                                      controller.userImages.contains(2) ||
                                      controller.userImages.contains(3) ||
                                      controller.userImages.contains(4) ||
                                      controller.userImages.contains(5)
                                  ? Icon(
                                      Icons.add,
                                      color: AppColors().white,
                                      size: 80,
                                    )
                                  : Image.file(
                                      File(controller.userImages[index]),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
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
                      ? null
                      : () {},
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

Widget pageWidget(page, detail, selectedPage, color) {
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
              color: color,
            ),
    ],
  );
}
