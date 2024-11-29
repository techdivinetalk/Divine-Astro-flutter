import 'package:divine_astrologer/repository/home_page_repository.dart';
import 'package:get/get.dart';

import 'order_feedback_controller.dart';

class OrderFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageRepository());
    Get.put(OrderFeedbackController());
  }
}
