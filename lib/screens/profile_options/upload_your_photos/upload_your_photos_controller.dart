import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/upload_image_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
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
  List<File> selectedImages = <File>[];
  final picker = ImagePicker();
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();
  }

  Future<CroppedFile?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );
    return croppedFile;
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    List<XFile> xFilePick = pickedFile;

    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        if (selectedImages
            .any((element) => element.path == xFilePick[i].path)) {
          divineSnackBar(data: "This image already selected.");
        } else {
          // selectedImages.add(File(xFilePick[i].path));

          CroppedFile? croppedFile = await cropImage(File(xFilePick[i].path));
          if (croppedFile != null) {
            selectedImages.add(File(croppedFile.path));
          }
        }
      }
      update();
    } /*else {
      // Use Get.context for the correct context
      ScaffoldMessenger.of(Get.overlayContext ?? Get.context!)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }*/
  }

  void removeImages(String value) {
    selectedImages.removeWhere((element) => element.path == value);
    update();
  }

  uploadImageToS3Bucket(List<File> selectedImages) async {
    List<Future> futures = <Future>[];
    var commonConstants = await userRepository.constantDetailsData();
    var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
    for (int i = 0; i < selectedImages.length; i++) {
      var extension = p.extension(selectedImages[i].path);
      futures.add(
        AwsS3.uploadFile(
          accessKey: commonConstants.data!.awsCredentails.accesskey!,
          secretKey: commonConstants.data!.awsCredentails.secretKey!,
          file: selectedImages[i],
          bucket: dataString![0].split("//")[1],
          destDir: 'astrologer/${userData?.id}',
          filename:
              '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
          region: dataString[2],
        ),
      );
    }
    List<dynamic> response = await Future.wait(futures);
    if (response.isNotEmpty) {
      isLoading.value = true;
      try {
        final pref = Get.find<SharedPreferenceService>();
        UploadImageRequest request = UploadImageRequest(
          images: response.map((e) => e.toString()).toList(),
          astroId: "${pref.getUserDetail()?.id}",
        );
        final imageUpload =
            await userRepository.uploadYourPhotoApi(request.toJson());
        if (imageUpload.success && imageUpload.statusCode == 200) {
          isLoading.value = false;
          Get.back();
          divineSnackBar(data: "Image uploaded successfully");
          debugPrint("Uploaded Url : $response");
        }
      } catch (err) {
        isLoading.value = false;
        if (err is AppException) {
          err.onException();
        }
      }
    } else {
      isLoading.value = false;
      CustomException("Something went wrong");
    }
  }
}
