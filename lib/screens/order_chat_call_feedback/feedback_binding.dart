import 'package:divine_astrologer/repository/home_page_repository.dart';
import 'package:get/get.dart';

import 'feedback_controller.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageRepository());
    Get.put(FeedbackController());
  }
}
