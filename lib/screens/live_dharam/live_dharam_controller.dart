// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, lines_longer_than_80_chars

import "dart:async";

import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/res_login.dart";
import "package:divine_astrologer/repository/astrologer_profile_repository.dart";
import "package:firebase_database/firebase_database.dart";
import "package:get/get.dart";
//
//
//
//
//
//
//
//
//

class LiveDharamController extends GetxController {
  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  final AstrologerProfileRepository liveRepository =
      AstrologerProfileRepository();

  final RxString _userId = "".obs;
  final RxString _userName = "".obs;
  final RxString _avatar = "".obs;
  final RxString _liveId = "".obs;
  final RxBool _isHost = true.obs;
  final RxBool _isHostAvailable = true.obs;
  final RxString _hostSpeciality = "".obs;
  final RxInt _currentIndex = 0.obs;
  final RxMap<dynamic, dynamic> _data = <dynamic, dynamic>{}.obs;
  // final Rx<GetAstroDetailsRes> _details = GetAstroDetailsRes().obs;
  final RxList<LeaderboardModel> _leaderboardModel = <LeaderboardModel>[].obs;
  final RxList<WaitListModel> _waitListModel = <WaitListModel>[].obs;
  // final Rx<AstrologerFollowingResponse> _followRes =
  //     AstrologerFollowingResponse().obs;
  // final Rx<WalletRecharge> _walletRecharge = WalletRecharge().obs;
  // final Rx<OrderGenerate> _orderGenerate = OrderGenerate().obs;
  final RxBool _isFront = true.obs;
  final RxBool _isCamOn = true.obs;
  final RxBool _isMicOn = true.obs;
  final RxBool _amIBlocked = false.obs;
  final Rx<WaitListModel> _currentCaller = WaitListModel(
    isEngaded: false,
    callType: "callType",
    totalTime: "",
    avatar: "",
    userName: "",
    id: "",
  ).obs;
  final RxBool _showTopBanner = false.obs;
  // final Rx<InsufficientBalModel> _insufficientBalModel =
  //     InsufficientBalModel().obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    userId = (_pref.getUserDetail()?.id ?? "").toString();
    userName = _pref.getUserDetail()?.name ?? "";
    // avatar = _pref.getUserDetail()?.avatar ?? "";
    final String awsURL = _pref.getAmazonUrl() ?? "";
    final String image = _pref.getUserDetail()?.image ?? "";
    avatar = isValidImageURL(imageURL: "$awsURL/$image");
    liveId = (Get.arguments ?? "").toString();
    isHost = true;
    isHostAvailable = true;
    hostSpeciality = getSpeciality();
    currentIndex = 0;
    data = <dynamic, dynamic>{};
    // details = GetAstroDetailsRes();
    leaderboardModel = <LeaderboardModel>[];
    waitListModel = <WaitListModel>[];
    // followRes = AstrologerFollowingResponse();
    // walletRecharge = WalletRecharge();
    // orderGenerate = OrderGenerate();
    isFront = true;
    isCamOn = true;
    isMicOn = true;
    amIBlocked = false;
    currentCaller = WaitListModel(
      isEngaded: false,
      callType: "callType",
      totalTime: "",
      avatar: "",
      userName: "",
      id: "",
    );
    showTopBanner = false;
    // insufficientBalModel = InsufficientBalModel();
    return;
  }

  @override
  void onClose() {
    _userId.close();
    _userName.close();
    _avatar.close();
    _liveId.close();
    _isHost.close();
    _isHostAvailable.close();
    _hostSpeciality.close();
    _currentIndex.close();
    _data.close();
    // _details.close();
    _leaderboardModel.close();
    _waitListModel.close();
    // _followRes.close();
    // _walletRecharge.close();
    // _orderGenerate.close();
    _isFront.close();
    _isCamOn.close();
    _isMicOn.close();
    _amIBlocked.close();
    _currentCaller.close();
    _showTopBanner.close();
    // _insufficientBalModel.close();

    super.onClose();
  }

  String get userId => _userId.value;
  set userId(String value) => _userId(value);

  String get userName => _userName.value;
  set userName(String value) => _userName(value);

  String get avatar => _avatar.value;
  set avatar(String value) => _avatar(value);

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

  List<LeaderboardModel> get leaderboardModel => _leaderboardModel.value;
  set leaderboardModel(List<LeaderboardModel> value) =>
      _leaderboardModel(value);

  List<WaitListModel> get waitListModel => _waitListModel.value;
  set waitListModel(List<WaitListModel> value) => _waitListModel(value);

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

  bool get amIBlocked => _amIBlocked.value;
  set amIBlocked(bool value) => _amIBlocked(value);

  WaitListModel get currentCaller => _currentCaller.value;
  set currentCaller(WaitListModel value) => _currentCaller(value);

  bool get showTopBanner => _showTopBanner.value;
  set showTopBanner(bool value) => _showTopBanner(value);

  // InsufficientBalModel get insufficientBalModel => _insufficientBalModel.value;
  // set insufficientBalModel(InsufficientBalModel value) =>
  //     _insufficientBalModel(value);

  Future<void> eventListner({
    required DatabaseEvent event,
    required Function() zeroAstro,
    required Function(WaitListModel currentCaller) engaging,
  }) async {
    final DataSnapshot dataSnapshot = event.snapshot;
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          data.addAll(map);
          if (data.isEmpty) {
          } else if (data.isNotEmpty) {
            liveId = data.keys.toList()[currentIndex];
            isHostAvailable = checkIfAstrologerAvailable(map);
            amIBlocked = checkIfAstrologerBlockedMe(map);
            var liveIdNode = data[liveId];
            var waitListNode = liveIdNode["waitList"];
            currentCaller = isEngadedNew(waitListNode, isForMe: false);

            await Future.delayed(const Duration(seconds: 1));
            
            final bool condition1 = isHost;
            final bool condition2 = waitListModel.length == 1;
            final bool condition3 = currentCaller.id.isNotEmpty;
            final bool condition4 = !currentCaller.isEngaded;

            if (condition1 && condition2 && condition3 && condition4) {
              engaging(currentCaller);
            } else {}

            // await getAstrologerDetails();
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

  WaitListModel engagedCoHostWithAstro() {
    var liveId = data.keys.toList()[currentIndex];
    var liveIdNode = data[liveId];
    var waitListNode = liveIdNode["waitList"];
    return isEngadedNew(waitListNode, isForMe: false);
  }

  WaitListModel isEngadedNew(
    Map? map, {
    required bool isForMe,
  }) {
    bool isEngaged = false;
    String callType = "";
    String totalTime = "";
    String avatar = "";
    String userName = "";
    String id = "";
    if (map != null) {
      if (map.isNotEmpty) {
        map.forEach(
          // ignore: always_specify_types
          (key, value) {
            final bool c1 = (value["id"] ?? "") == userId;
            final bool c2 = (value["isEngaded"] ?? false) == true;
            isEngaged = isForMe ? c1 && c2 : c2;
            callType = value["callType"] ?? "";
            totalTime = value["totalTime"] ?? "";
            avatar = value["avatar"] ?? "";
            userName = value["userName"] ?? "";
            id = value["id"] ?? "";
          },
        );
      } else {}
    } else {}
    return WaitListModel(
      isEngaded: isEngaged,
      callType: callType,
      totalTime: totalTime,
      avatar: avatar,
      userName: userName,
      id: id,
    );
  }

  bool checkIfAstrologerAvailable(Map<dynamic, dynamic> map) {
    final Map<dynamic, dynamic> currentHostId = map[liveId];
    final bool isAvailable = currentHostId["isAvailable"] ?? false;
    return isAvailable;
  }

  // String requirePreviousLiveID() {
  //   currentIndex = currentIndex - 1;
  //   if (currentIndex < 0) {
  //     currentIndex = data.keys.toList().length - 1;
  //   } else {}
  //   liveId = data.keys.toList()[currentIndex];
  //   unawaited(getAstrologerDetails());
  //   return liveId;
  // }

  // String requireNextLiveID() {
  //   currentIndex = currentIndex + 1;
  //   if (currentIndex > data.keys.toList().length - 1) {
  //     currentIndex = 0;
  //   } else {}
  //   liveId = data.keys.toList()[currentIndex];
  //   unawaited(getAstrologerDetails());
  //   return liveId;
  // }

  // Map<String, dynamic> createGift({required num count, required String svga}) {
  //   final String accessToken = preferenceService.getToken() ?? "";
  //   return <String, dynamic>{
  //     "app_id": appID,
  //     "server_secret": serverSecret,
  //     "room_id": liveId,
  //     "user_id": userId,
  //     "user_name": userName,
  //     "gift_type": svga,
  //     "gift_count": count,
  //     "access_token": accessToken,
  //     "timestamp": DateTime.now().millisecondsSinceEpoch,
  //   };
  // }

  // Future<void> sendGiftAPI({
  //   required num count,
  //   required String svga,
  //   required void Function(String message) successCallback,
  //   required void Function(String message) failureCallback,
  // }) async {
  //   try {
  //     const String url = "https://zego-virtual-gift.vercel.app/api/send_gift";
  //     final http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{"Content-Type": "application/json"},
  //       body: jsonEncode(
  //         createGift(count: count, svga: svga),
  //       ),
  //     );
  //     response.statusCode == HttpStatus.ok
  //         ? successCallback("Yay!")
  //         : failureCallback("[ERROR], Send Gift Fail: ${response.statusCode}");
  //   } on Exception catch (error) {
  //     failureCallback("[ERROR], Send Gift Fail, $error");
  //   }
  //   return Future<void>.value();
  // }

  // Future<void> getAstrologerDetails() async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{"astrologer_id": liveId};
  //   GetAstroDetailsRes getAstroDetailsRes = GetAstroDetailsRes();
  //   getAstroDetailsRes = await liveRepository.getAstroDetailsAPI(params: param);
  //   details = getAstroDetailsRes.statusCode == HttpStatus.ok
  //       ? GetAstroDetailsRes.fromJson(getAstroDetailsRes.toJson())
  //       : GetAstroDetailsRes.fromJson(GetAstroDetailsRes().toJson());

  //   details.data?.image = isValidImageURL(imageURL: details.data?.image ?? "");
  //   details.data?.speciality = getSpeciality();

  //   return Future<void>.value();
  // }

  String getSpeciality() {
    final List<String> pivotList = <String>[];
    _pref.getUserDetail()?.astroCatPivot?.forEach(
          (AstroCatPivot e) => pivotList.add(e.categoryDetails?.name ?? ""),
        );
    return pivotList.join(", ");
  }

  // Future<void> followOrUnfollowAstrologer() async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "astrologer_id": liveId,
  //     "is_follow": details.data?.isFollow == 1 ? 0 : 1,
  //     "role_id": _pref.getUserDetail()?.roleId ?? "",
  //   };
  //   AstrologerFollowingResponse followUnfollow = AstrologerFollowingResponse();
  //   followUnfollow = await liveRepository.astrologerFollowApi(params: param);
  //   followRes = followUnfollow.statusCode == HttpStatus.ok
  //       ? AstrologerFollowingResponse.fromJson(followUnfollow.toJson())
  //       : AstrologerFollowingResponse.fromJson(
  //           AstrologerFollowingResponse().toJson(),
  //         );
  //   return Future<void>.value();
  // }

  // bool hasBalance({required num quantity, required num amount}) {
  //   // final num myCurrentBalance = num.parse(walletBalance.value.toString());
  //   // final num myPurchasedOrder = quantity * amount;
  //   // print("hasBalance: start  ----------");
  //   // print("hasBalance: myCurrentBalance: $myCurrentBalance");
  //   // print("hasBalance: myPurchasedOrder: $myPurchasedOrder");
  //   // print("hasBalance: result: ${myCurrentBalance >= myPurchasedOrder}");
  //   // print("hasBalance: end  ----------");
  //   // return myCurrentBalance >= myPurchasedOrder;
  //   return true;
  // }

  // Future<bool> hasBalanceForSendingGift({
  //   required int giftId,
  //   required String giftName,
  //   required int giftQuantity,
  //   required int giftAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  // }) async {
  //   bool hasBal = hasBalance(quantity: giftQuantity, amount: giftAmount);
  //   if (hasBal) {
  //     final int totalGiftQuantity = giftQuantity;
  //     final int totalGiftAmount = giftQuantity * giftAmount;
  //     await checkWalletRechargeForSendingGift(
  //       giftId: giftId,
  //       giftName: giftName,
  //       totalGiftQuantity: totalGiftQuantity,
  //       totalGiftAmount: totalGiftAmount,
  //       needRecharge: needRecharge,
  //     );
  //     final bool value = walletRecharge.statusCode == HttpStatus.ok;
  //     return Future<bool>.value(value);
  //   } else {
  //     return Future<bool>.value(false);
  //   }
  // }

  // Future<void> checkWalletRechargeForSendingGift({
  //   required int giftId,
  //   required String giftName,
  //   required int totalGiftQuantity,
  //   required int totalGiftAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  // }) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     // Gift ID
  //     "product_id": giftId,
  //     // Gift Name
  //     "text": giftName,
  //     // Total Gift Quantity
  //     "quantity": totalGiftQuantity,
  //     // Total Gift Amount
  //     "balance": totalGiftAmount.toString(),
  //     // Current Astrologer ID
  //     "astrologer_id": liveId,
  //     // Debit Amount
  //     "type": 2,
  //     // Constant 2 for Gift Sending
  //     "product_type": 2,
  //     // Constant role ID
  //     "role_id": 7,
  //   };
  //   WalletRecharge walletRechargeRes = WalletRecharge();
  //   walletRechargeRes = await liveRepository.walletRechargeApi(
  //     params: param,
  //     needRecharge: needRecharge,
  //   );
  //   walletRecharge = walletRechargeRes.statusCode == HttpStatus.ok
  //       ? WalletRecharge.fromJson(walletRechargeRes.toJson())
  //       : WalletRecharge.fromJson(WalletRecharge().toJson());
  //   return Future<void>.value();
  // }

  // Future<bool> canPlaceLiveOrder({
  //   required String talkType,
  //   required int talkAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
  // }) async {
  //   bool hasBal = hasBalance(quantity: 1, amount: talkAmount);
  //   if (hasBal) {
  //     await liveOrderPlace(
  //       talkType: talkType,
  //       talkAmount: talkAmount,
  //       needRecharge: needRecharge,
  //     );
  //     final bool value = orderGenerate.statusCode == HttpStatus.ok;
  //     return Future<bool>.value(value);
  //   } else {
  //     return Future<bool>.value(false);
  //   }
  // }

  // Future<void> liveOrderPlace({
  //   required String talkType,
  //   required int talkAmount,
  //   required Function(InsufficientBalModel balModel) needRecharge,
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
  //   OrderGenerate orderGenerateRes = OrderGenerate();
  //   orderGenerateRes = await liveRepository.orderGenerateApi(
  //     params: param,
  //     needRecharge: needRecharge,
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
  //   final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/leaderboard/$userId")
  //       .get();
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         final num previousAmount = map["amount"];
  //         currentAmount = currentAmount + previousAmount;
  //       } else {}
  //     } else {}
  //   } else {}
  //   await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/leaderboard/$userId")
  //       .update(
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

  // Future<void> addUpdateToWaitList({
  //   required String callType,
  //   required bool isEngaded,
  // }) async {
  //   String previousType = callType != "" ? callType : "";
  //   final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/waitList/$userId")
  //       .get();
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         final String type = map["callType"];
  //         previousType = type;
  //       } else {}
  //     } else {}
  //   } else {}
  //   await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/waitList/$userId")
  //       .update(
  //     <String, dynamic>{
  //       "isEngaded": isEngaded,
  //       "callType": previousType.toLowerCase(),
  //       // "totalTime": intToTimeLeft(walletBalance.value),
  //       "totalTime": (orderGenerate.data?.talktime ?? '0').toString(),
  //       "userName": userName,
  //       "avatar": avatar,
  //       "id": userId,
  //     },
  //   );
  //   return Future<void>.value();
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
    await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/waitList/$userId")
        .remove();
    return Future<void>.value();
  }

  Future<void> removeFromWaitListWhereEngadedIsTrue() async {
    List<WaitListModel> temp = <WaitListModel>[];
    temp = waitListModel.where(
      (WaitListModel e) {
        return e.isEngaded == true;
      },
    ).toList();
    if (temp.isEmpty) {
    } else {
      final String userId = temp.first.id;
      await FirebaseDatabase.instance
          .ref()
          .child("live/$liveId/waitList/$userId")
          .remove();
    }
    return Future<void>.value();
  }

  String isValidImageURL({required String imageURL}) {
    if (GetUtils.isURL(imageURL)) {
      return imageURL;
    } else {
      imageURL = "${_pref.getAmazonUrl()}$imageURL";
      if (GetUtils.isURL(imageURL)) {
        return imageURL;
      } else {
        return "https://robohash.org/details";
      }
    }
  }

  Future<void> updateHostAvailability() async {
    Map<String, dynamic> temp = <String, dynamic>{};
    final DataSnapshot dataSnapshot =
        await FirebaseDatabase.instance.ref().child("live/$liveId").get();
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
    await FirebaseDatabase.instance.ref().child("live/$liveId").update(temp);
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

  // String intToTimeLeft(int value) {
  //   int h;
  //   int m;
  //   int s;
  //   h = value ~/ 3600;
  //   m = (value - h * 3600) ~/ 60;
  //   s = value - (h * 3600) - (m * 60);
  //   final String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();
  //   final String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  //   final String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();
  //   return "$hourLeft:$minuteLeft:$secondsLeft";
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
      print("Total time: $formattedTime");
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
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  Future<void> addUpdateToBlockList({required String userId}) async {
    List<dynamic> blockList = <dynamic>[];
    final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/blockList")
        .get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is List<dynamic>) {
          List<dynamic> list = <dynamic>[];
          list = (dataSnapshot.value ?? <dynamic, dynamic>{}) as List<dynamic>;
          if (list.contains(userId)) {
          } else {
            list = <dynamic>[
              ...list,
              ...<dynamic>[userId],
            ];
          }
          blockList = list;
          await FirebaseDatabase.instance.ref().child("live/$liveId").update(
            <String, Object?>{"blockList": blockList},
          );
        } else {}
      } else {
        await FirebaseDatabase.instance.ref().child("live/$liveId").update(
          <String, Object?>{
            "blockList": <dynamic>[userId],
          },
        );
      }
    } else {}
    return Future<void>.value();
  }

  Future<void> deleteFromBlockList({required String userId}) async {
    List<dynamic> blockList = <dynamic>[];
    final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/blockList")
        .get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is List<dynamic>) {
          List<dynamic> list = <dynamic>[];
          list = (dataSnapshot.value ?? <dynamic, dynamic>{}) as List<dynamic>;
          if (list.contains(userId)) {
            list = list.where((dynamic element) => element != userId).toList();
          } else {}
          blockList = list;
          await FirebaseDatabase.instance.ref().child("live/$liveId").update(
            <String, Object?>{"blockList": blockList},
          );
        } else {}
      } else {
        await FirebaseDatabase.instance.ref().child("live/$liveId").update(
          <String, Object?>{
            "blockList": <dynamic>[],
          },
        );
      }
    } else {}
    return Future<void>.value();
  }

  bool checkIfAstrologerBlockedMe(map) {
    final Map<dynamic, dynamic> currentHostId = map[liveId];
    final List<dynamic> list =
        (currentHostId["blockList"] ?? <dynamic>[]) ?? <dynamic>[];
    return list.contains(userId);
  }

  // Future<void> makeAPICallForStartCall({required bool hasAccepted}) async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "order_id": (orderGenerate.data?.generatedOrderId ?? 0).toString(),
  //     "type": hasAccepted ? 1 : 0, //0 reject, 1 accept
  //   };
  //   await liveRepository.startLiveApi(params: param);
  //   return Future<void>.value();
  // }

  // Future<void> makeAPICallForEndCall() async {
  //   Map<String, dynamic> param = <String, dynamic>{};
  //   param = <String, dynamic>{
  //     "order_id": (orderGenerate.data?.generatedOrderId ?? 0).toString(),
  //     "duration": "0",
  //     "amount": "0.0",
  //     "offer_id": "0",
  //     "role_id": "7",
  //   };
  //   await liveRepository.endLiveApi(params: param);
  //   return Future<void>.value();
  // }

  Future<void> leaderboardChallengeCallback({
    required Function(LeaderboardModel leader) onLeaderUpdated,
  }) async {
    final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/leaderboard")
        .get();
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
          tempList.sort(
            (LeaderboardModel a, LeaderboardModel b) {
              return b.amount.compareTo(a.amount);
            },
          );
          if (tempList.isEmpty) {
          } else {
            onLeaderUpdated(tempList.first);
          }
        } else {}
      } else {}
    } else {}
  }

  Future<void> removeMyNode() async {
    await FirebaseDatabase.instance.ref().child("live/$liveId").remove();
    return Future<void>.value();
  }
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
    required this.isEngaded,
    required this.callType,
    required this.totalTime,
    required this.avatar,
    required this.userName,
    required this.id,
  });

  final bool isEngaded;
  final String callType;
  final String totalTime;
  final String avatar;
  final String userName;
  final String id;
}

class ZegoCustomMessage {
  int? type;
  String? liveId;
  String? userId;
  String? userName;
  String? avatar;
  String? message;
  String? timeStamp;
  String? fullGiftImage;

  ZegoCustomMessage(
      {this.type,
      this.liveId,
      this.userId,
      this.userName,
      this.avatar,
      this.message,
      this.timeStamp,
      this.fullGiftImage});

  ZegoCustomMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    liveId = json['liveId'];
    userId = json['userId'];
    userName = json['userName'];
    avatar = json['avatar'];
    message = json['message'];
    timeStamp = json['timeStamp'];
    fullGiftImage = json['fullGiftImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['liveId'] = this.liveId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['avatar'] = this.avatar;
    data['message'] = this.message;
    data['timeStamp'] = this.timeStamp;
    data['fullGiftImage'] = this.fullGiftImage;
    return data;
  }
}
