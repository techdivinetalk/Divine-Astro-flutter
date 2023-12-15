// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison

import "dart:async";

import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/res_login.dart";
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

class LiveDharamController extends GetxController {
  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  // final AstrologerProfileRepository liveRepository =
  //     AstrologerProfileRepository();

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
  // final Rx<GiftResponse> _gifts = GiftResponse().obs;
  final RxList<CustomGiftModel> _customGiftModel = <CustomGiftModel>[].obs;
  final RxList<LeaderboardModel> _leaderboardModel = <LeaderboardModel>[].obs;
  final RxList<WaitListModel> _waitListModel = <WaitListModel>[].obs;
  // final Rx<AstrologerFollowingResponse> _followRes =
  //     AstrologerFollowingResponse().obs;

  @override
  void onInit() {
    super.onInit();

    userId = (_pref.getUserDetail()?.id ?? "").toString();
    userName = _pref.getUserDetail()?.name ?? "";
    // avatar = _pref.getUserDetail()?.avatar ?? "";
    avatar = isValidImageURL(imageURL: _pref.getUserDetail()?.image ?? "");
    //
    liveId = (Get.arguments ?? "").toString();
    isHost = true;
    isHostAvailable = true;
    hostSpeciality = getSpeciality();
    currentIndex = 0;
    data = <dynamic, dynamic>{};
    // details = GetAstroDetailsRes();
    // gifts = GiftResponse();
    customGiftModel = <CustomGiftModel>[];
    leaderboardModel = <LeaderboardModel>[];
    waitListModel = <WaitListModel>[];
    // followRes = AstrologerFollowingResponse();
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
    // _gifts.close();
    _customGiftModel.close();
    _leaderboardModel.close();
    _waitListModel.close();
    // _followRes.close();

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

  // GiftResponse get gifts => _gifts.value;
  // set gifts(GiftResponse value) => _gifts(value);

  List<CustomGiftModel> get customGiftModel => _customGiftModel.value;
  set customGiftModel(List<CustomGiftModel> value) => _customGiftModel(value);

  List<LeaderboardModel> get leaderboardModel => _leaderboardModel.value;
  set leaderboardModel(List<LeaderboardModel> value) =>
      _leaderboardModel(value);

  List<WaitListModel> get waitListModel => _waitListModel.value;
  set waitListModel(List<WaitListModel> value) => _waitListModel(value);

  // AstrologerFollowingResponse get followRes => _followRes.value;
  // set followRes(AstrologerFollowingResponse value) => _followRes(value);

  // Future<void> eventListner(DatabaseEvent event) async {
  //   final DataSnapshot dataSnapshot = event.snapshot;
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         data.addAll(map);
  //         if (data.isEmpty) {
  //         } else if (data.isNotEmpty) {
  //           liveId = data.keys.toList()[currentIndex];
  //           isHostAvailable = checkIfAstrologerAvailable(map);
  //           await getAstrologerDetails();
  //         } else {}
  //       } else {}
  //     } else {
  //       data.clear();
  //     }
  //   } else {
  //     data.clear();
  //   }
  //   return Future<void>.value();
  // }

  // bool checkIfAstrologerAvailable(Map<dynamic, dynamic> map) {
  //   final currentHostId = map[liveId];
  //   final isAvailable = currentHostId["isAvailable"] ?? false;
  //   return isAvailable;
  // }

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

  // Future<void> getAllGifts() async {
  //   GiftResponse giftResponse = GiftResponse();
  //   giftResponse = await liveRepository.getAllGiftsAPI();
  //   gifts = giftResponse.statusCode == HttpStatus.ok
  //       ? GiftResponse.fromJson(giftResponse.toJson())
  //       : GiftResponse.fromJson(GiftResponse().toJson());

  //   for (int i = 0; i < (gifts.data?.length ?? 0); i++) {
  //     gifts.data?[i].giftImage =
  //         isValidImageURL(imageURL: gifts.data?[i].giftImage ?? "");
  //   }
  //   return Future<void>.value();
  // }

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
  //       : AstrologerFollowingResponse.fromJson(GetAstroDetailsRes().toJson());
  //   return Future<void>.value();
  // }

  // void mapAndMergeGiftsWithConstant() {
  //   final List<CustomGiftModel> temp = <CustomGiftModel>[];
  //   gifts.data?.forEach(
  //     (GiftData element) {
  //       final String id = globalConstantModel.data?.lottiFile?.keys.firstWhere(
  //             (String e) => e == element.id.toString(),
  //             orElse: () => "",
  //           ) ??
  //           "";
  //       final String giftSvga = globalConstantModel.data?.lottiFile?[id] ?? "";
  //       final CustomGiftModel customGiftModel = CustomGiftModel(
  //         giftId: element.id,
  //         giftName: element.giftName,
  //         giftImage: element.giftImage,
  //         giftPrice: element.giftPrice,
  //         giftSvga: giftSvga,
  //       );
  //       temp.add(customGiftModel);
  //     },
  //   );
  //   customGiftModel = temp;
  //   return;
  // }

  // bool hasBalance({required num quantity, required num amount}) {
  //   final num myCurrentBalance = num.parse(walletBalance.value.toString());
  //   final num myPurchasedOrder = quantity * amount;
  //   return myCurrentBalance >= myPurchasedOrder;
  // }

  // Future<void> addUpdateLeaderboard({
  //   required num quantity,
  //   required num amount,
  // }) async {
  //   num currentAmount = amount;
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
  // }) async {
  //   await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/waitList/$userId")
  //       .update(
  //     <String, dynamic>{
  //       "callType": callType.toLowerCase(),
  //       "totalTime": intToTimeLeft(walletBalance.value),
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

  // Future<void> removeFromWaitList() async {
  //   await FirebaseDatabase.instance
  //       .ref()
  //       .child("live/$liveId/waitList/$userId")
  //       .remove();
  //   return Future<void>.value();
  // }

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
  //   tempList = waitListModel.where((element) => element.id == userId).toList();
  //   return tempList.isNotEmpty;
  // }

  // String intToTimeLeft(int value) {
  //   int h, m, s;
  //   h = value ~/ 3600;
  //   m = ((value - h * 3600)) ~/ 60;
  //   s = value - (h * 3600) - (m * 60);
  //   String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();
  //   String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  //   String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();
  //   String result = "$hourLeft:$minuteLeft:$secondsLeft";
  //   return result;
  // }

  String getTotalWaitTime() {
    String time = "";
    List<String> tempList = <String>[];
    for (var element in waitListModel) {
      tempList.add(element.totalTime);
    }
    if (tempList.isEmpty) {
      time = "Wait time: 00:00:00";
    } else {
      List<Duration> durations = tempList.map((t) => parseTime(t)).toList();
      Duration totalTime = durations.reduce((a, b) => a + b);
      final String hh = "${totalTime.inHours}";
      final String mm = (totalTime.inMinutes % 60).toString().padLeft(2, '0');
      final String ss = (totalTime.inSeconds % 60).toString().padLeft(2, '0');
      time = "Wait time: $hh:$mm:$ss";
    }
    return time;
  }

  Duration parseTime(String timeString) {
    List<int> parts = timeString.split(':').map(int.parse).toList();
    return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
  }
}

class CustomGiftModel {
  CustomGiftModel({
    required this.giftId,
    required this.giftName,
    required this.giftImage,
    required this.giftPrice,
    required this.giftSvga,
  });

  final int giftId;
  final String giftName;
  final String giftImage;
  final int giftPrice;
  final String giftSvga;
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
    required this.callType,
    required this.totalTime,
    required this.avatar,
    required this.userName,
    required this.id,
  });

  final String callType;
  final String totalTime;
  final String avatar;
  final String userName;
  final String id;
}
