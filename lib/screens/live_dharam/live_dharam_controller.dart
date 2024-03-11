// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, lines_longer_than_80_chars

import "dart:async";
import "dart:convert";

import "package:divine_astrologer/di/shared_preference_service.dart";
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
import "package:firebase_database/firebase_database.dart";
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
  final RxBool _isHostAvailable = true.obs;
  final RxString _hostSpeciality = "".obs;
  final RxInt _currentIndex = 0.obs;
  final RxMap<dynamic, dynamic> _data = <dynamic, dynamic>{}.obs;
  // final Rx<GetAstroDetailsRes> _details = GetAstroDetailsRes().obs;
  // final Rx<IsCustomerBlockedRes> _isCustBlocked = IsCustomerBlockedRes().obs;
  final RxList<LeaderboardModel> _leaderboardModel = <LeaderboardModel>[].obs;
  final RxList<WaitListModel> _waitListModel = <WaitListModel>[].obs;
  final Rx<WaitListModel> _orderModel = WaitListModel(
    isRequest: false,
    isEngaded: false,
    callType: "",
    totalTime: "",
    avatar: "",
    userName: "",
    id: "",
    generatedOrderId: 0,
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

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  void initData() {
    userId = (pref.getUserDetail()?.id ?? "").toString();
    userName = pref.getUserDetail()?.name ?? "";
    // avatar = _pref.getUserDetail()?.avatar ?? "";
    final String awsURL = pref.getAmazonUrl() ?? "";
    final String image = pref.getUserDetail()?.image ?? "";
    avatar = isValidImageURL(imageURL: "$awsURL/$image");
    isMod = false;
    liveId = (Get.arguments ?? "").toString();
    isHost = true;
    isHostAvailable = true;
    hostSpeciality = getSpeciality();
    // currentIndex = 0;
    currentIndex = currentIndex == 0 ? 0 : currentIndex;
    data = <dynamic, dynamic>{};
    // details = GetAstroDetailsRes();
    // isCustBlocked = IsCustomerBlockedRes();
    leaderboardModel = <LeaderboardModel>[];
    waitListModel = <WaitListModel>[];
    orderModel = WaitListModel(
      isRequest: false,
      isEngaded: false,
      callType: "",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
      generatedOrderId: 0,
      offerId: 0,
      callStatus: 0,
    );
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
      callStatus: 0,
    );
    showTopBanner = false;
    // insufficientBalModel = InsufficientBalModel();
    blockedCustomerList = BlockedCustomerListRes();
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
    testingVar = 0;

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
    _isHostAvailable.close();
    _hostSpeciality.close();
    _currentIndex.close();
    _data.close();
    // _details.close();
    // _isCustBlocked.close();
    _leaderboardModel.close();
    _waitListModel.close();
    _orderModel.close();
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

  String get liveId => _liveId.value;
  set liveId(String value) => _liveId(value);

  bool get isHost => _isHost.value;
  set isHost(bool value) => _isHost(value);

  bool get isHostAvailable => _isHostAvailable.value;
  set isHostAvailable(bool value) => _isHostAvailable(value);

  String get hostSpeciality => _hostSpeciality.value;
  set hostSpeciality(String value) => _hostSpeciality(value);

  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex(value);

  Map<dynamic, dynamic> get data => _data.value;
  set data(Map<dynamic, dynamic> value) => _data(value);

  // GetAstroDetailsRes get details => _details.value;
  // set details(GetAstroDetailsRes value) => _details(value);

  // IsCustomerBlockedRes get isCustBlocked => _isCustBlocked.value;
  // set isCustBlocked(IsCustomerBlockedRes value) => _isCustBlocked(value);

  List<LeaderboardModel> get leaderboardModel => _leaderboardModel.value;
  set leaderboardModel(List<LeaderboardModel> value) =>
      _leaderboardModel(value);

  List<WaitListModel> get waitListModel => _waitListModel.value;
  set waitListModel(List<WaitListModel> value) => _waitListModel(value);

  WaitListModel get orderModel => _orderModel.value;
  set orderModel(WaitListModel value) => _orderModel(value);

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

  BlockedCustomerListRes get blockedCustomerList => _blockedCustomerList.value;
  set blockedCustomerList(BlockedCustomerListRes value) =>
      _blockedCustomerList(value);

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

  int get testingVar => _testingVar.value;
  set testingVar(int value) => _testingVar(value);

  Future<void> eventListner({
    required DataSnapshot snapshot,
    required Function() zeroAstro,
    required Function(WaitListModel currentCaller) engaging,
    required Function() showFollowPopup,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
    required Function() reInitCoHost,
  }) async {
    final DataSnapshot dataSnapshot = snapshot;
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          data.addAll(map);
          if (data.isEmpty) {
          } else if (data.isNotEmpty) {
            if (data.keys.toList().isEmpty) {
            } else {
              if (data.keys.toList() != null &&
                  data.keys.toList().length > currentIndex) {
                if (data.keys.toList()[currentIndex] != null) {
                  liveId = isHost ? liveId : data.keys.toList()[currentIndex];
                  // isHostAvailable = checkIfAstrologerAvailable(map);

                  var liveIdNode = data[liveId];

                  if (liveIdNode != null) {
                    List<dynamic> blockListNode = liveIdNode["blockList"] ?? [];
                    if (blockListNode.isEmpty) {
                      firebaseBlockUsersIds = [];
                    } else {
                      firebaseBlockUsersIds = blockListNode;
                    }

                    var orderNode = liveIdNode["order"];
                    orderModel = getOrderModel(orderNode);
                    currentCaller =
                        getOrderModelGeneric(orderNode, forMe: false);

                    reInitCoHost();

                    await Future.delayed(const Duration(seconds: 1));

                    engaging(upcomingUser());

                    // String astroIdFromNode = liveId;
                    // String astroIdFromAPIs =
                    //     (details.data?.id ?? "").toString();

                    // if (astroIdFromNode == astroIdFromAPIs) {
                    // } else {
                    //   await getAstrologerDetails(
                    //     successCallBack: successCallBack,
                    //     failureCallBack: failureCallBack,
                    //   );
                    // }

                    showFollowPopup();

                    // if (astroIdFromNode == astroIdFromAPIs) {
                    // } else {
                    //   await isCustomerBlocked(
                    //     successCallBack: successCallBack,
                    //     failureCallBack: failureCallBack,
                    //   );
                    // }
                  } else {}
                } else {}
              } else {}

              update();
            }
          } else {}
        } else {}
      } else {
        data.clear();
        zeroAstro();
      }
    } else {
      data.clear();
    }
    return Future<void>.value();
  }

  // WaitListModel upcomingUser() {
  //   var waitListNode = data[liveId]["waitList"];
  //   final WaitListModel temp = isEngadedNew(waitListNode, forMe: false);
  //   return temp;
  // }

  WaitListModel upcomingUser() {
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
      callStatus: 0,
    );

    var liveIdNode = data[liveId];
    if (liveIdNode != null) {
      var waitListNode = data[liveId]["waitList"];
      temp = isEngadedNew(waitListNode, forMe: false);
    } else {}

    return temp;
  }

  WaitListModel isEngadedNew(
    Map? map, {
    required bool forMe,
  }) {
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

    if (map != null) {
      if (map.isNotEmpty) {
        map.forEach(
          // ignore: always_specify_types
          (key, value) {
            final bool c1 = (value["id"] ?? "") == userId;
            final bool c2 = (value["isEngaded"] ?? false) == true;
            isEngaged = forMe ? c1 && c2 : c2;
            isRequest = value["isRequest"] ?? false;
            callType = value["callType"] ?? "";
            totalTime = value["totalTime"] ?? "";
            avatar = value["avatar"] ?? "";
            userName = value["userName"] ?? "";
            id = value["id"] ?? "";
            generatedOrderId = value["generatedOrderId"] ?? 0;
            offerId = value["offerId"] ?? 0;
            callStatus = value["callStatus"] ?? 0;
          },
        );
      } else {}
    } else {}
    return WaitListModel(
      isRequest: isRequest,
      isEngaded: isEngaged,
      callType: callType,
      totalTime: totalTime,
      avatar: avatar,
      userName: userName,
      id: id,
      generatedOrderId: generatedOrderId,
      offerId: offerId,
      callStatus: callStatus,
    );
  }

  Future<List<dynamic>> onLiveStreamingEnded() async {
    final List<dynamic> liveList = [];
    final DataSnapshot dataSnapshot = await ref.child("live").get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          data.addAll(map);
          liveList.addAll(data.keys.toList());
        } else {}
      } else {}
    } else {}
    return Future<List<dynamic>>.value(liveList);
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
      offerId: 0,
      callStatus: 0,
    );

    if (data.keys.toList() != null &&
        data.keys.toList().length > currentIndex) {
      if (data.keys.toList()[currentIndex] != null) {
        var liveId = data.keys.toList()[currentIndex];
        var liveIdNode = data[liveId];
        if (liveIdNode != null) {
          var orderNode = liveIdNode["order"];
          temp = getOrderModelGeneric(orderNode, forMe: false);
        } else {}
      } else {}
    } else {}

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
    int callStatus = 0;
    if (map != null) {
      if (map.isNotEmpty) {
        isRequest = map["isRequest"] ?? false;
        isEngaged = map["isEngaded"] ?? false;
        callType = map["callType"] ?? "";
        totalTime = map["totalTime"] ?? "";
        avatar = map["avatar"] ?? "";
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
      userName: userName,
      id: id,
      generatedOrderId: generatedOrderId,
      offerId: offerId,
      callStatus: callStatus,
    );
  }

  WaitListModel getOrderModelGeneric(Map? map, {required bool forMe}) {
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
    if (map != null) {
      if (map.isNotEmpty) {
        final bool c1 = (map["id"] ?? "") == userId;
        final bool c2 = (map["isEngaded"] ?? false) == true;
        isEngaged = forMe ? c1 && c2 : c2;
        isRequest = map["isRequest"] ?? false;
        callType = map["callType"] ?? "";
        totalTime = map["totalTime"] ?? "";
        avatar = map["avatar"] ?? "";
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
      userName: userName,
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
      "room_id": liveId,
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

  // Future<void> followOrUnfollowAstrologer({
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "astrologer_id": int.parse(liveId),
  //     "is_follow": details.data?.isFollow == 1 ? 0 : 1,
  //     "role_id": 7,
  //   };
  //   AstrologerFollowingResponse followUnfollow = AstrologerFollowingResponse();
  //   followUnfollow = await liveRepository.astrologerFollowApi(
  //     params: param,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   followRes = followUnfollow.statusCode == HttpStatus.ok
  //       ? AstrologerFollowingResponse.fromJson(followUnfollow.toJson())
  //       : AstrologerFollowingResponse.fromJson(
  //           AstrologerFollowingResponse().toJson(),
  //         );
  //   return Future<void>.value();
  // }

  // Future<bool> hasBalanceForSendingGift({
  //   required int giftId,
  //   required String giftName,
  //   required int giftQuantity,
  //   required int giftAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   final int totalGiftQuantity = giftQuantity;
  //   final int totalGiftAmount = giftQuantity * giftAmount;
  //   await checkWalletRechargeForSendingGift(
  //     giftId: giftId,
  //     giftName: giftName,
  //     totalGiftQuantity: totalGiftQuantity,
  //     totalGiftAmount: totalGiftAmount,
  //     needRecharge: needRecharge,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   final bool value = walletRecharge.statusCode == HttpStatus.ok;
  //   return Future<bool>.value(value);
  // }

  // Future<void> checkWalletRechargeForSendingGift({
  //   required int giftId,
  //   required String giftName,
  //   required int totalGiftQuantity,
  //   required int totalGiftAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "product_id": giftId,
  //     "text": giftName,
  //     "quantity": totalGiftQuantity,
  //     "balance": totalGiftAmount.toString(),
  //     "astrologer_id": liveId,
  //     "type": 2,
  //     "product_type": 2,
  //     "role_id": 7,
  //   };
  //   WalletRecharge walletRechargeRes = WalletRecharge();
  //   walletRechargeRes = await liveRepository.walletRechargeApi(
  //     params: param,
  //     needRecharge: needRecharge,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   walletRecharge = walletRechargeRes.statusCode == HttpStatus.ok
  //       ? WalletRecharge.fromJson(walletRechargeRes.toJson())
  //       : WalletRecharge.fromJson(WalletRecharge().toJson());
  //   return Future<void>.value();
  // }

  // Future<bool> canPlaceLiveOrder({
  //   required String talkType,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   await liveOrderPlace(
  //     talkType: talkType,
  //     needRecharge: needRecharge,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   final bool value = orderGenerate.statusCode == HttpStatus.ok;
  //   return Future<bool>.value(value);
  // }

  // Future<void> liveOrderPlace({
  //   required String talkType,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   final int intValue = talkType == "Video"
  //       ? 3
  //       : talkType == "Audio"
  //           ? 4
  //           : talkType == "Private"
  //               ? 5
  //               : 0;
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "astrologer_id": liveId,
  //     "product_type": intValue,
  //     "role_id": 7,
  //   };
  //   if (details.data?.offerDetails?.offerId != null) {
  //     int offerId = details.data?.offerDetails?.offerId ?? 0;
  //     param.addAll(<String, dynamic>{"offer_id": offerId});
  //   } else {}
  //   OrderGenerate orderGenerateRes = OrderGenerate();
  //   orderGenerateRes = await liveRepository.orderGenerateApi(
  //     params: param,
  //     needRecharge: needRecharge,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   orderGenerate = orderGenerateRes.statusCode == HttpStatus.ok
  //       ? OrderGenerate.fromJson(orderGenerateRes.toJson())
  //       : OrderGenerate.fromJson(OrderGenerate().toJson());
  //   return Future<void>.value();
  // }

  // Future<void> addUpdateLeaderboard({
  //   required num quantity,
  //   required num amount,
  // }) async {
  //   num currentAmount = quantity * amount;
  //   final DataSnapshot dataSnapshot =
  //       await ref.child("live/$liveId/leaderboard/$userId").get();
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         final num previousAmount = map["amount"] ?? 0;
  //         currentAmount = currentAmount + previousAmount;
  //       } else {}
  //     } else {}
  //   } else {}
  //   await ref.child("live/$liveId/leaderboard/$userId").update(
  //     <String, dynamic>{
  //       "amount": currentAmount,
  //       "userName": userName,
  //       "avatar": avatar,
  //       "id": userId,
  //     },
  //   );
  //   return Future<void>.value();
  // }

  void getLatestLeaderboard(DataSnapshot? dataSnapshot) {
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          final List<LeaderboardModel> tempList = <LeaderboardModel>[];
          map.forEach(
            // ignore: always_specify_types
            (key, value) {
              tempList.add(
                LeaderboardModel(
                  // ignore:  avoid_dynamic_calls
                  amount: value["amount"] ?? 0,
                  // ignore:  avoid_dynamic_calls
                  avatar: value["avatar"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  userName: value["userName"] ?? "",
                  // ignore:  avoid_dynamic_calls
                  id: value["id"] ?? "",
                ),
              );
            },
          );
          leaderboardModel = tempList;
          leaderboardModel.sort(
            (LeaderboardModel a, LeaderboardModel b) {
              return b.amount.compareTo(a.amount);
            },
          );
        } else {}
      } else {
        leaderboardModel.clear();
      }
    } else {
      leaderboardModel.clear();
    }
    return;
  }

  Future<void> addUpdateToWaitList({
    required String userId,
    required String callType,
    required bool isEngaded,
    required bool isRequest,
    required int callStatus,
    required bool isForAdd,
  }) async {
    String previousType = callType != "" ? callType : "";
    final DataSnapshot dataSnapshot =
        await ref.child("live/$liveId/waitList/$userId").get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          final String type = map["callType"] ?? "";
          previousType = type;
        } else {}
      } else {}
    } else {}
    //
    final ogOrderDetails = <String, dynamic>{
      "isRequest": isRequest,
      "isEngaded": isEngaded,
      "callType": previousType.toLowerCase(),
      // "totalTime": "2",
      "userName": userName,
      "avatar": avatar,
      "id": userId,
      // "generatedOrderId": (orderGenerate.data?.generatedOrderId ?? 0),
      // "offerId": (details.data?.offerDetails?.offerId ?? 0)
      "callStatus": callStatus,
    };
    final Map<String, dynamic> moOrderDetails = isForAdd
        ? ogOrderDetails
        : <String, dynamic>{
            "callStatus": callStatus,
          };
    //
    await ref.child("live/$liveId/waitList/$userId").update(moOrderDetails);
    //
    if (callStatus == 2) {
      await addUpdateOrder(ogOrderDetails);
      await removeFromWaitList();
    } else {}
    return Future<void>.value();
  }

  Future<void> addUpdateOrder(Map<String, dynamic> orderDetails) async {
    await ref.child("live/$liveId/order").update(orderDetails);
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
          waitListModel = tempList;
        } else {}
      } else {
        waitListModel.clear();
      }
    } else {
      waitListModel.clear();
    }
    return;
  }

  Future<void> removeFromWaitList() async {
    await ref.child("live/$liveId/waitList/$userId").remove();
    return Future<void>.value();
  }

  Future<void> removeFromOrder() async {
    await ref.child("live/$liveId/order").remove();
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

  Future<void> updateHostAvailability() async {
    Map<String, dynamic> temp = <String, dynamic>{};
    final DataSnapshot dataSnapshot = await ref.child("live/$liveId").get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          temp = Map<String, dynamic>.from(map);
        } else {}
      } else {}
    } else {}
    temp["isAvailable"] = isHostAvailable;
    await ref.child("live/$liveId").update(temp);
    return Future<void>.value();
  }

  // bool hasMyIdInWaitList() {
  //   List<WaitListModel> tempList = <WaitListModel>[];
  //   tempList = waitListModel.where(
  //     (WaitListModel element) {
  //       return element.id == userId;
  //     },
  //   ).toList();
  //   return tempList.isNotEmpty;
  // }

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
    blockedCustomerList.data?.forEach(
      (element) {
        temp.add((element.customerId ?? 0).toString());
      },
    );
    await ref.child("live/$liveId").update(
      <String, Object?>{"blockList": temp ?? []},
    );
    return Future<void>.value();
  }

  // Future<void> deleteFromBlockList({required String userId}) async {
  //   List<dynamic> blockList = <dynamic>[];
  //   final DataSnapshot dataSnapshot =
  //       await ref.child("live/$liveId/blockList").get();
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is List<dynamic>) {
  //         List<dynamic> list = <dynamic>[];
  //         list = (dataSnapshot.value ?? <dynamic, dynamic>{}) as List<dynamic>;
  //         if (list.contains(userId)) {
  //           list = list.where((dynamic element) => element != userId).toList();
  //         } else {}
  //         blockList = list ?? <dynamic>[];
  //         await ref.child("live/$liveId").update(
  //           <String, Object?>{"blockList": blockList ?? <dynamic>[]},
  //         );
  //       } else {}
  //     } else {
  //       await ref.child("live/$liveId").update(
  //         <String, Object?>{"blockList": <dynamic>[]},
  //       );
  //     }
  //   } else {}
  //   return Future<void>.value();
  // }

  // Future<void> makeAPICallForStartCall({
  //   required bool hasAccepted,
  //   required Function(String message) successCallBack,
  //   required Function(String message) failureCallBack,
  // }) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "order_id": (orderGenerate.data?.generatedOrderId ?? 0).toString(),
  //     "type": hasAccepted ? 1 : 0,
  //   };
  //   await liveRepository.startLiveApi(
  //     params: param,
  //     successCallBack: successCallBack,
  //     failureCallBack: failureCallBack,
  //   );
  //   return Future<void>.value();
  // }

  Future<void> makeAPICallForEndCall({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    bool isExist = false;
    final String path = "live/$liveId/order";
    final DataSnapshot dataSnapshot = await ref.child(path).get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          final String userId = map["id"] ?? "";
          isExist = currentCaller.id == userId;
        } else {}
      } else {}
    } else {}
    if (isExist) {
      Map<String, dynamic> param = <String, dynamic>{};
      param = <String, dynamic>{
        "order_id": getOrderId(),
        "duration": "0",
        "amount": "0.0",
        "role_id": 7,
      };
      final int offerId = getOfferId();
      param.addAll(<String, dynamic>{"offer_id": offerId});
      await liveRepository.endLiveApi(
        params: param,
        successCallBack: successCallBack,
        failureCallBack: failureCallBack,
      );
    } else {}
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
      temp = orderModel.generatedOrderId;
      return temp.toString();
    }
  }

  int getOfferId() {
    // int temp = details.data?.offerDetails?.offerId ?? 0;
    int temp = 0;
    if (temp != 0) {
      return temp;
    } else {
      temp = orderModel.offerId;
      return temp;
    }
  }

  Future<void> removeMyNode() async {
    await ref.child("live/$liveId").remove();
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
    blockedCustomerList = blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerListRes.fromJson(blockedCustListRes.toJson())
        : BlockedCustomerListRes.fromJson(BlockedCustomerListRes().toJson());
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
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    blockedCustListRes = blockedCustListRes.statusCode == HttpStatus.ok
        ? BlockedCustomerRes.fromJson(blockedCustListRes.toJson())
        : BlockedCustomerRes.fromJson(BlockedCustomerRes().toJson());
    await callBlockedCustomerListRes(
      successCallBack: successCallBack,
      failureCallBack: failureCallBack,
    );
    await addUpdateToBlockList();
    return Future<void>.value();
  }

  bool isBlocked({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerList.data?.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0) == 1;
  }

  int getBlockedInInt({required int id}) {
    BlockedCustomerListResData? data = blockedCustomerList.data?.firstWhere(
      (element) => (element.getCustomers?.id ?? 0) == id,
      orElse: () => BlockedCustomerListResData(),
    );
    return (data?.isBlock ?? 0);
  }

  Future<bool> shouldOpenBottom() async {
    bool isRequest = false;
    final DataSnapshot dataSnapshot =
        await ref.child("live/$liveId/waitList/$userId").get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          isRequest = map["isRequest"] ?? false;
        } else {}
      } else {}
    } else {}
    return Future<bool>.value(isRequest);
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
    for (var badWord in LiveSharedPreferencesSingleton().getBadWordsList()) {
      if (input.toLowerCase().contains(badWord.toLowerCase())) {
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
  final int callStatus;
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
