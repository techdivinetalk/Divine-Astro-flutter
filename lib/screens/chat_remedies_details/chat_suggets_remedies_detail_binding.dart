import 'package:divine_astrologer/repository/suggest_remedies_repository.dart';
import 'package:divine_astrologer/screens/chat_remedies_details/chat_sugget_remedies_details_controller.dart';
import 'package:get/get.dart';

class ChatSuggestRemediesDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatSuggestRemedyDetailsController(Get.put(ChatRemediesRepository())));
  }
}
