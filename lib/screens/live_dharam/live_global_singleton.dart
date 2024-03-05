import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LiveGlobalSingleton {
  static final LiveGlobalSingleton _singleton = LiveGlobalSingleton._internal();

  factory LiveGlobalSingleton() {
    return _singleton;
  }

  LiveGlobalSingleton._internal();

  final RxBool _isInLiveScreen = false.obs;

  bool get isInLiveScreen => _isInLiveScreen.value;
  set isInLiveScreen(bool value) => _isInLiveScreen(value);

  final Rx<BuildContext> _buildContext = Get.context!.obs;

  BuildContext get buildContext => _buildContext.value;
  set buildContext(BuildContext value) => _buildContext(value);

  Future<void> leaveLiveIfIsInLiveScreen() async {
    // if (isInLiveScreen) {
    //   await zegoController.leave(buildContext);
    // } else {}
    return Future<void>.value();
  }
}
