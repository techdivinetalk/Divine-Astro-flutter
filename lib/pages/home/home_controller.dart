import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/home_page_model_class.dart';
import '../../model/res_login.dart';
import '../../repository/home_page_repository.dart';
import '../../repository/user_repository.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = true.obs;
  RxBool callSwitch = false.obs;
  RxBool videoSwitch = false.obs;
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

    userData = preferenceService.getUserDetail();
    appbarTitle.value = userData?.name ?? "Astrologer Name";
    getConstantDetailsData();
    getDashboardDetail();
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  HomeData? homeData;
  RxBool shopDataSync = false.obs;

  getDashboardDetail() async {
    Map<String, dynamic> params = {
      "role_id": userData?.roleId ?? 0,
      "device_token": userData?.deviceToken,
    };

    log("roleID==>${userData!.roleId}");
    log("deviceToken==>${userData?.deviceToken}");
    try {
      var response = await HomePageRepository().getDashboardData(params);
      homeData = response.data;
      shopDataSync.value = true;

      log("DashboardData==>${jsonEncode(homeData)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

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

  void chatSwitchFN() {
    chatSwitch.value = !chatSwitch.value;
    if (chatSwitch.value) {
      callSwitch.value = false;
    } else {
      callSwitch.value = true;
    }
  }

  void callSwitchFN() {
    callSwitch.value = !callSwitch.value;
    if (callSwitch.value) {
      chatSwitch.value = false;
    } else {
      chatSwitch.value = true;
    }
  }

  final noticeRepository = Get.put(NoticeRepository());
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<String> selectedTime = ''.obs;

  void selectDate(String value) {
    selectedDate(value.toDate());
  }

  void selectTime(String value) {
    selectedTime(value);
  }

  void scheduleCall() async {
    try {
      ///Type 1: for call 2 for chat.

      if (selectedTime.value.isEmpty) return;
      int type = 2;
      if (callSwitch.value) type = 1;
      if (chatSwitch.value) type = 2;

      AstroScheduleRequest request = AstroScheduleRequest(
        scheduleDate: selectedDate.value.toFormattedString(),
        scheduleTime: selectedTime.value,
        type: type,
      );

      final response = await noticeRepository.astroScheduleOnlineAPI(
        request.toJson(),
      );
      if (response.statusCode == 200 && response.success) {
        divineSnackBar(data: response.message);
      }
    } catch (err) {
      if (err is AppException) {
        err.onException();
      }
    }
  }
}
