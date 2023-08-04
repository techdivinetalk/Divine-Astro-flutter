import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:get/get.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderHistoryController());
  }
}
