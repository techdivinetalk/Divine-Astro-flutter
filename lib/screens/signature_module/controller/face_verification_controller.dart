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

import '../../live_page/constant.dart';

class FaceVerificationController extends GetxController
    with WidgetsBindingObserver {
  String kycImage = "";
  String argu = "";
  @override
  void onInit() {
    if (Get.arguments != null) {
      argu = Get.arguments;
      print(argu);
    }
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

  var uploadingImage = false.obs;
  Future<void> uploadFaceImage(File imageFile) async {
    log("uploadFaceImage-----uploadFaceImage");
    uploadingImage.value = true;
    update();
    UserData? userData = await pref.getUserDetail();
    try {
      var uri =
          "${isLiveServer.value == 0 ? ApiProvider.agreementBaseDebug : ApiProvider.agreementBase}${ApiProvider.astrologerFaceVerification}${userData!.id}";
      var data = await Dio().get(uri,
          data: FormData.fromMap({
            "imageFile": imageFile != null
                ? await MultipartFile.fromFile(imageFile!.path,
                    filename: imageFile.path.split('/').last)
                : null,
          }));
      AgreementModel agreementModel = AgreementModel.fromJson(data.data);
      if (agreementModel.status!.code == 200) {
        uploadingImage.value = false;
        update();
        if (argu == "") {
          Get.to(() => SignatureView(), arguments: {
            "astrologerProfilePhoto": agreementModel.data!.imageLink,
          });
        } else {
          Get.to(() => SignatureView(), arguments: {
            "astrologerProfilePhoto": agreementModel.data!.imageLink,
            "from": argu
          });
        }
        // Get.to(() => SignatureView(), arguments: {
        //   "astrologerProfilePhoto": agreementModel.data!.imageLink,
        // });
        log("agreementModel.data!.imageLink----->>>${agreementModel.data!.imageLink}");
      }
    } on DioException catch (e) {
      log("objectobjectobjectobject----${e}");
    }
  }
}
