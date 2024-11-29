import 'package:divine_astrologer/repository/suggest_remedies_repository.dart';
import 'package:divine_astrologer/screens/chat_remedies/chat_suggest_remedies_controller.dart';
import 'package:get/get.dart';

class ChatSuggestRemediesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatSuggestRemedyController(Get.put(ChatRemediesRepository())));
  }
}
