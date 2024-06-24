
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:get/get.dart';


class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewChatController());
  }
}
