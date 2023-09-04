import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:get/get.dart';
import 'chat_message_controller.dart';

class ChatMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatMessageController(Get.put(KundliRepository())));
  }
}
