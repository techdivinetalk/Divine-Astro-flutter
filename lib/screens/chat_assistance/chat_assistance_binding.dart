import 'package:get/get.dart';

import 'chat_assistance_controller.dart';

class ChatAssistanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatAssistanceController());
  }
}
