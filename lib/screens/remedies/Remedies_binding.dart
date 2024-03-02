
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/screens/faq/faqs_controller.dart';
import 'package:divine_astrologer/screens/remedies/remedies_controller.dart';
import 'package:get/get.dart';

class RemediesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(RemediesController());
  }
}
