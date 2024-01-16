
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/screens/faq/faqs_controller.dart';
import 'package:get/get.dart';

class FAQsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FAQsController(Get.put(FAQsRepository())));
  }
}
