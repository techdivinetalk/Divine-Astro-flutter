import 'package:divine_astrologer/pages/home/passbook/passbook_controller.dart';
import 'package:get/get.dart';

class PassbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PassbooksController());
  }
}
