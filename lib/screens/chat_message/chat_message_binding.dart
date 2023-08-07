import 'package:get/get.dart';
import 'chat_message_controller.dart';

class ChatMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatMessageController());
  }
}
