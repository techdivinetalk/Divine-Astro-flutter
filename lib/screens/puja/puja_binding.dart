
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/screens/faq/faqs_controller.dart';
import 'package:divine_astrologer/screens/puja/puja_controller.dart';
import 'package:get/get.dart';

class PujaBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PujaController());
  }
}
