
import 'package:get/get.dart';

import '../../../../repository/suggest_remedies_repository.dart';
import 'chatAssistSuggestRemedyController.dart';

class ChatAssistSuggestRemediesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatAssistSuggestRemedyController(Get.put(ChatRemediesRepository())));
  }
}
