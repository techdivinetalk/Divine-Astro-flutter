import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_exception.dart';
import '../../di/api_provider.dart';
import '../../di/shared_preference_service.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/home_page_model_class.dart';
import '../../model/res_login.dart';
import '../../repository/home_page_repository.dart';
import '../../repository/user_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = true.obs;
  RxBool callSwitch = false.obs;
  RxBool videoSwitch = false.obs;
  RxString chatSchedule = "".obs, callSchedule = "".obs, videoSchedule = "".obs;
  RxBool consultantOfferSwitch = false.obs;
  RxBool promotionOfferSwitch = false.obs;
  RxString appbarTitle = "Astrologer Name ".obs;
  RxBool isShowTitle = true.obs;
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();
  UserData? userData = UserData();
  final preferenceService = Get.find<SharedPreferenceService>();
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

  Socket? socket;

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
    connectSocket();
    userData = preferenceService.getUserDetail();
    appbarTitle.value = userData?.name ?? "Astrologer Name";
    getConstantDetailsData();
    getDashboardDetail();
  }


  void connectSocket() {
    socket = io(
        ApiProvider.socketUrl,
        OptionBuilder()
            .enableAutoConnect()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .build());
    socket?.connect();
    socket?.onConnect((_) {
      log('Socket connected');
    });
    log("Socket--->${socket!.connected}");
  }

  @override
  void onClose() {
    socket?.dispose();
    super.onClose();
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  HomeData? homeData;
  Loading loading = Loading.initial;
  RxBool shopDataSync = false.obs;

  getDashboardDetail() async {
    loading = Loading.initial;
    update();
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
      loading = Loading.loaded;
      update();

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
    /*if (chatSwitch.value) {
      callSwitch.value = false;
    } else {
      callSwitch.value = true;
    }*/
  }

  void callSwitchFN() {
    callSwitch.value = !callSwitch.value;
    /*if (callSwitch.value) {
      chatSwitch.value = false;
    } else {
      chatSwitch.value = true;
    }*/
  }

  void videoCallSwitchFN() {
    videoSwitch.value = !videoSwitch.value;
  }

  final noticeRepository = Get.put(NoticeRepository());

  Rx<DateTime> selectedChatDate = DateTime.now().obs;
  Rx<String> selectedChatTime = ''.obs;

  Rx<DateTime> selectedCallDate = DateTime.now().obs;
  Rx<String> selectedCallTime = ''.obs;

  Rx<DateTime> selectedVideoDate = DateTime.now().obs;
  Rx<String> selectedVideoTime = ''.obs;

  void selectChatDate(String value) {
    selectedChatDate(value.toDate());
  }

  void selectChatTime(String value) {
    selectedChatTime(value);
  }

  void selectCallDate(String value) {
    selectedCallDate(value.toDate());
  }

  void selectCallTime(String value) {
    selectedCallTime(value);
  }

  void selectVideoDate(String value) {
    selectedVideoDate(value.toDate());
  }

  void selectVideoTime(String value) {
    selectedVideoTime(value);
  }

  void scheduleCall(String value) async {
    try {
      ///Type 1: for call 2 for chat.
      int type = 2;

      late AstroScheduleRequest request;
      if (value == "CHAT") {
        request = AstroScheduleRequest(
          scheduleDate: selectedChatDate.value.toFormattedString(),
          scheduleTime: selectedChatTime.value,
          type: type,
        );
      }
      if (value == "CALL") {
        request = AstroScheduleRequest(
          scheduleDate: selectedCallDate.value.toFormattedString(),
          scheduleTime: selectedCallTime.value,
          type: type,
        );
      }
      if (value == "VIDEO") {
        request = AstroScheduleRequest(
          scheduleDate: selectedVideoDate.value.toFormattedString(),
          scheduleTime: selectedVideoTime.value,
          type: type,
        );
      }

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
