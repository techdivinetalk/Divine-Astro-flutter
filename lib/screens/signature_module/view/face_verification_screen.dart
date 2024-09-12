import 'dart:io';

import 'package:camera/camera.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/common_button.dart';
import 'package:divine_astrologer/screens/signature_module/controller/face_verification_controller.dart';
import 'package:divine_astrologer/screens/signature_module/widget/front_camera_view.dart';
import 'package:divine_astrologer/screens/signature_module/widget/upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceVerificationScreen extends GetView<FaceVerificationController> {
  const FaceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaceVerificationController>(
      assignId: true,
      init: FaceVerificationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            title: Text("Upload Selfie",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          bottomNavigationBar: Obx(() {
            return controller.uploadingImage.value == true
                ? SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()))
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: CommonButton(
                      buttonText: "Upload",
                      buttonCallback: () {
                        if (controller.kycImage.isNotEmpty) {
                          controller.uploadFaceImage(File(controller.kycImage));
                        }
                      },
                    ),
                  );
          }),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Container(
                  height: 328,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: UploadWidget(
                    height: 328,
                    onTap: () async {
                      List<CameraDescription> cameras =
                          await availableCameras();
                      Get.to(() => FrontCameraView(
                                cameras: cameras,
                              ))!
                          .then(
                        (value) {
                          controller.kycImage = value;
                          controller.update();
                        },
                      );
                      // try {
                      //   String kycImage = await controller.imagePicker();
                      //   if (kycImage.isNotEmpty) {
                      //     controller.kycImage = kycImage;
                      //     controller.update();
                      //   }
                      // } catch (e) {
                      //   log("error while uploading back adhar card ${e}");
                      // }
                    },
                    imageFile: controller.kycImage,
                    title: "Upload your selfie",
                    removeOnTap: () {
                      controller.kycImage = "";
                      controller.update();
                    },
                  )),
            ],
          ),
        );
      },
    );
  }
}
