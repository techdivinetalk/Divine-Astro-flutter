// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_light_yellow_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import 'upload_your_photos_controller.dart';

class UploadYourPhotosUi extends GetView<UploadYourPhotosController> {
  const UploadYourPhotosUi({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UploadYourPhotosController());
    return Scaffold(
      appBar: commonDetailAppbar(title: "uploadYourPhotos".tr),
      //  getImages();
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GetBuilder<UploadYourPhotosController>(
              builder: (controller) => Expanded(
                child: SizedBox(
                  width: 300.0,
                  child: GridView.builder(
                      itemCount: controller.selectedImages.length + 1 < 6
                          ? controller.selectedImages.length + 1
                          : controller.selectedImages.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return index == controller.selectedImages.length
                            ? InkWell(
                                onTap: () => controller.getImages(),
                                child: Container(
                                  width: ScreenUtil().screenWidth * 0.35,
                                  height: ScreenUtil().screenWidth * 0.35,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 1.0,
                                        offset: const Offset(0.0, 3.0),
                                      ),
                                    ],
                                    color: AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Assets.images.icUploadStory
                                        .svg(width: 30.h, height: 30.h),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 1.0,
                                              offset: const Offset(0.0, 3.0)),
                                        ],
                                        color: AppColors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      width: ScreenUtil().screenWidth * 0.35,
                                      height: ScreenUtil().screenWidth * 0.35,
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.file(
                                        controller.selectedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.removeImages(controller
                                          .selectedImages[index].path);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.blackColor),
                                          child: const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      }),
                ),
              ),
            ),
            GetBuilder<UploadYourPhotosController>(
              builder: (controller) => CustomLightYellowButton(
                name: "uploadImages".tr,
                onTaped: () {
                  if (controller.selectedImages.length <= 5) {
                    controller.uploadImageToS3Bucket(controller.selectedImages);
                  } else {
                    divineSnackBar(data: "imageValidationMsg".tr);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
