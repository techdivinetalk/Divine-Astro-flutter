import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/model/update_offer_type_response.dart';
import 'package:divine_astrologer/model/update_session_type_response.dart';
import 'package:divine_astrologer/pages/home/home_ui.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/home_page_model_class.dart';
import '../../model/res_login.dart';
import '../../model/send_feed_back_model.dart';
import '../../model/view_training_video_model.dart';
import '../../repository/home_page_repository.dart';
import '../../repository/user_repository.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = true.obs;
  RxBool callSwitch = false.obs;
  RxBool videoSwitch = false.obs;
  RxString chatSchedule = "".obs, callSchedule = "".obs, videoSchedule = "".obs;
  RxList<bool> promotionOfferSwitch = RxList([]);
  RxString appbarTitle = "Astrologer Name ".obs;
  RxBool isShowTitle = true.obs;
  TextEditingController feedBackText = TextEditingController();
  final socket = AppSocket();
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();
  UserData? userData = UserData();
  final preferenceService = Get.find<SharedPreferenceService>();
  final UserRepository userRepository = Get.put(UserRepository());
  final HomePageRepository homePageRepository = Get.put(HomePageRepository());
  final homeScreenKey = GlobalKey<ScaffoldState>();
  int scoreIndex = 0;
  List<Map<String, dynamic>> yourScore = [
    {"title": "Your Conversion Rate", "score": "80"},
    {"title": "Your Repurchase Rate", "score": "60"},
    {"title": "Your Online Hours", "score": "50"},
    {"title": "Your Live Hours", "score": "70"},
    {"title": "E-Commerce", "score": "80"},
    {"title": "Your Busy Hours", "score": "60"},
  ];

  Rx<Loading> offerTypeLoading = Loading.initial.obs;
  Rx<Loading> sessionTypeLoading = Loading.initial.obs;

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
    getFeedbackData();
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  HomeData? homeData;
  RxBool isFeedbackAvailable = false.obs;
  FeedbackData? feedbackResponse;

  List<FeedbackData>? feedbacksList;
  Loading loading = Loading.initial;
  RxBool shopDataSync = false.obs;
  ViewTrainingVideoModelClass? viewTrainingVideoModelClass;
  SendFeedBackModel? sendFeedBackModel;

  sendFeedbackAPI(String text) async {
    Map<String, dynamic> params = {"comment": text.toString()};
    try {
      var data = await userRepository.sendFeedBack(params);
      sendFeedBackModel = data;
      feedBackText.clear();
      divineSnackBar(data: sendFeedBackModel?.message.toString() ?? '');
      profileDataSync.value = true;
      log("send FeedBack-->${sendFeedBackModel?.message}");
      log("params Body-->$text");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  trainingVideoViewData(int videoId) async {
    Map<String, dynamic> params = {"training_video_id": videoId};
    try {
      var data = await userRepository.viewTrainingVideoApi(params);
      viewTrainingVideoModelClass = data;

      profileDataSync.value = true;
      await getDashboardDetail();
      Get.back();
      update();
      log("DoneVideo-->${viewTrainingVideoModelClass!.message}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  getFeedbackData() async {
    loading = Loading.initial;
    update();
    try {
      var response = await homePageRepository.getFeedbackData();
      isFeedbackAvailable.value = response.success ?? false;
      debugPrint('val: $isFeedbackAvailable');
      if (isFeedbackAvailable.value) {
        feedbackResponse = response.data?[0];
        feedbacksList = response.data;
        showFeedbackBottomSheet();
        debugPrint('feed id: ${feedbackResponse?.id}');
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

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
      updateCurrentData();
      shopDataSync.value = true;
      loading = Loading.loaded;

      showOnceInDay();
      update();

      log("DashboardData==>${jsonEncode(homeData)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  updateCurrentData() {
    chatSwitch.value = homeData?.sessionType?.chat == 1;
    callSwitch.value = homeData?.sessionType?.call == 1;
    videoSwitch.value = homeData?.sessionType?.video == 1;

    if (homeData?.sessionType?.chatSchedualAt != null &&
        homeData?.sessionType?.chatSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.chatSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedChatDate.value = formattedDate;
      selectedChatTime.value = formattedTime;
    }
    if (homeData?.sessionType?.callSchedualAt != null &&
        homeData?.sessionType?.callSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.callSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedCallDate.value = formattedDate;
      selectedCallTime.value = formattedTime;
    }
    if (homeData?.sessionType?.videoSchedualAt != null &&
        homeData?.sessionType?.videoSchedualAt != '') {
      DateTime formattedDate = DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(homeData!.sessionType!.videoSchedualAt!);
      String formattedTime = DateFormat("hh:mm a").format(formattedDate);

      selectedVideoDate.value = formattedDate;
      selectedVideoTime.value = formattedTime;
    }

    ///Offer Type data
    if (homeData?.offerType != null && homeData?.offerType != []) {
      for (int i = 0; i < homeData!.offerType!.length; i++) {
        bool value = homeData?.offerType![i].isActive == "1";

        promotionOfferSwitch.add(value);
      }
    }

    update();
  }

  getConstantDetailsData() async {
    try {
      var data = await userRepository.constantDetailsData();
      getConstantDetails = data;
      preferenceService.setConstantDetails(data);
      // debugPrint("ConstantDetails Data==> $data");
      profileDataSync.value = true;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
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
      divineSnackBar(data: 'WhatsApp is not installed.');
      log('WhatsApp is not installed.');
    }
  }

  void chatSwitchFN() {
    updateSessionType(!chatSwitch.value, chatSwitch, 1);
  }

  void callSwitchFN() {
    updateSessionType(!callSwitch.value, callSwitch, 2);
  }

  void videoCallSwitchFN() {
    updateSessionType(!videoSwitch.value, videoSwitch, 3);
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

  Future<void> updateSessionType(
      bool value, RxBool switchType, int type) async {
    //type: 1 - chat, 2 - call, 3 - videoCall
    Map<String, dynamic> params = {
      "is_chat": getBoolToString(type == 1 ? value : chatSwitch.value),
      "is_call": getBoolToString(type == 2 ? value : callSwitch.value),
      "is_video": getBoolToString(type == 3 ? value : videoSwitch.value)
    };

    sessionTypeLoading.value = Loading.loading;
    try {
      UpdateSessionTypeResponse response =
          await userRepository.updateSessionTypeApi(params);
      if (response.statusCode == 200) {
        switchType.value = value;
        socket.updateChatCallSocketEvent(
            call: callSwitch.value ? "1" : "0",
            chat: chatSwitch.value ? "1" : "0",
            video: videoSwitch.value ? "1" : "0");
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    sessionTypeLoading.value = Loading.loaded;
    update();
  }

  Future<void> updateOfferType(bool value, int offerId, int index) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "is_active": getBoolToString(value),
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        promotionOfferSwitch[index] = value;
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    offerTypeLoading.value = Loading.loaded;
    update();
  }

  bool isValidDate(String value, String timeVal) {
    var selectedTime = timeVal;
    var selectedDate = value == "CHAT"
        ? selectedChatDate.value
        : value == "CALL"
            ? selectedCallDate.value
            : selectedVideoDate.value;
    DateTime parseDate = DateFormat("hh:mm a").parse(selectedTime);
    var formattedTime = (DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, parseDate.hour, parseDate.minute, 0));

    bool difference = DateTime.now().isBefore(formattedTime);
    return difference;
  }

  void scheduleCall(String value) async {
    var selectedTime = value == "CHAT"
        ? selectedChatTime.value
        : value == "CALL"
            ? selectedCallTime.value
            : selectedVideoTime.value;
    var selectedDate = value == "CHAT"
        ? selectedChatDate.value
        : value == "CALL"
            ? selectedCallDate.value
            : selectedVideoDate.value;
    DateTime parseDate = DateFormat("hh:mm a").parse(selectedTime);
    var formattedTime = (DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, parseDate.hour, parseDate.minute, 0));

    bool difference = DateTime.now().isBefore(formattedTime);

    if (difference) {
      try {
        ///Type 1: for call 2 for chat.
        int type = 0;

        late AstroScheduleRequest request;
        if (value == "CHAT") {
          type = 2;
          request = AstroScheduleRequest(
            scheduleDate: selectedChatDate.value.toFormattedString(),
            scheduleTime: selectedChatTime.value,
            type: type,
          );
        }
        if (value == "CALL") {
          type = 1;
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

  getBoolToString(bool value) {
    return value ? "1" : "0";
  }

  showOnceInDay() async {
    int timestamp = await preferenceService
        .getIntPrefs(SharedPreferenceService.performanceDialog);

    if (timestamp == 0 ||
        (DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
                .inDays >
            0) ||
        getDateDifference(timestamp)) {
      await preferenceService.setIntPrefs(
          SharedPreferenceService.performanceDialog,
          DateTime.now().millisecondsSinceEpoch);
      showDialog(
        context: Get.context!,
        barrierColor: AppColors.darkBlue.withOpacity(0.5),
        builder: (_) => PerformanceDialog(),
      );
    }
  }

  showFeedbackBottomSheet() async {
    await openBottomSheet(
      Get.context!,
      title: "Feedback Available!!!",
      btnTitle: "Check Report",
      functionalityWidget: Text(
        feedbackResponse?.remark ?? '',
        textAlign: TextAlign.center,
        style: AppTextStyle.textStyle16(),
      ),
    );
  }

  getDateDifference(int timestamp) {
    DateTime dtTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    if (now.day != dtTimestamp.day ||
        now.month != dtTimestamp.month ||
        now.year != dtTimestamp.year) {
      return true;
    } else {
      return false;
    }
  }
}
