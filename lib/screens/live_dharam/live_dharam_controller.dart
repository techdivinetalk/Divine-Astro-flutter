// ignore_for_file: invalid_use_of_protected_member

import "dart:async";
import "dart:convert";

import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart";
import "package:firebase_database/firebase_database.dart";
import "package:get/get.dart";
import "package:get/get_connect/http/src/status/http_status.dart";
import "package:http/http.dart" as http;

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
  // final RxMap<dynamic, dynamic> _data = <dynamic, dynamic>{}.obs;
  // final Rx<GetAstroDetailsRes> _details = GetAstroDetailsRes().obs;

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
    // data = <dynamic, dynamic>{};
    // details = GetAstroDetailsRes();
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
    // _data.close();
    // _details.close();

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

  // Map<dynamic, dynamic> get data => _data.value;
  // set data(Map<dynamic, dynamic> value) => _data(value);

  // GetAstroDetailsRes get details => _details.value;
  // set details(GetAstroDetailsRes value) => _details(value);

  // void eventListner(DatabaseEvent event) {
  //   if (event.snapshot.value == null) {
  //     data.clear();
  //   } else {
  //     final Object? value = event.snapshot.value;
  //     if (value is Map<dynamic, dynamic>) {
  //       final Map<dynamic, dynamic> mapTypeObject = value;
  //       data.addAll(mapTypeObject);
  //       if (data.isEmpty) {
  //       } else if (data.isNotEmpty) {
  //         if (isInitialSetup) {
  //           liveId = data.keys.toList()[currentIndex];
  //           unawaited(getAstrologerDetails());
  //           isInitialSetup = false;
  //         } else {}
  //       } else {}
  //     } else {}
  //   }
  //   return;
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

  // Map<String, dynamic> get createGift {
  //   return <String, dynamic>{
  //     "app_id": appID,
  //     "server_secret": serverSecret,
  //     "room_id": liveId,
  //     "user_id": userId,
  //     "user_name": userName,
  //     "gift_type": 1001,
  //     "gift_count": 1,
  //     "access_token": preferenceService.getToken() ?? "",
  //     "timestamp": DateTime.now().millisecondsSinceEpoch,
  //   };
  // }

  // Future<void> sendGiftAPI({
  //   required void Function(String message) successCallback,
  //   required void Function(String message) failureCallback,
  // }) async {
  //   try {
  //     const String url = "https://zego-virtual-gift.vercel.app/api/send_gift";
  //     final http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{"Content-Type": "application/json"},
  //       body: jsonEncode(createGift),
  //     );
  //     response.statusCode == HttpStatus.ok
  //         ? successCallback("Yay!")
  //         : failureCallback("[ERROR], Send Gift Fail: ${response.statusCode}");
  //   } on Exception catch (error) {
  //     failureCallback("[ERROR], Send Gift Fail, $error");
  //   }
  //   return Future<void>.value();
  // }
}
