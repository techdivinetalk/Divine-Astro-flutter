import 'package:get/get.dart';

import 'order_feedback_controller.dart';

class OrderFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderFeedbackController());
  }
}
