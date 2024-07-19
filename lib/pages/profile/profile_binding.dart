import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfilePageController());
  }
}
