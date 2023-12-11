import 'package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart';
import "package:get/get.dart";

class LiveDharamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(LiveDharamController.new);
  }
}
