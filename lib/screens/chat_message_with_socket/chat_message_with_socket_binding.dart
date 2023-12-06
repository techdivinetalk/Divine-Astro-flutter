import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:get/get.dart';
import '../../repository/chat_repository.dart';
import 'chat_message_with_socket_controller.dart';

class ChatMessageWithSocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatMessageWithSocketController());
  }
}
