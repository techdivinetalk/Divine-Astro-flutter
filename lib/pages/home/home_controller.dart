import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:contacts_service/contacts_service.dart";
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';

import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/fcm_notification.dart';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/model/update_offer_type_response.dart';
import 'package:divine_astrologer/model/update_session_type_response.dart';
import 'package:divine_astrologer/pages/home/home_ui.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "package:permission_handler/permission_handler.dart";
import 'package:url_launcher/url_launcher.dart';

import '../../common/PopupManager.dart';
import '../../common/app_exception.dart';
import '../../common/feedback_bottomsheet.dart';
import "../../common/important_number_bottomsheet.dart";
import '../../di/shared_preference_service.dart';
import '../../model/constant_details_model_class.dart';
import '../../model/filter_performance_response.dart';
import '../../model/home_page_model_class.dart';
import "../../model/important_numbers.dart";
import '../../model/res_login.dart';
import '../../model/send_feed_back_model.dart';
import '../../model/view_training_video_model.dart';
import '../../repository/home_page_repository.dart';
import "../../repository/important_number_repository.dart";
import '../../repository/notice_repository.dart';
import '../../repository/performance_repository.dart';
import '../../repository/user_repository.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = true.obs;
  RxBool callSwitch = false.obs;
  RxBool videoSwitch = false.obs;
  double xPosition = 10.0;
  double yPosition = Get.height * 0.4;
  RxString chatSchedule = "".obs, callSchedule = "".obs, videoSchedule = "".obs;
  RxList<bool> customOfferSwitch = RxList([]);
  RxList<bool> orderOfferSwitch = RxList([false, false]);
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
  List<Map<String, dynamic>> yourScore = [];

  OrderDetails? order;

  Rx<Loading> offerTypeLoading = Loading.initial.obs;
  Rx<Loading> sessionTypeLoading = Loading.initial.obs;

  onNextTap() {
    if (scoreIndex < performanceScoreList.length - 1) {
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

  BroadcastReceiver broadcastReceiver =
        BroadcastReceiver(names: <String>["callKundli", "giftCount"]);

  List<MobileNumber> importantNumbers = <MobileNumber>[];
  List<Contact> allContacts = <Contact>[].obs;
  bool? isAllNumbersExist;

  @override
  void onInit() async {
    super.onInit();
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      debugPrint('broadcastReceiver ${event.name} ---- ${event.data}');
      if (event.name == "giftCount") {
        showGiftBottomSheet(event.data?["giftCount"], contextDetail);
      }
    });
    userData = preferenceService.getUserDetail();
    appbarTitle.value = userData?.name ?? "Astrologer Name";
    await getFilteredPerformance();
    //await getContactList();
    // fetchImportantNumbers();
    getConstantDetailsData();
    getDashboardDetail();
    getFeedbackData();
    tarotCardData();
  }

  fetchImportantNumbers() async {
    try {
      final response = await ImportantNumberRepo().fetchData();
      if (response.data != null) {
        importantNumbers = response.data!;
      }
      isAllNumbersExist = checkForALlContact(importantNumbers);
      importantNumberBottomsheet();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: AppColors.redColor);
    }
  }

  getContactList() async {
    PermissionStatus contact = await Permission.contacts.status;
    if (contact.isGranted) {
      allContacts = await ContactsService.getContacts();
    } else {
      PermissionStatus status = await Permission.contacts.request();
      if (status.isGranted) {
        allContacts = await ContactsService.getContacts();
      }
    }
    // {
    //   divineSnackBar(data: 'contactPermissionRequired'.tr);
    // }
  }

  bool checkForALlContact(List<MobileNumber> importantNumbers) {
    bool isExist = true;
    for (int i = 0; i < importantNumbers.length; i++) {
      bool value = checkForContactExist(importantNumbers[i]);
      if (!value) {
        isExist = false;
        break;
      }
    }
    return isExist;
  }

  bool checkForContactExist(MobileNumber numbers) {
    Item item =
        Item(label: numbers.title ?? "", value: numbers.mobileNumber ?? "");
    List<String> numberList = [];
    if (item.value != null && item.value!.contains(",")) {
      numberList = item.value!.split(",").toList();
    }
    bool isExist = false;
    if (allContacts.isEmpty) return isExist;
    for (Contact contact in allContacts) {
      if (contact.phones != null) {
        for (var element in contact.phones!) {
          //  log(element.value!);
          if (contact.displayName == item.label
              // &&
              // numberList.every((el) => el.contains(element.value!))
              ) {
            return isExist = true;
          }
        }
      }
    }
    return isExist;
  }

  importantNumberBottomsheet() async {
    if (!isAllNumbersExist!) {
      await importantNumberBottomSheet(
        Get.context!,
      );
    }
  }

  addContact({
    required String givenName,
    required List<String> contactNumbers,
  }) async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission.isGranted) {
      List<Item> phoneItems = contactNumbers.map((contactNo) {
        return Item(label: "mobile", value: contactNo);
      }).toList();
      Contact newContact = Contact(
          givenName: givenName, //This fields are mandatory to save contact
          phones: phoneItems);
      await ContactsService.addContact(newContact);
      divineSnackBar(data: "contactSaved".tr);
      //fetchImportantNumbers();
    } else {
      openAppSettings();
    }
  }

  ConstantDetailsModelClass? getConstantDetails;
  RxBool profileDataSync = false.obs;

  HomeData? homeData;
  RxBool isFeedbackAvailable = false.obs;
  FeedbackData? feedbackResponse;
  Offset fabPosition = const Offset(20, 20);
  List<FeedbackData>? feedbacksList;
  Loading loading = Loading.initial;
  RxBool shopDataSync = false.obs;
  ViewTrainingVideoModelClass? viewTrainingVideoModelClass;
  SendFeedBackModel? sendFeedBackModel;

  PerformanceFilterResponse? performanceFilterResponse;
  RxList<Conversion?> overAllScoreList = <Conversion?>[].obs;
  RxList<Conversion?> performanceScoreList = <Conversion?>[].obs;

  getFilteredPerformance() async {
    try {
      Map<String, dynamic> params = {"filter": 'today'};
      var response =
          await PerformanceRepository().getFilteredPerformance(params);
      log("Res-->${jsonEncode(response.data)}");
      performanceFilterResponse = response;
      overAllScoreList.value = [
        response.data?.response?.conversion,
        response.data?.response?.repurchaseRate,
        response.data?.response?.onlineHours,
        response.data?.response?.liveOnline,
        response.data?.response?.averageServiceTime,
        response.data?.response?.customerSatisfactionRatings,
      ];

      for (int i = 0; i < overAllScoreList.length; i++) {
        int averageScore =
            int.parse(overAllScoreList[i]?.performance?.marks?[1].max ?? '0');
        int yourMarks = overAllScoreList[i]?.performance?.marksObtains ?? 0;
        if (averageScore > yourMarks) {
          performanceScoreList.add(overAllScoreList[i]);
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

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
        //print(" Dharam::${response.data?[0].order?.orderId}");
        feedbackResponse = response.data?[0];
        feedbacksList = response.data;
        if(feedbackResponse?.id != null  && !isFeedbackAvailable.value ){
          showFeedbackBottomSheet();
          debugPrint('feed id: ${feedbackResponse?.id}');
        }
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
      //   getFeedbackData();
      //log("DashboardData==>${jsonEncode(homeData)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  tarotCardData() async {
    // loading = Loading.initial;
    try {
      print("response.data1");
      await HomePageRepository().getTarotCardData();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  updateCurrentData() {
    // chatSwitch.value = homeData?.sessionType?.chat == 1;
    // callSwitch.value = homeData?.sessionType?.call == 1;
    // videoSwitch.value = homeData?.sessionType?.video == 1;

    chatSwitch.value = (homeData?.inAppChatPrevStatus ?? 0) == 1;
    callSwitch.value = (homeData?.audioCallPrevStatus ?? 0) == 1;
    videoSwitch.value = (homeData?.videoCallPrevStatus ?? 0) == 1;

    socket.updateChatCallSocketEvent(
      call: callSwitch.value ? "1" : "0",
      chat: chatSwitch.value ? "1" : "0",
      video: videoSwitch.value ? "1" : "0",
    );

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

    ///Customer Offer data
    if (homeData?.offers?.customOffer != null &&
        homeData?.offers?.customOffer != []) {
      for (int i = 0; i < homeData!.offers!.customOffer!.length; i++) {
        bool value = homeData?.offers?.customOffer![i].toggle == 1;

        customOfferSwitch.add(value);
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
      //    getDashboardDetail();
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
    var contact = getConstantDetails?.data?.whatsappNo ?? '';
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
    chatSwitch(!chatSwitch.value);
    updateSessionType(chatSwitch.value, chatSwitch, 1);
  }

  void callSwitchFN() {
    callSwitch(!callSwitch.value);
    updateSessionType(callSwitch.value, callSwitch, 2);
  }

  void videoCallSwitchFN() {
    videoSwitch(!videoSwitch.value);
    updateSessionType(videoSwitch.value, videoSwitch, 3);
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
    bool value,
    RxBool switchType,
    int type,
  ) async {
    //type: 1 - chat, 2 - call, 3 - videoCall
    Map<String, dynamic> params = {
      "type": type,
      "role_id": 7,
      "device_token": preferenceService.getDeviceToken(),
      // "is_chat": getBoolToString(type == 1 ? value : chatSwitch.value),
      // "is_call": getBoolToString(type == 2 ? value : callSwitch.value),
      // "is_video": getBoolToString(type == 3 ? value : videoSwitch.value)
    };

    if (value) {
      params["check_in"] = 1;
    } else {
      params["check_out"] = 1;
    }

    print("Dashboard:: send:: $params");

    sessionTypeLoading.value = Loading.loading;
    try {
      UpdateSessionTypeResponse response =
          await userRepository.updateSessionTypeApi(params);
      if (response.statusCode == 200) {
        switchType.value = value;
        socket.updateChatCallSocketEvent(
          call: callSwitch.value ? "1" : "0",
          chat: chatSwitch.value ? "1" : "0",
          video: videoSwitch.value ? "1" : "0",
        );
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

  Future<void> updateOfferType({
    required bool value,
    required int offerId,
    required int index,
    required int offerType,
  }) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "offer_type": offerType,
      "action": value ? 1 : 0,
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        if (offerType == 1) {
          orderOfferSwitch[index] = value;
        } else if (offerType == 2) {
          customOfferSwitch[index] = value;
        }
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
    await feedbackBottomSheet(
      Get.context!,
      title: "Feedback Available!!!",
      subTitle:
          'We noticed a little guideline slip in your previous order. No worries! '
          'We\'ve sorted out the fines and shared some helpful feedback. '
          'Thanks for your understanding!',
      btnTitle: "Check Report",
      onTap: () {
        Get.toNamed(RouteName.feedback, arguments: {
          'order_id': feedbackResponse?.orderId,
          'product_type': feedbackResponse?.order?.productType,
        });
      },
      /*  functionalityWidget: Html(
        data: feedbackResponse?.remark ?? '',
        onLinkTap: (url, __, ___) {
          launchUrl(Uri.parse(url ?? ''));
        },
      )*/
      // Text(
      //   feedbackResponse?.remark ?? '',
      //   textAlign: TextAlign.center,
      //   style: AppTextStyle.textStyle16(),
      // ),
    );
  }

  showGiftBottomSheet(int giftCount, BuildContext? contextDetail) async {
    PopupManager.showGiftCountPopup(contextDetail!,
        title: "Congratulations",
        btnTitle: "Check Order History",
        totalGift: giftCount);
    // await GiftCountPopup(
    //   Get.context!,
    //   title: "Congratulations!",
    //   btnTitle: "Check Order History",
    //   totaltGift: giftCount,
    // );
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

  Future<bool> hasOpenOrder() async {
    bool hasOpenOrder = false;

    final String id = (preferenceService.getUserDetail()?.id ?? "").toString();
    final String realTimeNode = "astrologer/$id/realTime";

    final DatabaseReference reference = FirebaseDatabase.instance.ref();
    final DataSnapshot dataSnapshot = await reference.child(realTimeNode).get();

    if (dataSnapshot.exists) {
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> map = <dynamic, dynamic>{};
        map = (dataSnapshot.value ?? <dynamic, dynamic>{})
            as Map<dynamic, dynamic>;

        if (map.isEmpty) {
        } else if (map.isNotEmpty) {
          hasOpenOrder = map["order_id"] != null;
        } else { }
      } else {}
    } else {}
    return Future<bool>.value(hasOpenOrder);
  }

  String getLabel() {
    final bool b1 = (performanceScoreList ?? <Conversion?>[]).isNotEmpty;
    final bool b2 = performanceScoreList[scoreIndex] != null;
    final bool b3 = performanceScoreList[scoreIndex]?.label != null;
    return (b1 && b2 && b3)
        ? performanceScoreList[scoreIndex]?.label ?? ""
        : "";
  }
}
