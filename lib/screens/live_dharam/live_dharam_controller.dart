// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison

import "dart:async";
// import "dart:convert";

import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
// import "package:divine_astrologer/model/astrologer_profile/astrologer_gift_response.dart";
// import "package:divine_astrologer/model/live/get_astrologer_details_response.dart";
// import "package:divine_astrologer/repository/astrologer_profile_repository.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart";
import "package:firebase_database/firebase_database.dart";
import "package:get/get.dart";
// import "package:http/http.dart" as http;

class LiveDharamController extends GetxController {
  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  // final AstrologerProfileRepository liveRepository =
  //     AstrologerProfileRepository();

  final RxString _userId = "".obs;
  final RxString _userName = "".obs;
  final RxString _avatar = "".obs;
  final RxString _liveId = "".obs;
  final RxBool _isHost = true.obs;
  final RxInt _currentIndex = 0.obs;
  final RxBool _isInitialSetup = true.obs;
  final RxMap<dynamic, dynamic> _data = <dynamic, dynamic>{}.obs;
  // final Rx<GetAstroDetailsRes> _details = GetAstroDetailsRes().obs;
  // final Rx<GiftResponse> _gifts = GiftResponse().obs;
  final RxList<CustomGiftModel> _customGiftModel = <CustomGiftModel>[].obs;
  final RxList<LeaderboardModel> _leaderboardModel = <LeaderboardModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    userId = (_pref.getUserDetail()?.id ?? "").toString();
    userName = _pref.getUserDetail()?.name ?? "";
    avatar = _pref.getUserDetail()?.image ?? "";
    liveId = (Get.arguments ?? "").toString();
    isHost = true;
    currentIndex = 0;
    isInitialSetup = true;
    data = <dynamic, dynamic>{};
    // details = GetAstroDetailsRes();
    // gifts = GiftResponse();
    customGiftModel = <CustomGiftModel>[];
    leaderboardModel = <LeaderboardModel>[];
  }

  @override
  void onClose() {
    _userId.close();
    _userName.close();
    _avatar.close();
    _liveId.close();
    _isHost.close();
    _currentIndex.close();
    _isInitialSetup.close();
    _data.close();
    // _details.close();
    // _gifts.close();
    _customGiftModel.close();
    _leaderboardModel.close();

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

  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex(value);

  bool get isInitialSetup => _isInitialSetup.value;
  set isInitialSetup(bool value) => _isInitialSetup(value);

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
  //           if (isInitialSetup) {
  //             liveId = data.keys.toList()[currentIndex];
  //             await getAstrologerDetails();
  //             isInitialSetup = false;
  //           } else {}
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

  String requirePreviousLiveID() {
    // currentIndex = currentIndex - 1;
    // if (currentIndex < 0) {
    //   currentIndex = data.keys.toList().length - 1;
    // } else {}
    // liveId = data.keys.toList()[currentIndex];
    // unawaited(getAstrologerDetails());
    // return liveId;
    return "";
  }

  String requireNextLiveID() {
    // currentIndex = currentIndex + 1;
    // if (currentIndex > data.keys.toList().length - 1) {
    //   currentIndex = 0;
    // } else {}
    // liveId = data.keys.toList()[currentIndex];
    // unawaited(getAstrologerDetails());
    // return liveId;
    return "";
  }

  Map<String, dynamic> createGift({required num count, required String svga}) {
    final String accessToken = preferenceService.getToken() ?? "";
    return <String, dynamic>{
      "app_id": appID,
      "server_secret": serverSecret,
      "room_id": liveId,
      "user_id": userId,
      "user_name": userName,
      "gift_type": svga,
      "gift_count": count,
      "access_token": accessToken,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
  }

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
  //   return Future<void>.value();
  // }

  // Future<void> getAllGifts() async {
  //   GiftResponse giftResponse = GiftResponse();
  //   giftResponse = await liveRepository.getAllGiftsAPI();
  //   gifts = giftResponse.statusCode == HttpStatus.ok
  //       ? GiftResponse.fromJson(giftResponse.toJson())
  //       : GiftResponse.fromJson(GiftResponse().toJson());
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
  //         giftImage: "${_pref.getAmazonUrl()}${element.giftImage}",
  //         giftPrice: element.giftPrice,
  //         giftSvga: giftSvga,
  //       );
  //       temp.add(customGiftModel);
  //     },
  //   );
  //   customGiftModel = temp;
  //   return;
  // }

  String giftImageURL(String giftImage) {
    return "${_pref.getAmazonUrl()}$giftImage";
  }

  // bool hasBalance({required num quantity, required num amount}) {
  //   final num myCurrentBalance = num.parse(walletBalance.value.toString());
  //   final num myPurchasedOrder = quantity * amount;
  //   return myCurrentBalance >= myPurchasedOrder;
  // }

  Future<void> addUpdateLeaderboard({
    required num quantity,
    required num amount,
  }) async {
    num currentAmount = amount;
    final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/leaderboard/$userId")
        .get();
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          final num previousAmount = map["amount"];
          currentAmount = currentAmount + previousAmount;
        } else {}
      } else {}
    } else {}
    await FirebaseDatabase.instance
        .ref()
        .child("live/$liveId/leaderboard/$userId")
        .update(
      <String, dynamic>{
        "amount": currentAmount,
        "userName": userName,
        "avatar": avatar,
      },
    );
    return Future<void>.value();
  }

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
                  amount: value["amount"],
                  // ignore:  avoid_dynamic_calls
                  avatar: "${_pref.getAmazonUrl()}${value['avatar']}",
                  // ignore:  avoid_dynamic_calls
                  userName: value["userName"],
                ),
              );
            },
          );
          leaderboardModel = tempList;
        } else {}
      } else {
        leaderboardModel.clear();
      }
    } else {
      leaderboardModel.clear();
    }
    return;
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
  });

  final int amount;
  final String avatar;
  final String userName;
}
