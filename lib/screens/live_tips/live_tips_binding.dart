import 'package:divine_astrologer/screens/live_tips/live_tips_controller.dart';
import 'package:get/get.dart';


class LiveTipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LiveTipsController());
  }
}
