import 'package:divine_astrologer/repository/refer_astrologer_repository.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_controller.dart';
import 'package:get/get.dart';

class ReferAstrologerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReferAstrologerController(Get.put(ReferAstrologerRepository())));
  }
}
