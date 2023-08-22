// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/custom_light_yellow_btn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_exception.dart';
import '../../../di/api_provider.dart';
import '../../../gen/assets.gen.dart';
import 'upload_your_photos_controller.dart';
import 'package:path/path.dart' as p;

class UploadYourPhotosUi extends GetView<UploadYourPhotosController> {
  List<File> selectedImages = [];
  final picker = ImagePicker();
  RxBool isImageUpdate = true.obs;

  UploadYourPhotosUi({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(UploadYourPhotosController());
    return Scaffold(
      appBar: commonDetailAppbar(title: "Upload your photos"),
      //  getImages();
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Obx(() => isImageUpdate.value
                ? Expanded(
                    child: SizedBox(
                      width: 300.0,
                      child: selectedImages.isEmpty
                          ? InkWell(
                              onTap: () {
                                getImages();
                              },
                              child: Center(
                                  child: Assets.images.icUploadStory
                                      .svg(width: 30.h, height: 30.h)),
                            )
                          : GridView.builder(
                              itemCount: selectedImages.length == 5
                                  ? selectedImages.length
                                  : selectedImages.length + 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                    child: index == 5 ||
                                            index == selectedImages.length
                                        ? InkWell(
                                            onTap: () {
                                              getImages();
                                            },
                                            child: Assets.images.icUploadStory
                                                .svg(width: 30.h, height: 30.h),
                                          )
                                        : Image.file(selectedImages[index]));
                              },
                            ),
                    ),
                  )
                : Container()),
            Obx(() => isImageUpdate.value
                ? CustomLightYellowButton(name: "Upload Images", onTaped: () {})
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  Future getImages() async {
    isImageUpdate.value = false;
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
        isImageUpdate.value = true;
      }
    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  uploadImageToS3Bucket(File? selectedFile, {required String filename}) async {
    // var userData = preference.getUserDetail();
    var extension = p.extension(selectedFile!.path);

    var response = await AwsS3.uploadFile(
      accessKey: ApiProvider().awsAccessKey,
      secretKey: ApiProvider().awsSecretKey,
      file: selectedFile,
      bucket: ApiProvider().awsBucket,
      destDir: 'astrologer/573',
      filename: '$filename$extension',
      region: ApiProvider().awsRegion,
    );
    if (response != null) {
      debugPrint("Uploaded Url : $response");
    } else {
      CustomException("Something went wrong");
    }
  }
}
