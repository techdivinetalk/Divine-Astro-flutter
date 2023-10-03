import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import 'package:path/path.dart' as p;

import '../../../repository/user_repository.dart';

class UploadStoryController extends GetxController {
  final Trimmer trimmer = Trimmer();
  RxBool? selectedFile = false.obs;

  double startValue = 0.0;
  double endValue = 0.0;

  RxBool isPlaying = false.obs;
  RxBool progressVisibility = false.obs;
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  final UserRepository userRepository = Get.find<UserRepository>();

  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();

    if (Get.arguments != null) {
      if (Get.arguments is String) {
        trimmer.loadVideo(videoFile: File(Get.arguments));
        selectedFile?.value = true;
      }
    }
  }

  saveVideo() {
    progressVisibility.value = true;
    trimmer.saveTrimmedVideo(
      startValue: startValue,
      endValue: endValue,
      onSave: (outputPath) {
        progressVisibility.value = false;
        debugPrint('OUTPUT PATH: $outputPath');
        uploadImageToS3Bucket(File(outputPath!));
      },
    );
  }

  uploadImageToS3Bucket(File? selectedFile) async {
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data.awsCredentails.baseurl?.split(".");
    var extension = p.extension(selectedFile!.path);

    var response = await AwsS3.uploadFile(
      accessKey: commonConstants.data.awsCredentails.accesskey!,
      secretKey: commonConstants.data.awsCredentails.secretKey!,
      file: selectedFile,
      bucket: dataString![0].split("//")[1],
      destDir: 'astrologer/${userData?.id}',
      filename: '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
      region: dataString[2],
    );
    if (response != null) {
      debugPrint("Uploaded Url : $response");
      await uploadStory(response);
      CustomException("Video uploaded successfully");
    } else {
      CustomException("Something went wrong");
    }
  }

  Future<void> uploadStory(String url) async {
    try {
      Map<String, dynamic> param = {"media_url": url};
      final response = await userRepository.uploadAstroStory(param);
      if (response.statusCode == 200 && response.success == true) {
        Get.back();
        divineSnackBar(data: "Story Uploaded Successfully");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Something went wrong");
      log(err.toString());
    }
  }
}
