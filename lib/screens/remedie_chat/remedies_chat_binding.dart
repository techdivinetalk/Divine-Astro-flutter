import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/remedie_chat/remedies_chat_controller.dart';
import 'package:get/get.dart';

class RemediesChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RemediesChatController(Get.put(UserRepository())));
  }
}
