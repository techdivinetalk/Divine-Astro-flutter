import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/live/blocked_customer_list_res.dart';
import 'package:divine_astrologer/model/live/blocked_customer_res.dart';
import 'package:divine_astrologer/model/live/deck_card_model.dart';
import 'package:divine_astrologer/model/live/notice_board_res.dart';
import 'package:divine_astrologer/new_live/widget/snack_bar_widget.dart';
import 'package:divine_astrologer/repository/astrologer_profile_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/live_global_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/end_session_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:zego_uikit_beauty_plugin/zego_uikit_beauty_plugin.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../model/res_login.dart';

class NewLiveController extends GetxController {
  FirebaseDatabase database = FirebaseDatabase.instance;

  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  int appID = 696414715;

  String appSign =
      "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";

  String serverSecret = "89ceddc6c59909af326ddb7209cb1c16";

  final ZegoUIKitPrebuiltLiveStreamingController zegoController =
      ZegoUIKitPrebuiltLiveStreamingController();

  @override
  void onInit() {
    preferanceAstrologerData();
    getLiveAstrologerData();
    super.onInit();
  }

  RxString astroId = "".obs;
  RxString astroName = "".obs;
  RxString astroAvatar = "".obs;
  RxString liveId = "".obs;
  RxString hostSpeciality = "".obs;
  RxInt timerCurrentIndex = 1.obs;
  RxBool isFront = false.obs;
  RxBool isCamOn = false.obs;
  RxBool extendTimeWidgetVisible = false.obs;
  RxBool isMicOn = false.obs;
  RxBool isHostAvailable = true.obs;
  RxBool showCardDeckToUserPopupTimeoutHappening = false.obs;
  RxBool waitingForUserToSelectCardsPopupVisible = false.obs;

  List<LeaderboardModel> leaderboardModel = [];
  List<WaitListModel> waitList = [];
  List firebaseBlockUsersIds = [];
  WaitListModel? orderModel;
  WaitListModel? currentCaller;
  BlockedCustomerListRes? blockedCustomerListRes;
  NoticeBoardRes? noticeBoardRes;
  TarotGameModel? tarotGameModel;
  List<DeckCardModel> deckCardModelList = [];

  preferanceAstrologerData() {
    astroId(pref.getUserDetail()?.id.toString());
    print(astroId);
    print("userIduserIduserIduserId");
    astroName(pref.getUserDetail()?.name ?? "");
    final String awsURL = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    astroAvatar(isValidImageURL(imageURL: "$awsURL/$image"));

    liveId(pref.getUserDetail()?.id.toString());

    hostSpeciality(getSpeciality());

    waitList = <WaitListModel>[];
    orderModel = WaitListModel(
      isRequest: false,
      isEngaded: false,
      callType: "",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
      generatedOrderId: 0,
      totalMin: 0,
      offerId: 0,
      callStatus: 0,
    );
    isFront(true);
    isCamOn(true);
    isMicOn(true);
    currentCaller = WaitListModel(
      isRequest: false,
      isEngaded: false,
      callType: "",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
      generatedOrderId: 0,
      offerId: 0,
      totalMin: 0,
      callStatus: 0,
    );
    blockedCustomerListRes = BlockedCustomerListRes();
    noticeBoardRes = NoticeBoardRes();
    deckCardModelList = [];
    tarotGameModel = TarotGameModel();
    extendTimeWidgetVisible(false);
    update();
    // hasReInitCoHost = false;
  }

  /// ---------------------  extra logic -------------------- ///
  final ScrollController scrollControllerForTop = ScrollController();
  final ScrollController scrollControllerForBottom = ScrollController();

  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "";
      }
    }
  }

  Future<bool> permissionCheck() async {
    bool hasAllPerm = false;
    await AppPermissionService.instance.onPressedAstrologerGoLive(
      () async {
        hasAllPerm = true;
      },
    );
    return Future<bool>.value(hasAllPerm);
  }

  String getSpeciality() {
    final List<String> pivotList = <String>[];
    pref.getUserDetail()?.astroCatPivot?.forEach(
          (AstroCatPivot e) => pivotList.add(e.categoryDetails?.name ?? ""),
        );
    return pivotList.join(", ");
  }

  bool hasMessageContainsAnyBadWord(String input) {
    List<String> badWords = LiveSharedPreferencesSingleton().getBadWordsList();
    print("hasBadWord: ${badWords.length}");
    List<String> words = input.toLowerCase().split(' ');

    for (String word in words) {
      if (badWords.contains(word)) {
        return true;
      }
    }

    return false;
  }

  final RegExp indianPhoneNumberRegex = RegExp(r'\b(?:\+?91|0)?[ -]?\d{10}\b');
  final RegExp emailRegex =
      RegExp(r'\b[A-Za-z0-9._%+-]+@\b[A-Za-z0-9.-]+\.[A-Z|a-z]{2,6}\b');
  final RegExp instagramIdRegex = RegExp(r'@[a-zA-Z0-9_]{1,30}\b');

  String algoForSendMessage(String input) {
    final bool hasPhoneNumber = indianPhoneNumberRegex.hasMatch(input);
    final bool hasEmail = emailRegex.hasMatch(input);
    final bool hasInstagramId = instagramIdRegex.hasMatch(input);
    final List<String> data = <String>[];
    if (hasPhoneNumber) {
      data.add("Phone Number");
    } else {}
    if (hasEmail) {
      data.add("Email Address");
    } else {}
    if (hasInstagramId) {
      data.add("Instagram Id");
    } else {}
    return data.isEmpty ? "" : data.join(", ");
  }

  void scrollDownForTop() {
    if (scrollControllerForTop.hasClients) {
      final double maxScr = scrollControllerForTop.position.minScrollExtent;
      scrollControllerForTop.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      update();
    } else {}
    return;
  }

  void scrollDownForBottom() {
    if (scrollControllerForBottom.hasClients) {
      final double maxScr = scrollControllerForBottom.position.minScrollExtent;
      scrollControllerForBottom.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      update();
    } else {}
    return;
  }

  void getUntil() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (Get.context!.mounted) {
          final int length = LiveGlobalSingleton().getCountOfOpenDialogs();
          print("getUntil():: closing $length items");
          for (int i = 0; i < length; i++) {
            Navigator.of(Get.context!).pop();
          }
        } else {}
      },
    );
    return;
  }

  String _twoDigits(int n) {
    return n >= 10 ? '$n' : '0$n';
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  // ------------------------ All Live Api Calls ------------------------- ///
  UserRepository userRepository = UserRepository();
  AstrologerProfileRepository liveRepository = AstrologerProfileRepository();

  Future<void> astroOnlineAPI({
    required bool entering,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = {
      "type": 3,
      "role_id": 7,
      "device_token": pref.getDeviceToken() ?? "",
    };
    entering == true ? param["check_in"] = 1 : param["check_out"] = 1;
    await userRepository.astroOnlineAPIForLive(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    return Future<void>.value();
  }

  Future<void> furtherProcedure() async {
    final bool hasAllPermission = await permissionCheck();
    if (hasAllPermission) {
      final bool hasAllData = astroName.isNotEmpty && astroId.isNotEmpty;
      if (hasAllData) {
        final (bool, String) can1 = await canEnterExit(entering: true);
        if (can1.$1 == true && can1.$2 == "") {
          await AppSocket().joinLive(
              userType: "astrologer", userId: int.parse(astroId.value));
          await startLiveUpdateFirebase();
          final (bool, String) can2 = await canEnterExit(entering: false);
          if (can2.$1 == true && can2.$2 == "") {
          } else {
            divineSnackBar(data: can2.$2);
          }
        } else {
          divineSnackBar(data: can1.$2);
        }
      } else {
        divineSnackBar(data: "Insufficient data, Please try to Re-login");
      }
    } else {
      divineSnackBar(data: "Insufficient Permissions, allow all Permissions");
    }

    return Future<void>.value();
  }

  Future<void> startLiveUpdateFirebase() async {
    final List<String> blockedCustomerList = await callBlockedCustomerListRes();
    await database.ref().child("liveTest/${astroId.value}").update(
      {
        "id": astroId.value,
        "name": astroName.value,
        "image": astroAvatar.value,
        "isAvailable": true,
        "isEngaged": 0,
        "blockList": blockedCustomerList,
      },
    );
    return Future<void>.value();
  }

  Future<(bool, String)> canEnterExit({bool? entering}) async {
    bool returnBool = false;
    String returnString = "";
    await astroOnlineAPI(
      entering: entering!,
      successCallBack: (message) {
        returnBool = true;
        returnString = "";
      },
      failureCallBack: (message) {
        returnBool = false;
        returnString = message;
      },
    );
    return Future<(bool, String)>.value((returnBool, returnString));
  }

  Future<List<String>> callBlockedCustomerListRes() async {
    final List<String> blockedCustomerList = [];
    final Map<String, dynamic> param = <String, dynamic>{"role_id": 7};
    BlockedCustomerListRes res = BlockedCustomerListRes();
    res = await liveRepository.blockedCustomerListAPI(
      params: param,
      successCallBack: log,
      failureCallBack: log,
    );
    res.statusCode == HttpStatus.ok
        ? BlockedCustomerListRes.fromJson(res.toJson())
        : BlockedCustomerListRes.fromJson(BlockedCustomerListRes().toJson());
    res.data?.forEach(
      (element) {
        blockedCustomerList.add((element.customerId ?? 0).toString());
      },
    );
    return Future<List<String>>.value(blockedCustomerList);
  }

  /// Ask for Audio Video Privet Call and Gift Api
  Future<void> sendGiftAPI({
    required Map<String, dynamic> data,
  }) async {
    try {
      final String accessToken = pref.getToken() ?? "";
      const String url = "https://zego-virtual-gift.vercel.app/api/send_gift";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "app_id": appID,
            "server_secret": serverSecret,
            "room_id": liveId.value,
            "user_id": astroId.value,
            "user_name": astroName.value,
            "gift_type": data,
            "gift_count": 1,
            "access_token": accessToken,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );
      if (response.statusCode != HttpStatus.ok) {
        liveSnackBar(msg: "[ERROR], Send Gift Fail: ${response.statusCode}");
      }
    } on Exception catch (error) {
      liveSnackBar(msg: "[ERROR], Send Gift Fail: ${error}");
    }
    return Future<void>.value();
  }

  /// Tarot card close
  Future<void> sendTaroCardClose() async {
    var data = {
      "room_id": liveId.value,
      "user_id": astroId.value,
      "user_name": astroName.value,
      "item": {},
      "type": "Tarot Card Close",
    };
    await sendGiftAPI(data: data);
    update();
    return Future<void>.value();
  }

  ///------------------------ After Live Start ------------------------ ///
  Timer? timer;
  Timer? msgTimerForFollowPopup;
  Timer? msgTimerForTarotCardPopup;
  bool isKeyboardSheetOpen = false;

  /// Astrologer Leaving live module
  Future<void> exitFunc() async {
    final bool isEngaded = currentCaller!.isEngaded;
    if (isEngaded) {
      LiveGlobalSingleton().isDisconnectPopupOpen = true;
      await showCupertinoModalPopup(
        context: Get.context!,
        builder: (BuildContext context) {
          return DisconnectWidget(
            onClose: Get.back,
            noDisconnect: () {
              Get.back();
            },
            yesDisconnect: () async {
              Get.back();
              // await removeCoHostOrStopCoHost();
            },
            isAstro: true,
            astroAvatar: astroAvatar.value,
            astroUserName: astroName.value,
            custoAvatar: currentCaller!.avatar,
            custoUserName: currentCaller!.userName,
          );
        },
      );
      LiveGlobalSingleton().isDisconnectPopupOpen = false;
    } else {
      LiveGlobalSingleton().isEndLiveSessionPopupOpen = true;
      await showCupertinoModalPopup(
        context: Get.context!,
        builder: (BuildContext context) {
          return EndSessionWidget(
            onClose: Get.back,
            continueLive: Get.back,
            endLive: () async {
              if (Get.context!.mounted) {
                timer?.cancel();
                msgTimerForFollowPopup?.cancel();
                msgTimerForTarotCardPopup?.cancel();
                await zegoController.leave(Get.context!);
                Get.back();
                update();
              } else {}
            },
          );
        },
      );
      LiveGlobalSingleton().isEndLiveSessionPopupOpen = false;
    }
    return Future<void>.value();
  }

  /// Customer is block or not checking function
  bool isBlocked({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerListRes!.data?.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0) == 1;
  }

  Future<void> callblockCustomer({
    required int id,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "customer_id": id,
      "is_block": isBlocked(id: id),
      "role_id": 7,
    };
    BlockedCustomerRes blockedCustListRes = BlockedCustomerRes();
    blockedCustListRes = await liveRepository.blockedCustomerAPI(
      params: param,
      successCallBack: (message) {},
      failureCallBack: (message) {
        liveSnackBar(msg: message);
      },
    );
    blockedCustListRes = blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerRes.fromJson(blockedCustListRes.toJson())
        : BlockedCustomerRes.fromJson(BlockedCustomerRes().toJson());
    await callBlockedCustomerListRes();
    await updateBlockListToFirebase();
    return Future<void>.value();
  }

  /// ------------------------ All Zego Logic here ------------------------- ///
  ZegoUIKitPrebuiltLiveStreamingConfig get streamingConfig {
    final ZegoUIKitSignalingPlugin plugin = ZegoUIKitSignalingPlugin();
    final List<IZegoUIKitPlugin> pluginsList = <IZegoUIKitPlugin>[
      plugin,
      ZegoUIKitBeautyPlugin(),
      getBeautyPlugin()
    ];
    return ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: pluginsList);
  }

  /// code for beautification
  ZegoUIKitBeautyPlugin getBeautyPlugin() {
    final plugin = ZegoUIKitBeautyPlugin();
    final config = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.beautyBasicSmoothing, true,
        value: 80);
    final config1 = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.backgroundMosaicing, true,
        value: 90);
    plugin.setBeautyParams([config, config1], forceUpdateCache: true);
    return plugin;
  }

  /// msg update to zego cloud
  Future<void> sendKeyboardMesage(msg) async {
    final String text = algoForSendMessage(msg);
    final bool hasBadWord = hasMessageContainsAnyBadWord(msg);
    if (text.isNotEmpty) {
      liveSnackBar(msg: "$text is restricted text");
    } else if (hasBadWord) {
      liveSnackBar(msg: "Bad words are restricted");
    } else {
      final ZegoCustomMessage model = ZegoCustomMessage(
        type: 1,
        liveId: liveId.value,
        userId: astroId.value,
        userName: astroName.value,
        avatar: astroAvatar.value,
        message: msg,
        timeStamp: DateTime.now().toString(),
        fullGiftImage: "",
        isBlockedCustomer: false,
        isMod: false,
      );
      await sendMessageToZego(model);
    }

    FocusManager.instance.primaryFocus?.unfocus();
    scrollDownForTop();
    scrollDownForBottom();
    getUntil();
    update();
    return Future<void>.value();
  }

  final liveStateNotifier =
      ValueNotifier<ZegoLiveStreamingState>(ZegoLiveStreamingState.idle);

  /// Zego receiver msg
  ZegoCustomMessage receiveMessageToZego(String model) {
    final Map<String, dynamic> decodedMap = json.decode(model);
    final ZegoCustomMessage msgModel = ZegoCustomMessage.fromJson(decodedMap);
    return msgModel;
  }

  /// Zego sender msg
  Future<void> sendMessageToZego(ZegoCustomMessage model) async {
    final String encodedstring = json.encode(model.toJson());
    await zegoController.message.send(encodedstring);
    return Future<void>.value();
  }

  /// -------------------- Firebase logic -------------------- ///
  final DatabaseReference reference = FirebaseDatabase.instance.ref();

  /// update block list on firebase
  Future<void> updateBlockListToFirebase() async {
    final List<dynamic> temp = [];
    blockedCustomerListRes!.data?.forEach(
      (element) {
        temp.add((element.customerId ?? 0).toString());
      },
    );
    await reference.child("liveTest/$liveId").update(
      <String, Object?>{"blockList": temp ?? []},
    );
    return Future<void>.value();
  }

  /// get all total time from waitlist
  String getTotalWaitTime() {
    String time = "";
    int totalMinutes = 0;
    final List<String> tempList = <String>[];
    for (final WaitListModel element in waitList) {
      tempList.add(element.totalTime);
    }
    if (tempList.isEmpty) {
      time = "00:00:00";
    } else {
      for (String time in tempList) {
        totalMinutes += int.parse(time);
      }
      Duration duration = Duration(minutes: totalMinutes);
      String formattedTime = formatDuration(duration);
      time = formattedTime;
    }
    return time;
  }

  /// get wait list data from login astrologer
  void getLatestWaitList(DataSnapshot? dataSnapshot) {
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          final List<WaitListModel> tempList = <WaitListModel>[];
          map.forEach(
            // ignore: always_specify_types
            (key, value) {
              tempList.add(
                WaitListModel(
                  // ignore:  avoid_dynamic_calls
                  isRequest: value["isRequest"] ?? false,
                  // ignore:  avoid_dynamic_calls
                  isEngaded: value["isEngaded"] ?? false,
                  // ignore:  avoid_dynamic_calls
                  callType: value["callType"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  totalTime: value["totalTime"] ?? "",
                  totalMin: value["totalMin"] ?? 0,
                  // ignore:  avoid_dynamic_calls
                  avatar: value["avatar"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  userName: value["userName"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  id: value["id"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  generatedOrderId: value["generatedOrderId"] ?? 0,
                  // ignore:  avoid_dynamic_calls
                  offerId: value["offerId"] ?? 0,
                  // ignore:  avoid_dynamic_calls
                  callStatus: value["callStatus"] ?? 0,
                ),
              );
            },
          );
          waitList
            ..clear()
            ..addAll(tempList);
          // waitListModel = tempList;
        } else {}
      } else {
        waitList.clear();
      }
    } else {
      waitList.clear();
    }
    return;
  }

  getLiveAstrologerData() async {
    var liveData = await reference.child("liveTest/${liveId}").get();
    reference.child("liveTest/${liveId}/realTime").onChildAdded.listen((event) {
      final key = event.snapshot.key;
      final value = event.snapshot.value;
      getAllDataAndUpdatingFromFirebase(
          value: value as Map<dynamic, dynamic>, key: key);
      update();
    });

    reference
        .child("liveTest/${liveId}/realTime")
        .onChildChanged
        .listen((event) {
      final key = event.snapshot.key;
      final value = event.snapshot.value;
      getAllDataAndUpdatingFromFirebase(
          value: value as Map<dynamic, dynamic>, key: key);
    });

    reference
        .child("liveTest/${liveId}/realTime")
        .onChildRemoved
        .listen((event) {
      final key = event.snapshot.key;
      if (key == "leaderboard") {}
      if (key == "waitList") {}
      if (key == "gift") {}
      if (key == "order") {}
      if (key == "tarotCard") {}
    });
  }

  getAllDataAndUpdatingFromFirebase(
      {String? key, Map<dynamic, dynamic>? value}) {
    if (key == "leaderboard") {
      leaderboardModel.clear();
      value!.forEach((key, leaderBoardData) {
        leaderboardModel.add(LeaderboardModel(
          amount: leaderBoardData!["amount"] ?? 0,
          avatar: leaderBoardData["avatar"] ?? "",
          userName: leaderBoardData["userName"] ?? "",
          id: leaderBoardData["id"] ?? "",
        ));
      });
      update();
      leaderboardModel.sort(
        (LeaderboardModel a, LeaderboardModel b) {
          return b.amount.compareTo(a.amount);
        },
      );
      update();
    }
    if (key == "waitList") {
      waitList.clear();
      value!.forEach(
        (key, value) {
          waitList.add(
            WaitListModel(
              isRequest: value["isRequest"] ?? false,
              isEngaded: value["isEngaded"] ?? false,
              callType: value["callType"] ?? "",
              totalTime: value["totalTime"] ?? "",
              totalMin: value["totalMin"] ?? 0,
              avatar: value["avatar"] ?? "",
              userName: value["userName"] ?? "",
              id: value["id"] ?? "",
              generatedOrderId: value["generatedOrderId"] ?? 0,
              offerId: value["offerId"] ?? 0,
              callStatus: value["callStatus"] ?? 0,
            ),
          );
          update();
        },
      );
    }
    if (key == "gift") {}
    if (key == "order") {}
    if (key == "tarotCard") {}
  }
}
