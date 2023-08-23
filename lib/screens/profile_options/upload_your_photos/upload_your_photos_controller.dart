// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/app_exception.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../repository/user_repository.dart';

class UploadYourPhotosController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();
  List<File> selectedImages = [];
  final picker = ImagePicker();
  RxBool isImageUpdate = true.obs;
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();
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

  uploadImageToS3Bucket(List<File> selectedImages) async {
    List<String> uploadedURLs = [];
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data.awsCredentails.baseurl?.split(".");
    for (int i = 0; i < selectedImages.length; i++) {
      var extension = p.extension(selectedImages[i].path);

      var response = await AwsS3.uploadFile(
        accessKey: commonConstants.data.awsCredentails.accesskey!,
        secretKey: commonConstants.data.awsCredentails.secretKey!,
        file: selectedImages[i],
        bucket: dataString![0].split("//")[1],
        destDir: 'astrologer/${userData?.id}',
        filename:
            '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
        region: dataString[2],
      );
      if (response != null) {
        uploadedURLs.add(response);
        Get.back();
        Get.snackbar("Image uploaded successfully", "",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.white,
            colorText: AppColors.blackColor,
            duration: const Duration(seconds: 3));

        debugPrint("Uploaded Url : $response");
      } else {
        CustomException("Something went wrong");
      }
    }
    if (uploadedURLs.length == selectedImages.length) {
      Get.back();
      CustomException("Images uploaded successfully");
    }
  }
}
