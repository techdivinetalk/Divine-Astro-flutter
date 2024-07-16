import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/passbook/passbook_controller.dart';
import 'package:get/get.dart';



class PassbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PassbookController());
  }
}
