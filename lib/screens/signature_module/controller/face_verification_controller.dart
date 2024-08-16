import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:divine_astrologer/screens/signature_module/model/agreement_model.dart';
import 'package:divine_astrologer/screens/signature_module/view/signature_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

class FaceVerificationController extends GetxController
    with WidgetsBindingObserver {
  String kycImage = "";

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  /// image picker
  imagePicker() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    // String? imagePath;
    if (image != null) {
      return image.path;
    } else {
      return null;
    }
  }

  Future<void> uploadFaceImage(File imageFile) async {
    UserData? userData = await pref.getUserDetail();
    try {
      var uri = "${ApiProvider.astrologerFaceVerification}${userData!.id}";
      var data = await Dio().get(uri,
          data: FormData.fromMap({
            "imageFile": imageFile != null
                ? await MultipartFile.fromFile(imageFile!.path,
                    filename: imageFile.path.split('/').last)
                : null,
          }));
      AgreementModel agreementModel = AgreementModel.fromJson(data.data);
      if (agreementModel.status!.code == 200) {
        Get.to(() => SignatureView(), arguments: {
          "astrologerProfilePhoto": agreementModel.data!.imageLink,
        });
        print(
            "agreementModel.data!.imageLink----->>>${agreementModel.data!.imageLink}");
      }
    } on DioException catch (e) {
      print("objectobjectobjectobject----${e}");
    }
  }
}