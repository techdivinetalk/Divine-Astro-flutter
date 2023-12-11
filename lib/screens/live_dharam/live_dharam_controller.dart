import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:get/get.dart";

class LiveDharamController extends GetxController {
  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  final RxString _userId = "".obs;
  final RxString _userName = "".obs;
  final RxString _liveId = "".obs;
  final RxBool _isHost = false.obs;

  @override
  void onInit() {
    super.onInit();

    userId = (_pref.getUserDetail()?.id ?? "").toString();
    userName = (_pref.getUserDetail()?.name ?? "").toString();
    liveId = (Get.arguments ?? "").toString();
    isHost = true;
  }

  @override
  void onClose() {
    _userId.close();
    _userName.close();
    _liveId.close();
    _isHost.close();

    super.onClose();
  }

  String get userId => _userId.value;
  set userId(String value) => _userId(value);

  String get userName => _userName.value;
  set userName(String value) => _userName(value);

  String get liveId => _liveId.value;
  set liveId(String value) => _liveId(value);

  bool get isHost => _isHost.value;
  set isHost(bool value) => _isHost(value);
}
