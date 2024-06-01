// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, lines_longer_than_80_chars

import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/model/live/blocked_customer_list_res.dart";
import "package:divine_astrologer/model/live/blocked_customer_res.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/model/live/new_tarot_card_model.dart";
import "package:divine_astrologer/model/live/notice_board_res.dart";
import "package:divine_astrologer/model/res_login.dart";
import "package:divine_astrologer/repository/astrologer_profile_repository.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart";
import "package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart";
import "package:divine_astrologer/screens/live_page/constant.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:get/get.dart";
import "package:get/get_connect/http/src/status/http_status.dart";
import "package:http/http.dart" as http;

//
//
//
//
//

class LiveDharamController extends GetxController {
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());

  final AstrologerProfileRepository liveRepository =
      AstrologerProfileRepository();

  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  List<String> astroFollowPopup = <String>[];

  final RxString _userId = "".obs;
  final RxString _userName = "".obs;
  final RxString _avatar = "".obs;
  final RxBool _isMod = false.obs;
  final RxString _liveId = "".obs;
  final RxBool _isHost = true.obs;
  RxBool isHostAvailable = true.obs;
  final RxString _hostSpeciality = "".obs;
  final RxInt _currentIndex = 0.obs;
  final RxMap<dynamic, dynamic> _data = <dynamic, dynamic>{}.obs;
  var orderID = "";

  // final Rx<GetAstroDetailsRes> _details = GetAstroDetailsRes().obs;
  // final Rx<IsCustomerBlockedRes> _isCustBlocked = IsCustomerBlockedRes().obs;
  RxList<LeaderboardModel> leaderboardModel = <LeaderboardModel>[].obs;
  RxList<WaitListModel> waitListModel = <WaitListModel>[].obs;
  Rx<WaitListModel> orderModel = WaitListModel(
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
  ).obs;

  // final Rx<AstrologerFollowingResponse> _followRes =
  //     AstrologerFollowingResponse().obs;
  // final Rx<WalletRecharge> _walletRecharge = WalletRecharge().obs;
  // final Rx<OrderGenerate> _orderGenerate = OrderGenerate().obs;
  final RxBool _isFront = true.obs;
  final RxBool _isCamOn = true.obs;
  final RxBool _isMicOn = true.obs;
  WaitListModel usingForNullableWaiListModel = WaitListModel(
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
  final Rx<WaitListModel> _currentCaller = WaitListModel(
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
  ).obs;
  final RxBool _showTopBanner = false.obs;

  // final Rx<InsufficientBalModel> _insufficientBalModel =
  //     InsufficientBalModel().obs;
  final Rx<BlockedCustomerListRes> _blockedCustomerList =
      BlockedCustomerListRes().obs;
  final Rx<NoticeBoardRes> _noticeBoardRes = NoticeBoardRes().obs;
  final RxInt _timerCurrentIndex = 1.obs;

  // final RxList<String> _astroFollowPopup = <String>[].obs;
  final Rx<bool> _isWaitingForCallAstrologerPopupRes = false.obs;
  final RxList<dynamic> _firebaseBlockUsersIds = <dynamic>[].obs;
  final RxList<DeckCardModel> _deckCardModelList = <DeckCardModel>[].obs;
  final Rx<TarotGameModel> _tarotGameModel = TarotGameModel().obs;
  final RxBool _hasFollowPopupOpen = false.obs;

  // final RxBool _hasCallAcceptRejectPopupOpen = false.obs;
  // final RxString _openAceeptRejectDialogForId = "".obs;
  final Rx<RequestClass> _requestClass = RequestClass(
    type: "",
    giftData: GiftData(
      id: 0,
      giftName: "",
      giftImage: "",
      giftPrice: 0,
      giftStatus: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      fullGiftImage: "",
      animation: "",
    ),
    giftCount: 0,
  ).obs;
  final RxBool _isProcessing = false.obs;
  final RxBool _extendTimeWidgetVisible = false.obs;
  final RxBool _hasReInitCoHost = false.obs;
  final RxInt _testingVar = 0.obs;
  CollectionReference liveStore =
      FirebaseFirestore.instance.collection(livePath);
  CollectionReference liveCount =
      FirebaseFirestore.instance.collection(liveCountPath);

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  void initData() {
    userId = (pref.getUserDetail()?.id ?? "").toString();
    print(userId);
    print("userIduserIduserIduserId");
    userName = pref.getUserDetail()?.name ?? "";
    // avatar = _pref.getUserDetail()?.avatar ?? "";
    final String awsURL = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    avatar = isValidImageURL(imageURL: "$awsURL/$image");
    isMod = false;
    isHost = true;
    isHostAvailable.value = true;
    hostSpeciality = getSpeciality();

    astrologerData = <dynamic, dynamic>{};

    leaderboardModel.value = [];
    leaderboardModel.value = [];
    orderModel.value = usingForNullableWaiListModel;
    // followRes = AstrologerFollowingResponse();
    // walletRecharge = WalletRecharge();
    // orderGenerate = OrderGenerate();
    isFront = true;
    isCamOn = true;
    isMicOn = true;
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
    showTopBanner = false;
    // insufficientBalModel = InsufficientBalModel();
    blockedCustomerList = [];
    noticeBoardRes = NoticeBoardRes();
    timerCurrentIndex = 1;
    // astroFollowPopup = [];
    isWaitingForCallAstrologerPopupRes = false;
    firebaseBlockUsersIds = [];
    deckCardModelList = [];
    tarotGameModel = TarotGameModel();
    hasFollowPopupOpen = false;
    // hasCallAcceptRejectPopupOpen = false;
    // openAceeptRejectDialogForId = "";
    clearRequest();
    isProcessing = false;
    extendTimeWidgetVisible = false;
    hasReInitCoHost = false;

    return;
  }

  @override
  void onClose() {
    _userId.close();
    _userName.close();
    _avatar.close();
    _isMod.close();
    _liveId.close();
    _isHost.close();

    _hostSpeciality.close();
    _currentIndex.close();
    _data.close();
    // _details.close();
    // _isCustBlocked.close();
    leaderboardModel.close();
    waitListModel.close();

    // _followRes.close();
    // _walletRecharge.close();
    // _orderGenerate.close();
    _isFront.close();
    _isCamOn.close();
    _isMicOn.close();
    _currentCaller.close();
    _showTopBanner.close();
    // _insufficientBalModel.close();
    _blockedCustomerList.close();
    _noticeBoardRes.close();
    _timerCurrentIndex.close();
    // _astroFollowPopup.close();
    _isWaitingForCallAstrologerPopupRes.close();
    _firebaseBlockUsersIds.close();
    _deckCardModelList.close();
    _tarotGameModel.close();
    _hasFollowPopupOpen.close();
    // _hasCallAcceptRejectPopupOpen.close();
    // _openAceeptRejectDialogForId.close();
    _requestClass.close();
    _isProcessing.close();
    _extendTimeWidgetVisible.close();
    _hasReInitCoHost.close();
    _testingVar.close();

    super.onClose();
  }

  String get userId => _userId.value;

  set userId(String value) => _userId(value);

  String get userName => _userName.value;

  set userName(String value) => _userName(value);

  String get avatar => _avatar.value;

  set avatar(String value) => _avatar(value);

  bool get isMod => _isMod.value;

  set isMod(bool value) => _isMod(value);

  bool get isHost => _isHost.value;

  set isHost(bool value) => _isHost(value);

  String get hostSpeciality => _hostSpeciality.value;

  set hostSpeciality(String value) => _hostSpeciality(value);

  Map<dynamic, dynamic> get astrologerData => _data.value;

  set astrologerData(Map<dynamic, dynamic> value) => _data(value);

  // GetAstroDetailsRes get details => _details.value;
  // set details(GetAstroDetailsRes value) => _details(value);

  // IsCustomerBlockedRes get isCustBlocked => _isCustBlocked.value;
  // set isCustBlocked(IsCustomerBlockedRes value) => _isCustBlocked(value);

  // AstrologerFollowingResponse get followRes => _followRes.value;
  // set followRes(AstrologerFollowingResponse value) => _followRes(value);

  // WalletRecharge get walletRecharge => _walletRecharge.value;
  // set walletRecharge(WalletRecharge value) => _walletRecharge(value);

  // OrderGenerate get orderGenerate => _orderGenerate.value;
  // set orderGenerate(OrderGenerate value) => _orderGenerate(value);

  bool get isFront => _isFront.value;

  set isFront(bool value) => _isFront(value);

  bool get isCamOn => _isCamOn.value;

  set isCamOn(bool value) => _isCamOn(value);

  bool get isMicOn => _isMicOn.value;

  set isMicOn(bool value) => _isMicOn(value);

  WaitListModel get currentCaller => _currentCaller.value;

  set currentCaller(WaitListModel value) => _currentCaller(value);

  bool get showTopBanner => _showTopBanner.value;

  set showTopBanner(bool value) => _showTopBanner(value);

  // InsufficientBalModel get insufficientBalModel => _insufficientBalModel.value;
  // set insufficientBalModel(InsufficientBalModel value) =>
  //     _insufficientBalModel(value);

  List<BlockedCustomerListResData> blockedCustomerList = [];

  NoticeBoardRes get noticeBoardRes => _noticeBoardRes.value;

  set noticeBoardRes(NoticeBoardRes value) => _noticeBoardRes(value);

  int get timerCurrentIndex => _timerCurrentIndex.value;

  set timerCurrentIndex(int value) => _timerCurrentIndex(value);

  // List<String> get astroFollowPopup => _astroFollowPopup.value;
  // set astroFollowPopup(List<String> value) => _astroFollowPopup(value);

  bool get isWaitingForCallAstrologerPopupRes =>
      _isWaitingForCallAstrologerPopupRes.value;

  set isWaitingForCallAstrologerPopupRes(bool value) =>
      _isWaitingForCallAstrologerPopupRes(value);

  List<dynamic> get firebaseBlockUsersIds => _firebaseBlockUsersIds.value;

  set firebaseBlockUsersIds(List<dynamic> value) =>
      _firebaseBlockUsersIds(value);

  List<DeckCardModel> get deckCardModelList => _deckCardModelList.value;

  set deckCardModelList(List<DeckCardModel> value) => _deckCardModelList(value);

  TarotGameModel get tarotGameModel => _tarotGameModel.value;

  set tarotGameModel(TarotGameModel value) => _tarotGameModel(value);

  bool get hasFollowPopupOpen => _hasFollowPopupOpen.value;

  set hasFollowPopupOpen(bool value) => _hasFollowPopupOpen(value);

  // bool get hasCallAcceptRejectPopupOpen => _hasCallAcceptRejectPopupOpen.value;
  // set hasCallAcceptRejectPopupOpen(bool value) =>
  //     _hasCallAcceptRejectPopupOpen(value);

  // String get openAceeptRejectDialogForId => _openAceeptRejectDialogForId.value;
  // set openAceeptRejectDialogForId(String value) =>
  //     _openAceeptRejectDialogForId(value);

  RequestClass get requestClass => _requestClass.value;

  set requestClass(RequestClass value) => _requestClass(value);

  bool get isProcessing => _isProcessing.value;

  set isProcessing(bool value) => _isProcessing(value);

  bool get extendTimeWidgetVisible => _extendTimeWidgetVisible.value;

  set extendTimeWidgetVisible(bool value) => _extendTimeWidgetVisible(value);

  bool get hasReInitCoHost => _hasReInitCoHost.value;

  set hasReInitCoHost(bool value) => _hasReInitCoHost(value);

  Future<void> eventListner({
    required Map<dynamic, dynamic> snapshot,
    required Function(WaitListModel currentCaller) engaging,
    // Widget? timer,
  }) async {
    if (snapshot != null) {
      astrologerData = snapshot;
      log(astrologerData.toString());
      log("data.toString()");
      if (astrologerData.isNotEmpty) {
        var liveIdNode = astrologerData;
        if (liveIdNode != null) {
          isHostAvailable.value = liveIdNode["isAvailable"] ?? false;
          List<dynamic> blockListNode = liveIdNode["blockList"] ?? [];
          List<dynamic> waitListData = liveIdNode["waitList"] ?? [];
          List<dynamic> leaderBoard = liveIdNode["leaderBoard"] ?? [];
          if (blockListNode.isNotEmpty) {
            firebaseBlockUsersIds = blockListNode;
          } else {
            firebaseBlockUsersIds.clear();
          }
          if (waitListData.isNotEmpty) {
            print(waitListData);
            print(waitListData.isNotEmpty);
            print("waitListData");
            addToWaitListFunction(waitListData: waitListData);
          } else {
            print("cleancleancleanclean");
            waitListModel.value.clear();
            update();
          }

          if (leaderBoard != null) {
            addToLeaderBoardFunction(leaderBoard: leaderBoard);
          } else {
            leaderboardModel.value.clear();
            update();
          }
          if (liveIdNode["order"] != null) {
            var orderNode = liveIdNode["order"];
            orderModel.value = getOrderModel(orderNode);
            currentCaller =
                getOrderModelGeneric(orderNode, forMe: true, type: "fromevent");
          } else {
            orderModel.value = usingForNullableWaiListModel;
            currentCaller = usingForNullableWaiListModel;
            update();
          }
          if (liveIdNode["isAvailable"] != null) {
            isHostAvailable.value = liveIdNode["isAvailable"];
          }

          print(currentCaller.isEngaded);
          print("currentCaller.isEngaded");
          await Future.delayed(const Duration(seconds: 1));
          if (waitListModel.isNotEmpty) {
            engaging(waitListModel.first);
          }
        } else {}
        update();
      } else {
        print("dataISEMPTRY");
      }
    } else {}

    return Future<void>.value();
  }

  /// add to waitList function
  addToWaitListFunction({List? waitListData}) {
    waitListModel.value.clear();
    for (int i = 0; i < waitListData!.length; i++) {
      waitListModel.add(
        WaitListModel(
          isRequest: waitListData[i]["isRequest"],
          isEngaded: waitListData[i]["isEngaded"],
          callType: waitListData[i]["callType"],
          totalTime: waitListData[i]["totalTime"],
          totalMin: waitListData[i]["totalMin"],
          userName: waitListData[i]["userName"],
          avatar: waitListData[i]["avatar"],
          id: waitListData[i]["id"],
          generatedOrderId: waitListData[i]["generatedOrderId"],
          offerId: waitListData[i]["offerId"],
          callStatus: waitListData[i]["callStatus"],
        ),
      );
    }
    update();
  }

  /// add to leader board function
  addToLeaderBoardFunction({List? leaderBoard}) {
    leaderboardModel.value.clear();
    for (int i = 0; i < leaderBoard!.length; i++) {
      leaderboardModel.add(
        LeaderboardModel(
          userName: leaderBoard[i]["userName"],
          avatar: leaderBoard[i]["avatar"],
          id: leaderBoard[i]["id"],
          amount: leaderBoard[i]["amount"],
        ),
      );
    }
    update();
  }

  // WaitListModel upcomingUser(Map<dynamic, dynamic> data) {
  WaitListModel upcomingUser({List? waitList}) {
    WaitListModel temp = WaitListModel(
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

    if (waitList != null) {
      temp = isEngadedNew(waitList);
    } else {}

    return temp;
  }

  WaitListModel isEngadedNew(
    List? map,
  ) {
    bool isRequest = false;
    bool isEngaged = false;
    String callType = "";
    String totalTime = "";
    String avatar = "";
    String userName = "";
    String id = "";
    int generatedOrderId = 0;
    int offerId = 0;
    int callStatus = 0;
    int totalMin = 0;

    if (map != null) {
      // if (map.isNotEmpty) {
      //   map.forEach(
      //     // ignore: always_specify_types
      //     (key, value) {
      //       final bool c1 = (value["id"] ?? "") == userId;
      //       final bool c2 = (value["isEngaded"] ?? false) == true;
      //       isEngaged = forMe ? c1 && c2 : c2;
      //       isRequest = value["isRequest"] ?? false;
      //       callType = value["callType"] ?? "";
      //       totalTime = value["totalTime"] ?? "";
      //       avatar = value["avatar"] ?? "";
      //       userName = value["userName"] ?? "";
      //       id = value["id"] ?? "";
      //       generatedOrderId = value["generatedOrderId"] ?? 0;
      //       offerId = value["offerId"] ?? 0;
      //       totalMin = value["totalMin"] ?? 0;
      //       callStatus = value["callStatus"] ?? 0;
      //     },
      //   );
      // } else {}
    } else {}
    return WaitListModel(
      isRequest: isRequest,
      isEngaded: isEngaged,
      callType: callType,
      totalTime: totalTime,
      avatar: avatar,
      userName: userName,
      id: id,
      totalMin: totalMin,
      generatedOrderId: generatedOrderId,
      offerId: offerId,
      callStatus: callStatus,
    );
  }

  void updateInfo() {
    // astroFollowPopup = [];
    // do not write await here!
    sendBroadcast(
      BroadcastMessage(name: "LiveDharamScreen_eventListner"),
    );
    return;
  }

  WaitListModel engagedCoHostWithAstro() {
    WaitListModel temp = WaitListModel(
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

    if (astrologerData != null) {
      var liveIdNode = astrologerData;
      if (liveIdNode != null) {
        print(liveIdNode);
        print("engagedCoHostWithAstro---liveIdNodeliveIdNode");
        if (liveIdNode != null && liveIdNode["order"] != null) {
          var orderNode = liveIdNode["order"];
          temp = getOrderModelGeneric(orderNode,
              forMe: false, type: "engagedCoHostWithAstro");
        }
      }
    }

    return temp;
  }

  WaitListModel getOrderModel(Map? map) {
    bool isRequest = false;
    bool isEngaged = false;
    String callType = "";
    String totalTime = "";
    String avatar = "";
    String userName = "";
    String id = "";
    int generatedOrderId = 0;
    int offerId = 0;
    int totalMin = 0;
    int callStatus = 0;
    if (map != null) {
      if (map.isNotEmpty) {
        isRequest = map["isRequest"] ?? false;
        isEngaged = map["isEngaded"] ?? false;
        callType = map["callType"] ?? "";
        totalTime = map["totalTime"] ?? "";
        avatar = map["avatar"] ?? "";
        totalMin = map["totalMin"] ?? "";
        userName = map["userName"] ?? "";
        id = map["id"] ?? "";
        generatedOrderId = map["generatedOrderId"] ?? 0;
        offerId = map["offerId"] ?? 0;
        callStatus = map["callStatus"] ?? 0;
      } else {}
    } else {}
    return WaitListModel(
      isRequest: isRequest,
      isEngaded: isEngaged,
      callType: callType,
      totalTime: totalTime,
      avatar: avatar,
      totalMin: totalMin,
      userName: userName,
      id: id,
      generatedOrderId: generatedOrderId,
      offerId: offerId,
      callStatus: callStatus,
    );
  }

  WaitListModel getOrderModelGeneric(Map? map,
      {required bool forMe, String? type}) {
    bool isRequest = false;
    bool isEngaged = false;
    String callType = "";
    String totalTime = "";
    String avatar = "";
    String userName = "";
    String id = "";
    int generatedOrderId = 0;
    int totalMin = 0;
    int offerId = 0;
    int callStatus = 0;
    if (map != null) {
      if (map.isNotEmpty) {
        print(
            'orderId--${map["id"]}----userId---$userId------isEngaged--${map["isEngaded"]}---$type');
        final bool c1 = (map["id"] ?? "") == userId;
        final bool c2 = (map["isEngaded"] ?? false) == true;
        // isEngaged = forMe ? c1 && c2 : c2;
        isEngaged = map["isEngaded"];
        isRequest = map["isRequest"] ?? false;
        callType = map["callType"] ?? "";
        totalTime = map["totalTime"] ?? "";
        avatar = map["avatar"] ?? "";
        userName = map["userName"] ?? "";
        id = map["id"] ?? "";
        generatedOrderId = map["generatedOrderId"] ?? 0;
        offerId = map["offerId"] ?? 0;
        totalMin = map["totalMin"] ?? 0;
        callStatus = map["callStatus"] ?? 0;
        print(isEngaged);
        print(isEngaged);
      } else {}
    } else {}
    return WaitListModel(
      isRequest: isRequest,
      isEngaded: isEngaged,
      callType: callType,
      totalTime: totalTime,
      avatar: avatar,
      userName: userName,
      totalMin: totalMin,
      id: id,
      generatedOrderId: generatedOrderId,
      offerId: offerId,
      callStatus: callStatus,
    );
  }

  // bool checkIfAstrologerAvailable(Map<dynamic, dynamic> map) {
  //   bool isAvailable = false;
  //   if (map.isEmpty) {
  //     return isAvailable;
  //   } else {
  //     final Map<dynamic, dynamic> currentHostId = map[liveId] ?? {};
  //     isAvailable = currentHostId["isAvailable"] ?? false;
  //     return isAvailable;
  //   }
  // }

  // String requirePreviousLiveID({
  //   required Function() acknowledgement,
  //   required Function() stillProcessing,
  // }) {
  //   final processing = isProcessing;
  //   final bool has = hasMyIdInWaitList() || isWaitingForCallAstrologerPopupRes;
  //   if (processing) {
  //     stillProcessing();
  //     return "";
  //   } else if (has) {
  //     acknowledgement();
  //     return "";
  //   } else {
  //     currentIndex = currentIndex - 1;
  //     if (currentIndex < 0) {
  //       currentIndex = data.keys.toList().length - 1;
  //     } else {}
  //     if (data.keys.toList()[currentIndex] != null) {
  //       liveId = data.keys.toList()[currentIndex];
  //       updateInfo();
  //       return liveId;
  //     } else {
  //       return "";
  //     }
  //   }
  // }

  // String requireNextLiveID({
  //   required Function() acknowledgement,
  //   required Function() stillProcessing,
  // }) {
  //   final processing = isProcessing;
  //   final bool has = hasMyIdInWaitList() || isWaitingForCallAstrologerPopupRes;
  //   if (processing) {
  //     stillProcessing();
  //     return "";
  //   } else if (has) {
  //     acknowledgement();
  //     return "";
  //   } else {
  //     currentIndex = currentIndex + 1;
  //     if (currentIndex > data.keys.toList().length - 1) {
  //       currentIndex = 0;
  //     } else {}
  //     if (data.keys.toList()[currentIndex] != null) {
  //       liveId = data.keys.toList()[currentIndex];
  //       updateInfo();
  //       return liveId;
  //     } else {
  //       return "";
  //     }
  //   }
  // }

  Map<String, dynamic> createGift({
    required num count,
    required String svga,
    required Map<String, dynamic> data,
  }) {
    final String accessToken = pref.getToken() ?? "";
    return <String, dynamic>{
      "app_id": appID,
      "server_secret": serverSecret,
      "room_id": userId,
      "user_id": userId,
      "user_name": userName,
      "gift_type": data,
      "gift_count": count,
      "access_token": accessToken,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<void> sendGiftAPI({
    required num count,
    required String svga,
    required Map<String, dynamic> data,
    required void Function(String message) successCallback,
    required void Function(String message) failureCallback,
  }) async {
    try {
      const String url = "https://zego-virtual-gift.vercel.app/api/send_gift";
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(
          createGift(count: count, svga: svga, data: data),
        ),
      );
      response.statusCode == HttpStatus.ok
          ? successCallback("Yay!")
          : failureCallback("[ERROR], Send Gift Fail: ${response.statusCode}");
    } on Exception catch (error) {
      failureCallback("[ERROR], Send Gift Fail, $error");
    }
    return Future<void>.value();
  }

  // Future<void> getAstrologerDetails({
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{"astrologer_id": int.parse(liveId)};
  //   GetAstroDetailsRes getAstroDetailsRes = GetAstroDetailsRes();
  //   getAstroDetailsRes = await liveRepository.getAstroDetailsAPI(
  //     params: param,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   details = getAstroDetailsRes.statusCode == HttpStatus.ok
  //       ? GetAstroDetailsRes.fromJson(getAstroDetailsRes.toJson())
  //       : GetAstroDetailsRes.fromJson(GetAstroDetailsRes().toJson());
  //   details.data?.image = isValidImageURL(imageURL: details.data?.image ?? "");
  //   details.data?.speciality = getSpeciality();
  //   //
  //   testingVar = testingVar + 1;
  //   return Future<void>.value();
  // }

  // Future<void> isCustomerBlocked({
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   Map<String, dynamic> params = <String, dynamic>{};
  //   params = <String, dynamic>{"member_id": liveId};
  //   IsCustomerBlockedRes isCustomerBlockedRes = IsCustomerBlockedRes();
  //   isCustomerBlockedRes = await liveRepository.isCustomerBlockedAPI(
  //     params: params,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   isCustBlocked = isCustomerBlockedRes.statusCode == HttpStatus.ok
  //       ? IsCustomerBlockedRes.fromJson(isCustomerBlockedRes.toJson())
  //       : IsCustomerBlockedRes.fromJson(IsCustomerBlockedRes().toJson());
  //   return Future<void>.value();
  // }

  bool isCustomerBlockedBool() {
    return false;
  }

  String getSpeciality() {
    final List<String> pivotList = <String>[];
    pref.getUserDetail()?.astroCatPivot?.forEach(
          (AstroCatPivot e) => pivotList.add(e.categoryDetails?.name ?? ""),
        );
    return pivotList.join(", ");
  }

  /// old realTime data base of leader board
  // void getLatestLeaderboard(DataSnapshot? dataSnapshot) {
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         final List<LeaderboardModel> tempList = <LeaderboardModel>[];
  //         map.forEach(
  //           (key, value) {
  //             tempList.add(
  //               LeaderboardModel(
  //                 amount: value["amount"] ?? 0,
  //                 avatar: value["avatar"] ?? "",
  //                 userName: value["userName"] ?? "",
  //                 id: value["id"] ?? "",
  //               ),
  //             );
  //           },
  //         );
  //         leaderboardModel
  //           ..clear()
  //           ..addAll(tempList);
  //
  //         leaderboardModel.sort(
  //           (LeaderboardModel a, LeaderboardModel b) {
  //             return b.amount.compareTo(a.amount);
  //           },
  //         );
  //       } else {}
  //     } else {
  //       leaderboardModel.clear();
  //     }
  //   } else {
  //     leaderboardModel.clear();
  //   }
  //   return;
  // }

  Future<void> addUpdateToWaitList({
    required String customerId,
    required String callType,
    required bool isEngaded,
    required bool isRequest,
    required int callStatus,
    // required int totalMin,
  }) async {
    print(callType);
    print("previousTypepreviousTypepreviousType");
    // final DataSnapshot dataSnapshot =
    //     await ref.child("$livePath/$liveId/realTime/waitList/$userId").get();
    // if (dataSnapshot != null) {
    //   if (dataSnapshot.exists) {
    //     if (dataSnapshot.value is Map<dynamic, dynamic>) {
    //       Map<dynamic, dynamic> map = <dynamic, dynamic>{};
    //       map = (dataSnapshot.value ?? <dynamic, dynamic>{})
    //           as Map<dynamic, dynamic>;
    //       final String type = map["callType"] ?? "";
    //       previousType = type;
    //     } else {}
    //   } else {}
    // } else {}
    // for (int i = 0; i < _waitListModel.length; i++) {
    //   if (waitListModel[i].id == userId) {
    //     previousType = waitListModel[i].callType ?? "";
    //     break;
    //   }
    // }
    // update to order but no need longer
    // final ogOrderDetails = <String, dynamic>{
    //   "isRequest": isRequest,
    //   "isEngaded": isEngaded,
    //   "callType": previousType.toLowerCase(),
    //   // "totalTime": "2",
    //   "userName": userName,
    //   "avatar": avatar,
    //   // "totalMin": totalMin,
    //   "id": userId,
    //   // "generatedOrderId": (orderGenerate.data?.generatedOrderId ?? 0),
    //   // "offerId": (details.data?.offerDetails?.offerId ?? 0)
    //   "callStatus": callStatus,
    // };
    int index = waitListModel.indexWhere((item) => item.id == customerId);
    if (index != -1) {
      waitListModel[index].callStatus = callStatus;

      // Update the document with the modified blockList
      await liveStore.doc(userId).update({
        'waitList': jsonEncode(waitListModel),
      });
    }
    final Map<String, dynamic> moOrderDetails = <String, dynamic>{
      "callStatus": callStatus,
    };
    //
    // await ref
    //     .child("$livePath/$liveId/realTime/waitList/$userId")
    //     .update(moOrderDetails);
    // old code in real Time no need to update
    // if (callStatus == 2) {
    //   await addUpdateOrder(ogOrderDetails);
    //   await removeFromWaitList();
    // } else {}
    return Future<void>.value();
  }

  Future<void> addUpdateOrder(Map<String, dynamic> orderDetails) async {
    print(orderDetails);
    print("updating entry orderDetails");
    // await ref.child("$livePath/$liveId/realTime/order").update(orderDetails);
    await liveStore.doc(userId).update({
      'order': orderDetails,
    });
    return Future<void>.value();
  }

  // String generateFutureTime() {
  //   final DateTime current = DateTime.now();
  //   final int min = (orderGenerate.data?.talktime ?? 0);
  //   final DateTime addedTime = current.add(Duration(minutes: min));
  //   final int millisecondsSinceEpoch = addedTime.millisecondsSinceEpoch;
  //   return millisecondsSinceEpoch.toString();
  // }

  // Future<void> extendTime() async {
  //   final Map<String, dynamic> orderDetails = {
  //     "isRequest": orderModel.isRequest,
  //     "isEngaded": orderModel.isEngaded,
  //     "callType": orderModel.callType,
  //     "totalTime": generateFutureTime(),
  //     "userName": orderModel.userName,
  //     "avatar": orderModel.avatar,
  //     "id": orderModel.id,
  //     "generatedOrderId": orderModel.generatedOrderId,
  //     "offerId": orderModel.offerId,
  //     "callStatus": orderModel.callStatus,
  //   };
  //   await addUpdateOrder(orderDetails);
  // }

  void getLatestWaitList(
    DataSnapshot? dataSnapshot,
  ) {
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
          waitListModel
            ..clear()
            ..addAll(tempList);
          // waitListModel = tempList;
        } else {}
      } else {
        waitListModel.value.clear();
      }
    } else {
      waitListModel.value.clear();
    }
    return;
  }

  Future<void> removeFromOrder() async {
    print("remove order from firebase");
    // await ref.child("$livePath/$liveId/realTime/order").remove();
    await liveStore.doc(userId).update({
      'order': FieldValue.delete(),
    });
    return Future<void>.value();
  }

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

  String getTotalWaitTime() {
    String time = "";
    int totalMinutes = 0;
    final List<String> tempList = <String>[];
    for (final WaitListModel element in waitListModel) {
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

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String _twoDigits(int n) {
    return n >= 10 ? '$n' : '0$n';
  }

  Future<void> addUpdateToBlockList() async {
    final List<dynamic> temp = [];
    blockedCustomerList.forEach(
      (element) {
        temp.add((element.customerId ?? 0).toString());
      },
    );
    await liveStore.doc(userId).update(
      <String, Object?>{
        "blockList": temp ?? [],
      },
    );
    return Future<void>.value();
  }

  Future<void> makeAPICallForEndCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    // bool isExist = false;
    // final String path = "$livePath/$liveId/order";
    // final DataSnapshot dataSnapshot = await ref.child(path).get();
    // if (dataSnapshot != null) {
    //   if (dataSnapshot.exists) {
    //     if (dataSnapshot.value is Map<dynamic, dynamic>) {
    //       Map<dynamic, dynamic> map = <dynamic, dynamic>{};
    //       map = (dataSnapshot.value ?? <dynamic, dynamic>{})
    //           as Map<dynamic, dynamic>;
    //       final String userId = map["id"] ?? "";
    //       isExist = currentCaller.id == userId;
    //     } else {}
    //   } else {}
    // } else {
    //
    // }
    print(astrologerData);
    print("datadatadatadatadatadatadata");
    if (astrologerData != null && astrologerData["order"] != null) {
      Map<String, dynamic> param = <String, dynamic>{};
      param = <String, dynamic>{
        "order_id": getOrderId(),
        "duration": "0",
        "amount": "0.0",
        "role_id": 7,
      };
      final int offerId = getOfferId();
      param.addAll(<String, dynamic>{"offer_id": offerId});
      if (orderID != getOrderId()) {
        orderID = getOrderId();
        await liveRepository.endLiveApi(
          params: param,
          successCallBack: successCallBack,
          failureCallBack: failureCallBack,
        );
      }
    } else {
      print("order is empty");
    }
    return Future<void>.value();
  }

  Future<void> makeAPICallForEndCallWithoutFirebase({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "order_id": getOrderId(),
      "duration": "0",
      "amount": "0.0",
      "role_id": 7,
    };
    final int offerId = getOfferId();
    param.addAll(<String, dynamic>{"offer_id": offerId});
    print("makeAPICallForEndCall Without Firebase");
    await liveRepository.endLiveApi(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    return Future<void>.value();
  }

  // String getOrderId() {
  //   String generatedOrderId = "";
  //   int temp = 0;
  //   if (temp == 0) {
  //     temp = currentCaller.generatedOrderId;
  //     generatedOrderId = temp.toString();
  //   } else {}
  //   return generatedOrderId;
  // }

  // int getOfferId() {
  //   int offerId = 0;
  //   int temp = 0;
  //   if (temp == 0) {
  //     temp = currentCaller.offerId;
  //     offerId = temp;
  //   } else {}
  //   return offerId;
  // }

  String getOrderId() {
    // int temp = orderGenerate.data?.generatedOrderId ?? 0;
    int temp = 0;
    if (temp != 0) {
      return temp.toString();
    } else {
      temp = orderModel.value.generatedOrderId;
      return temp.toString();
    }
  }

  int getOfferId() {
    // int temp = details.data?.offerDetails?.offerId ?? 0;
    int temp = 0;
    if (temp != 0) {
      return temp;
    } else {
      temp = orderModel.value.offerId;
      update();
      return temp;
    }
  }

  Future<void> removeMyNode() async {
    // await ref.child("$livePath/$liveId").remove();
    await liveStore.doc(userId).delete();
    await liveCount.doc(userId).delete();
    update();
    return Future<void>.value();
  }

  Future<void> callBlockedCustomerListRes({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{"role_id": 7};
    BlockedCustomerListRes blockedCustListRes = BlockedCustomerListRes();
    blockedCustListRes = await liveRepository.blockedCustomerListAPI(
      params: param,
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    blockedCustomerList = (blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerListRes.fromJson(blockedCustListRes.toJson()).data
        : BlockedCustomerListRes.fromJson(BlockedCustomerListRes().toJson())
            .data)!;
    print(blockedCustomerList);
    print(
        "blockedCustomerListblockedCustomerListblockedCustomerListblockedCustomerList");
    return Future<void>.value();
  }

  Future<void> callblockCustomer({
    required int id,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    Map<String, dynamic> param = <String, dynamic>{};
    param = <String, dynamic>{
      "customer_id": id,
      "is_block": getBlockedInInt(id: id) == 0 ? 1 : 0,
      "role_id": 7,
    };
    BlockedCustomerRes blockedCustListRes = BlockedCustomerRes();
    blockedCustListRes = await liveRepository.blockedCustomerAPI(
      params: param,
      successCallBack: (message) {
        if (getBlockedInInt(id: id) == 0) {
          AppFirebaseService().writeData("user/${id}/realTime", {
            "block": _userId.value,
          });
        } else {
          FirebaseDatabase.instance
              .ref()
              .child("user/${id}/realTime/block")
              .remove();
        }
        update();
      },
      failureCallBack: failureCallBack,
    );
    blockedCustListRes = blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerRes.fromJson(blockedCustListRes.toJson())
        : BlockedCustomerRes.fromJson(BlockedCustomerRes().toJson());
    await callBlockedCustomerListRes(
      successCallBack: (message) {},
      failureCallBack: failureCallBack,
    );

    await addUpdateToBlockList();
    return Future<void>.value();
  }

  bool isBlocked({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerList.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0) == 1;
  }

  int getBlockedInInt({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerList?.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0);
  }

  Future<void> noticeBoard({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    NoticeBoardRes res = NoticeBoardRes();
    res = await liveRepository.noticeBoardAPI(
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    noticeBoardRes = res.statusCode == HttpStatus.ok
        ? NoticeBoardRes.fromJson(res.toJson())
        : NoticeBoardRes.fromJson(NoticeBoardRes().toJson());
    return Future<void>.value();
  }

  void clearRequest() {
    requestClass = RequestClass(
      type: "",
      giftData: GiftData(
        id: 0,
        giftName: "",
        giftImage: "",
        giftPrice: 0,
        giftStatus: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fullGiftImage: "",
        animation: "",
      ),
      giftCount: 0,
    );
    return;
  }

  void tarotCardInit() {
    NewTarotCardModel newTarotCardModel = NewTarotCardModel();
    newTarotCardModel = LiveSharedPreferencesSingleton().getAllTarotCard();
    deckCardModelList = [...newTarotCardModel.data ?? []];
    for (var element in deckCardModelList) {
      element.image = "${pref.getAmazonUrl()}/${element.image}";
    }
    return;
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

// Future<void> callblockCustomerByMod({
//   required int id,
//   required Function(String message) successCallBack,
//   required Function(String message) failureCallBack,
// }) async {
//   Map<String, dynamic> param = <String, dynamic>{};
//   param = <String, dynamic>{
//     "customer_id": id,
//     // "unblock": 0,
//   };
//   await liveRepository.blockedCustomerFromModAPI(
//     params: param,
//     successCallBack: successCallBack,
//     failureCallBack: failureCallBack,
//   );
//   return Future<void>.value();
// }
}

class CustomGiftModel {
  CustomGiftModel({
    required this.giftId,
    required this.giftName,
    required this.giftImage,
    required this.giftPrice,
    required this.giftSvga,
    required this.bytes,
  });

  final int giftId;
  final String giftName;
  final String giftImage;
  final int giftPrice;
  final String giftSvga;
  final List<int> bytes;
}

class LeaderboardModel {
  LeaderboardModel({
    required this.amount,
    required this.avatar,
    required this.userName,
    required this.id,
  });

  final int amount;
  final String avatar;
  final String userName;
  final String id;
}

class WaitListModel {
  WaitListModel({
    required this.isRequest,
    required this.isEngaded,
    required this.callType,
    required this.totalTime,
    required this.avatar,
    required this.userName,
    required this.id,
    required this.generatedOrderId,
    required this.offerId,
    required this.totalMin,
    required this.callStatus,
  });

  final bool isRequest;
  final bool isEngaded;
  final String callType;
  final String totalTime;
  final String avatar;
  final String userName;
  final String id;
  final int generatedOrderId;
  final int offerId;
  int callStatus;
  final int totalMin;
}

class ZegoCustomMessage {
  int type = 0;
  String liveId = "";
  String userId = "";
  String userName = "";
  String avatar = "";
  String message = "";
  String timeStamp = "";
  String fullGiftImage = "";
  bool isBlockedCustomer = false;
  bool isMod = false;

  ZegoCustomMessage({
    required this.type,
    required this.liveId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.message,
    required this.timeStamp,
    required this.fullGiftImage,
    required this.isBlockedCustomer,
    required this.isMod,
  });

  ZegoCustomMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    liveId = json['liveId'];
    userId = json['userId'];
    userName = json['userName'];
    avatar = json['avatar'];
    message = json['message'];
    timeStamp = json['timeStamp'];
    fullGiftImage = json['fullGiftImage'];
    isBlockedCustomer = json['isBlockedCustomer'];
    isMod = json['isMod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['liveId'] = liveId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['avatar'] = avatar;
    data['message'] = message;
    data['timeStamp'] = timeStamp;
    data['fullGiftImage'] = fullGiftImage;
    data['isBlockedCustomer'] = isBlockedCustomer;
    data['isMod'] = isMod;
    return data;
  }
}

class TarotGameModel {
  int? currentStep;
  int? canPick;
  List<UserPicked>? userPicked;
  String? senderId;
  String? receiverId;

  TarotGameModel({
    this.currentStep,
    this.canPick,
    this.userPicked,
    this.senderId,
    this.receiverId,
  });

  TarotGameModel.fromJson(Map<String, dynamic> json) {
    currentStep = json['current_step'];
    canPick = json['can_pick'];
    if (json['user_picked'] != null) {
      userPicked = <UserPicked>[];
      json['user_picked'].forEach((v) {
        userPicked!.add(UserPicked.fromJson(v));
      });
    }
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_step'] = currentStep;
    data['can_pick'] = canPick;
    if (userPicked != null) {
      data['user_picked'] = userPicked!.map((v) => v.toJson()).toList();
    }
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    return data;
  }
}

class UserPicked {
  int? id;
  String? name;
  int? status;
  String? image;

  UserPicked({this.id, this.name, this.status, this.image});

  UserPicked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['image'] = image;
    return data;
  }
}

class RequestClass {
  final String type;
  final GiftData giftData;
  final num giftCount;

  RequestClass({
    required this.type,
    required this.giftData,
    required this.giftCount,
  });
}
