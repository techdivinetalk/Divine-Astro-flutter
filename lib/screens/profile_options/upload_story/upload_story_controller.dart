import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:video_trimmer/video_trimmer.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../repository/user_repository.dart';

class UploadStoryController extends GetxController {
  Trimmer trimmer = Trimmer();
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
      trimmer.loadVideo(videoFile: File(Get.arguments));

      selectedFile?.value = true;
      update();
    }
  }

  saveVideo() {
    progressVisibility.value = true;
    trimmer.saveTrimmedVideo(
      startValue: startValue,
      endValue: endValue,
      onSave: (outputPath) async {
        progressVisibility.value = false;

        uploadImageToS3Bucket(File(outputPath!),
            duration: ((endValue - startValue) / 1000).toString());
      },
    );
  }

  uploadImageToS3Bucket(File? selectedFile, {String? duration}) async {
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
    var extension = p.extension(selectedFile!.path);

    var response = await AwsS3.uploadFile(
      accessKey: commonConstants.data!.awsCredentails.accesskey!,
      secretKey: commonConstants.data!.awsCredentails.secretKey!,
      file: selectedFile,
      bucket: dataString![0].split("//")[1],
      destDir: 'astrologer/${userData?.id}',
      filename: '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
      region: dataString[2],
    );
    if (response != null) {
      debugPrint("Uploaded Url : $response");
      await uploadStory(response, duration: duration);
      CustomException("Video uploaded successfully");
    } else {
      CustomException("Something went wrong");
    }
  }

  String encodeString(String originalString) {
    String encodedString = base64Encode(utf8.encode(originalString));
    return encodedString;
  }

  String encodedURLFunction() {
    final Map<dynamic, dynamic> map = {
      "astrologer_id": userData?.id.toString(),
    };
    final Uri encoded = Uri.parse("https://divinetalk.in");
    final String path = "page=astrologerProfile&param=${json.encode(map)}";
    final String encode = encodeString(path);
    final String fullEncodeURL = "${encoded.scheme}://${encoded.host}?$encode";
    return fullEncodeURL;
  }

  Future<void> uploadStory(String url, {String? duration}) async {
    String fullEncodeURL = encodedURLFunction();
    print("fullEncodeURL: $fullEncodeURL");
    //
    // try {
    //   Map<String, dynamic> param = {
    //     "media_url": url,
    //     "astrologer_id": userData?.id,
    //     "duration": duration,
    //     "link": fullEncodeURL,
    //   };
    //   final response = await userRepository.uploadAstroStory(param);
    //   if (response.statusCode == 200 && response.success == true) {
    //     Get.back();
    //     divineSnackBar(data: "Story Uploaded Successfully");
    //   }
    // } catch (err) {
    //   Fluttertoast.showToast(msg: "Something went wrong");
    //   log(err.toString());
    // }
  }
}
