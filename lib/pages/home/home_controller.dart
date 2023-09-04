import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = false.obs;
  RxBool callSwitch = false.obs;
  RxBool consultantOfferSwitch = false.obs;
  RxBool promotionOfferSwitch = false.obs;
  RxString appbarTitle = "Astrologer Name  ".obs;
  RxBool isShowTitle = true.obs;
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();
  UserData? userData = UserData();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  final UserRepository userRepository = Get.put(UserRepository());
  int scoreIndex = 0;
  List<Map<String, dynamic>> yourScore = [
    {"title": "Your Conversion Rate", "score": "80"},
    {"title": "Your Repurchase Rate", "score": "60"},
    {"title": "Your Online Hours", "score": "50"},
    {"title": "Your Live Hours", "score": "70"},
    {"title": "E-Commerce", "score": "80"},
    {"title": "Your Busy Hours", "score": "60"},
  ];

  onNextTap() {
    if (scoreIndex < yourScore.length - 1) {
      scoreIndex++;
      update(['score_update']);
    }
  }

  onPreviousTap() {
    if (scoreIndex > 0) {
      scoreIndex--;
      update(['score_update']);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // getConstantDetailsData();
    userData = preferenceService.getUserDetail();
    appbarTitle.value = userData?.name ?? "Astrologer Name";
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  getConstantDetailsData() async {
    try {
      var data = await userRepository.constantDetailsData();
      getConstantDetails = data;
      // debugPrint("ConstantDetails Data==> $data");
      profileDataSync.value = true;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  whatsapp() async {
    var contact = getConstantDetails?.data.whatsappNo ?? '';
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      log('WhatsApp is not installed.');
    }
  }
}
