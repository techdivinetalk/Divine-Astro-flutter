import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import "package:contacts_service/contacts_service.dart";
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/MiddleWare.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';

import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/di/fcm_notification.dart';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/model/home_model/training_video_model.dart';
import 'package:divine_astrologer/model/performance_response.dart';
import 'package:divine_astrologer/model/update_offer_type_response.dart';
import 'package:divine_astrologer/model/update_session_type_response.dart';
import 'package:divine_astrologer/model/wallet_deatils_response.dart';
import 'package:divine_astrologer/pages/home/home_ui.dart';
import 'package:divine_astrologer/pages/home/widgets/training_video.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:cron/cron.dart';

import 'widgets/can_not_online.dart';

class HomeController extends GetxController {
  bool isOpenBonusSheet = false;
  bool isOpenPaidSheet = false;
  bool isOpenECommerceSheet = false;

  RxBool liveSwitch = true.obs;

  RxBool isCallEnable = true.obs;
  RxBool isChatEnable = true.obs;
  RxBool isVideoCallEnable = true.obs;
  RxBool isLiveEnable = true.obs;

  double xPosition = 10.0;
  double yPosition = Get.height * 0.4;
  RxList<bool> customOfferSwitch = RxList([]);

  RxString appbarTitle = "Astrologer Name ".obs;
  RxBool isShowTitle = true.obs;
  TextEditingController feedBackText = TextEditingController();
  final socket = AppSocket();
  ExpandedTileController? expandedTileController = ExpandedTileController();
  ExpandedTileController? expandedTile2Controller = ExpandedTileController();
  UserData userData = UserData();
  UserRepository userRepository = UserRepository();
  HomePageRepository homePageRepository = HomePageRepository();
  final homeScreenKey = GlobalKey<ScaffoldState>();
  int scoreIndex = 0;
  List<Map<String, dynamic>> yourScore = [];

  OrderDetails? order;

  String userImage = "";

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

  final cron = Cron();

  @override
  void onInit() async {
    super.onInit();
    print("beforeGoing 3 - ${preferenceService.getUserDetail()?.id}");
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      debugPrint('broadcastReceiver ${event.name} ---- ${event.data}');
      if (event.name == "giftCount") {
        if (int.parse(event.data!["giftCount"].toString()) > 0) {
          if (MiddleWare.instance.currentPage != RouteName.chatMessageUI) {
            showGiftBottomSheet(event.data?["giftCount"], contextDetail,
                baseUrl: preferenceService.getBaseImageURL());
          }
        }
      }
    });
    if (preferenceService.getUserDetail() != null) {
      getAllDashboardData();
      userData = preferenceService.getUserDetail()!;
      appbarTitle.value =
          "${userData.name.toString().capitalizeFirst} (${userData.uniqueNo})";

      print("${preferenceService.getBaseImageURL()}/${userData.image}");

      final String path = "astrologer/${(userData.id ?? 0)}/realTime";
      FirebaseDatabase.instance.ref().child(path).onValue.listen(
        (event) async {
          final DataSnapshot dataSnapshot = event.snapshot;

          if (dataSnapshot.exists) {
            if (dataSnapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> map = <dynamic, dynamic>{};
              map = (dataSnapshot.value ?? <dynamic, dynamic>{})
                  as Map<dynamic, dynamic>;
              print("Home Realtime DB Listener: $map");

              // final isCallSwitchRes = map["voiceCallStatus"] ?? 0;
              // callSwitch(isCallSwitchRes > 0);
              //
              // final isChatSwitchRes = map["chatStatus"] ?? 0;
              // chatSwitch(isChatSwitchRes > 0);
              //
              // final isVideoCallSwitchRes = map["videoCallStatus"] ?? 0;
              // videoSwitch(isVideoCallSwitchRes > 0);

              final isCallEnableRes = map["is_call_enable"] ?? false;
              isCallEnable(isCallEnableRes);

              final isChatEnableRes = map["is_chat_enable"] ?? false;
              isChatEnable(isChatEnableRes);

              final isVideoCallEnableRes = map["is_video_call_enable"] ?? false;
              isVideoCallEnable(isVideoCallEnableRes);

              final isLiveEnableRes = map["is_live_enable"] ?? false;
              isLiveEnable(isLiveEnableRes);

              final offers = map["offers"];
              if (offers != null) {
                if (homeData != null) {
                  for (int i = 0;
                      i < homeData!.offers!.orderOffer!.length;
                      i++) {
                    for (int j = 0; j < offers.keys.toList().length; j++) {
                      if ("${homeData!.offers!.orderOffer![i].id}" ==
                          "${offers.keys.toList()[j]}") {
                        if ("${offers.values.toList()[j]}" == "1") {
                          homeData!.offers!.orderOffer![i].isOn = true;
                          update();
                        } else {
                          homeData!.offers!.orderOffer![i].isOn = false;
                          update();
                        }
                      }
                    }
                  }
                }
              }
            } else {}
          } else {}
        },
      );
    }

    // cron.schedule(Schedule.parse('*/5 * * * * *'), checkForScheduleUpdate);
  }

  getAllDashboardData({bool isReapeting = false}) async {
    await getConstantDetailsData();
    if (getConstantDetails != null) {
      if (getConstantDetails!.data!.isForceTraningVideo == 1) {
        print("if----getConstantDetails!.data!.isForceTraningVideo");
        getAllTrainingVideo(isReapeting: isReapeting);
        update();
      } else {
        print("else----getConstantDetails!.data!.isForceTraningVideo");
        await getDashboardDetail();
        getFilteredPerformance();
        getFeedbackData();
        tarotCardData();
        getUserImage();
        update();
      }
    } else {
      print("getConstantDetails is null");
    }
    update();
  }

  void checkForScheduleUpdate() {
    DateTime chatChatDateAndTime = DateTime(2050);
    final String dateStringForChat = selectedChatDate.value.toString();
    final String timeStringForChat = selectedChatTime.value.toString();
    if (dateStringForChat.isNotEmpty && timeStringForChat.isNotEmpty) {
      chatChatDateAndTime = getChatDateAndTime(
        dateString: dateStringForChat,
        timeString: timeStringForChat,
      );
    } else {}

    DateTime callChatDateAndTime = DateTime(2050);
    final String dateStringForCall = selectedCallDate.value.toString();
    final String timeStringForCall = selectedCallTime.value.toString();
    if (dateStringForCall.isNotEmpty && timeStringForCall.isNotEmpty) {
      callChatDateAndTime = getChatDateAndTime(
        dateString: dateStringForCall,
        timeString: timeStringForCall,
      );
    } else {}

    DateTime videoChatDateAndTime = DateTime(2050);
    final String dateStringForVideoDate = selectedVideoDate.value.toString();
    final String timeStringForVideoTime = selectedVideoTime.value.toString();
    if (dateStringForVideoDate.isNotEmpty &&
        timeStringForVideoTime.isNotEmpty) {
      videoChatDateAndTime = getChatDateAndTime(
        dateString: dateStringForVideoDate,
        timeString: timeStringForVideoTime,
      );
    } else {}

    final bool isBeforeChat = chatChatDateAndTime.isBefore(DateTime.now());
    final bool isBeforeCall = callChatDateAndTime.isBefore(DateTime.now());
    final bool isVideo = videoChatDateAndTime.isBefore(DateTime.now());

    if (!isBeforeChat || !isBeforeCall || !isVideo) {
      getDashboardDetail();
    } else {}
    return;
  }

  DateTime getChatDateAndTime({
    required String dateString,
    required String timeString,
  }) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final TimeOfDay time = TimeOfDay.fromDateTime(timeFormat.parse(timeString));
    final DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combinedDateTime;
  }

  getUserImage() async {
    String? baseUrl = Get.find<SharedPreferenceService>().getBaseImageURL();

    userImage = "${baseUrl}/${userData.image}";
    print(userImage);
    print("userImageuserImageuserImageuserImage");
    update();
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
      divineSnackBar(data: error.toString(), color: appColors.redColor);
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
  var walletData = <WalletPoint>[].obs;
  RxBool isFeedbackAvailable = false.obs;
  FeedbackData? feedbackResponse;
  Offset fabPosition = const Offset(20, 20);
  List<FeedbackData>? feedbacksList;
  Loading loading = Loading.initial;
  RxBool shopDataSync = false.obs;
  ViewTrainingVideoModelClass? viewTrainingVideoModelClass;
  SendFeedBackModel? sendFeedBackModel;

  PerformanceResponse? performanceResponse;
  RxList<dynamic> overAllScoreList = <dynamic>[].obs;
  RxList<dynamic> performanceScoreList = [].obs;

  getFilteredPerformance() async {
    try {
      Map<String, dynamic> params = {"filter": 'yesterday'};
      var response = await PerformanceRepository().getPerformance(params);
      log("Res-->${jsonEncode(response.data)}");
      performanceResponse = response;
      overAllScoreList.value = [
        response.data?.conversionRate,
        response.data?.repurchaseRate,
        response.data?.onlineHours,
        response.data?.liveHours,
        response.data?.ecom,
        response.data?.busyHours,
      ];

      for (int i = 0; i < overAllScoreList.length; i++) {
        int averageScore =
            int.parse(overAllScoreList[i]?.performance?.marks?[1].max ?? '0');
        int yourMarks =
            int.parse(overAllScoreList[i]?.performance?.marksObtains ?? '0');
        if (averageScore > yourMarks) {
          performanceScoreList.add(overAllScoreList[i]);
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  trainingVideoViewData(int videoId, {bool isFromForceVideo = false}) async {
    Map<String, dynamic> params = {"training_video_id": videoId};
    try {
      var data = await userRepository.viewTrainingVideoApi(params);
      viewTrainingVideoModelClass = data;
      profileDataSync.value = true;
      await getConstantDetailsData();
      if (isFromForceVideo) {
        if (getConstantDetails!.data!.isForceTraningVideo == 1) {
          getAllDashboardData(isReapeting: true);
        } else {
          Get.back();
        }
      } else {
        Get.back();
      }

      update();
      log("DoneVideo-->${viewTrainingVideoModelClass!.message}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getFeedbackData() async {
    update();
    try {
      var response = await homePageRepository.getFeedbackData();

      isFeedbackAvailable.value = response.success ?? false;
      debugPrint('val: $isFeedbackAvailable');
      if (isFeedbackAvailable.value) {
        //print(" Dharam::${response.data?[0].order?.orderId}");
        feedbackResponse = response.data?[0];
        feedbacksList = response.data;

        if (feedbackResponse?.id != null && !isFeedbackAvailable.value) {
          showFeedbackBottomSheet();
          debugPrint('feed id: ${feedbackResponse?.id}');
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getDashboardDetail() async {
    loading = Loading.initial;
    update();
    Map<String, dynamic> params = {
      "role_id": userData.roleId ?? 0,
      "device_token": userData.deviceToken,
    };
    try {
      var response = await HomePageRepository().getDashboardData(params);
      isFeedbackAvailable.value = response.success ?? false;
      homeData = response.data;
      print(homeData!.offers!.customOffer!.length);
      print("homeData!.offers!.orderOffer!.length");
      loading = Loading.loaded;
      updateCurrentData();
      shopDataSync.value = true;

      showOnceInDay();
      update();
      //getFeedbackData();
      //log("DashboardData==>${jsonEncode(homeData)}");
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  getWalletPointDetail(wallet) async {
    update();
    try {
      var response = await HomePageRepository().getWalletDetailsData(wallet);
      walletData.value = response.data;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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

    print("updateCurrentData called");
    print("updateCurrentData Chat ${homeData?.inAppChatPrevStatus}");
    print("updateCurrentData Audio ${homeData?.audioCallPrevStatus}");
    print("updateCurrentData Video ${homeData?.videoCallPrevStatus}");

    // socket.updateChatCallSocketEvent(
    //     //   call: callSwitch.value ? "1" : "0",
    //     //   chat: chatSwitch.value ? "1" : "0",
    //     //   video: videoSwitch.value ? "1" : "0",
    //     // );
    astroOnlineOffline(status: "chat_status=${chatSwitch.value ? "1" : "0"}");
    astroOnlineOffline(status: "call_status=${callSwitch.value ? "1" : "0"}");

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
        homeData?.offers?.customOffer != []) {}

    update();
  }

  Dio dio = Dio();

  astroOnlineOffline({String? status}) async {
    // try {
    final response = await dio
        .get("${ApiProvider.astOnlineOffline}${userData.uniqueNo}&${status}");
    log(response.data.toString());
    print("response.data");
    if (response.statusCode == 200) {}
    // } catch (e) {
    //   print("getting error --- getAstroCustOfferData ${e}");
    // }
  }

  getConstantDetailsData() async {
    try {
      var data = await userRepository.constantDetailsData();
      getConstantDetails = data;
      log(getConstantDetails!.data!.toJson().toString());
      print("getting is force training video flag");
      await preferenceService.setConstantDetails(data);
      profileDataSync.value = true;

      // getDashboardDetail();
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        //  divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  List<TrainingVideoData> traingVideoData = [];

  int videoPage = 1;

  getAllTrainingVideo({bool isReapeting = false}) async {
    try {
      var data = await homePageRepository.getAllTraningVideoApi();
      if (data.data!.isNotEmpty) {
        traingVideoData = data.data!;
      }
      for (int i = 0; i < traingVideoData.length; i++) {
        if (traingVideoData[i].isViwe == 0) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          if (!isReapeting) {
            Get.to(() {
              return TrainingVideoUI(
                video: traingVideoData[i],
              );
            })!
                .then((value) {
              print("in side going");
              getAllDashboardData();
            });
            print("isReapeting ----- ${isReapeting}");
          } else {
            print("isReapeting ----- ${isReapeting}");
            Get.off(() {
              return TrainingVideoUI(
                video: traingVideoData[i],
              );
            });
          }
          break;
        }
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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

  Future<void> chatSwitchFN({required Function() onComplete}) async {
    chatSwitch(!chatSwitch.value);
    await updateSessionType(chatSwitch.value, chatSwitch, 1);
    onComplete();
    return Future<void>.value();
  }

  Future<void> callSwitchFN({required Function() onComplete}) async {
    callSwitch(!callSwitch.value);
    await updateSessionType(callSwitch.value, callSwitch, 2);
    onComplete();
    return Future<void>.value();
  }

  Future<void> videoCallSwitchFN({required Function() onComplete}) async {
    videoSwitch(!videoSwitch.value);
    await updateSessionType(videoSwitch.value, videoSwitch, 3);
    onComplete();
    return Future<void>.value();
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
    };

    value ? params["check_in"] = 1 : params["check_out"] = 1;

    sessionTypeLoading.value = Loading.loading;
    try {
      // UpdateSessionTypeResponse response =
      //     await userRepository.astroOnlineAPIForLive(params);
      UpdateSessionTypeResponse response =
          await userRepository.astroOnlineAPIForLive(
        params: params,
        successCallBack: (message) {
          /// o offline
          /// 1 online
          // socket.updateChatCallSocketEvent(
          //   call: callSwitch.value ? "1" : "0",
          //   chat: chatSwitch.value ? "1" : "0",
          //   video: videoSwitch.value ? "1" : "0",
          // );
          switch (type) {
            case 1:
              astroOnlineOffline(
                  status: 'chat_status=${chatSwitch.value ? "1" : "0"}');
              break;
            case 2:
              astroOnlineOffline(
                  status: 'call_status=${callSwitch.value ? "1" : "0"}');
              break;
            default:
              break;
          }
          divineSnackBar(data: message);
        },
        failureCallBack: (message) {
          switch (type) {
            case 1:
              chatSwitch(!chatSwitch.value);
              break;
            case 2:
              callSwitch(!callSwitch.value);
              break;
            case 3:
              videoSwitch(!videoSwitch.value);
              break;
            default:
              break;
          }
          divineSnackBar(data: message ?? "");
        },
      );

      if (response.statusCode == 200) {
        if (!videoSwitch.value && type == 3) {
          selectDateTimePopupForVideo();
        } else {
          selectedVideoTime.value = "";
        }
        if (!callSwitch.value && type == 2) {
          selectDateTimePopupForCall();
        } else {
          selectedCallTime.value = "";
        }
        if (!chatSwitch.value && type == 1) {
          selectDateTimePopupForChat();
        } else {
          selectedChatTime.value = "";
        }
        switchType.value = value;
      } else if (response.statusCode == 400) {
        Get.bottomSheet(CantOnline(message: response.message));
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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
        homeData!.offers!.customOffer![index].isOn = value;
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    offerTypeLoading.value = Loading.loaded;
    update();
  }

  updateOrderOffer({
    required bool value,
    required int offerId,
    required int index,
  }) async {
    Map<String, dynamic> params = {
      "offer_id": offerId,
      "offer_type": 1,
      "action": value ? 1 : 0,
    };
    offerTypeLoading.value = Loading.loading;
    try {
      UpdateOfferResponse response =
          await userRepository.updateOfferTypeApi(params);
      if (response.statusCode == 200) {
        homeData!.offers!.orderOffer![index].isOn = value;
        // homeData!.offers!.orderOffer![index].isOn = !homeData!.offers!.orderOffer![index].isOn!;
        update();
      }
      update();
    } catch (error) {
      debugPrint("updateOfferType $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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
        ///Type 1:call
        ///Type 2:chat
        ///Type 3:Video
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
          type = 3;
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
      if (performanceScoreList.isNotEmpty) {
        showDialog(
          context: Get.context!,
          barrierColor: appColors.darkBlue.withOpacity(0.5),
          builder: (_) => PerformanceDialog(),
        ).then((value) {
          getUserImage();
          update();
        });
      }
    }
  }

  showFeedbackBottomSheet() async {
    await feedbackBottomSheet(
      Get.context!,
      title: "Feedback Available!!!",
      subTitle:
          'We noticed a little guideline slip in your \n previous order. No worries!'
          'We\'ve sorted out\n the fines and shared some helpful feedback.\n'
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

  showGiftBottomSheet(int giftCount, BuildContext? contextDetail,
      {String? baseUrl}) async {
    // if(MiddleWare.instance.currentPage == RouteName.chatMessageUI || MiddleWare.instance.currentPage == RouteName.chatMessageWithSocketUI){
    //   return;
    // }
    PopupManager.showGiftCountPopup(contextDetail!,
        title: "Congratulations",
        btnTitle: "Check Order History",
        baseUrl: baseUrl,
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
        } else {}
      } else {}
    } else {}
    return Future<bool>.value(hasOpenOrder);
  }

  String getLabel() {
    if (performanceScoreList.isNotEmpty &&
        performanceScoreList.length > scoreIndex) {
      final bool b1 = (performanceScoreList ?? <dynamic>[]).isNotEmpty;
      final bool b2 = performanceScoreList[scoreIndex] != null;
      final bool b3 = performanceScoreList[scoreIndex]?.label != null;
      return (b1 && b2 && b3)
          ? performanceScoreList[scoreIndex]?.label ?? ""
          : "";
    }
    return "";
  }

  void selectDateTimePopupForVideo() {
    selectDateOrTime(
      futureDate: true,
      Get.context!,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      pickerStyle: "DateCalendar",
      looping: true,
      type: "VIDEO",
      lastDate: DateTime(2050),
      onConfirm: (value) => selectVideoDate(value),
      onChange: (value) => selectVideoDate(value),
      onClickOkay: (value) {
        Get.back();
        selectDateOrTime(Get.context!,
            title: "scheduleOnlineTime".tr,
            btnTitle: "confirmOnlineTime".tr,
            type: "VIDEO",
            selectedDate: selectedVideoDate.value,
            pickerStyle: "TimeCalendar",
            looping: true, onConfirm: (value) {
          // controller.selectVideoTime(value),
        }, onChange: (value) {
          // controller.selectVideoTime(value);
          if (isValidDate("VIDEO", value)) {
            selectVideoTime(value);
            scheduleCall("VIDEO");
          } else {
            // Fluttertoast.showToast(msg: "Please select future date and time");
          }
        });
      },
    );
  }

  void selectDateTimePopupForCall() {
    selectDateOrTime(
      futureDate: true,
      Get.context!,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      pickerStyle: "DateCalendar",
      looping: true,
      type: "CALL",
      lastDate: DateTime(2050),
      onConfirm: (value) => selectCallDate(value),
      onChange: (value) => selectCallDate(value),
      onClickOkay: (value) {
        Get.back();
        selectDateOrTime(Get.context!,
            title: "scheduleOnlineTime".tr,
            btnTitle: "confirmOnlineTime".tr,
            type: "CALL",
            selectedDate: selectedCallDate.value,
            pickerStyle: "TimeCalendar",
            looping: true, onConfirm: (value) {
          // controller.selectCallTime(value),
        }, onChange: (value1) {
          // controller.selectCallTime(value),
        }, onClickOkay: (value1) {
          if (isValidDate("CALL", value1)) {
            selectCallTime(value1);
            scheduleCall("CALL");
          } else {
            // Fluttertoast.showToast(msg: "Please select future date and time");
          }
        });
      },
    );
  }

  void selectDateTimePopupForChat() {
    selectDateOrTime(
      Get.context!,
      futureDate: true,
      title: "ScheduleOnlineDate".tr,
      btnTitle: "confirmNextDate".tr,
      type: "CHAT",
      pickerStyle: "DateCalendar",
      looping: true,
      initialDate: DateTime.now(),
      lastDate: DateTime(2050),
      onConfirm: (value) => selectChatDate(value),
      onChange: (value) => selectChatDate(value),
      onClickOkay: (value) {
        Get.back();

        selectDateOrTime(
          Get.context!,
          type: "CHAT",
          title: "scheduleOnlineTime".tr,
          btnTitle: "confirmOnlineTime".tr,
          pickerStyle: "TimeCalendar",
          selectedDate: selectedChatDate.value,
          looping: true,
          onConfirm: (value) {
            // controller.selectChatTime(value),
          },
          onChange: (value) {
            // controller.selectChatTime(value),
          },
          onClickOkay: (timeValue) {
            if (isValidDate("CHAT", timeValue)) {
              selectChatTime(timeValue);
              scheduleCall("CHAT");
            } else {
              // Fluttertoast.showToast(msg: "Please select future date and time");
            }
          },
        );
      },
    );
  }
}
