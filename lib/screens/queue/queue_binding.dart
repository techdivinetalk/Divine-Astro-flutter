import 'package:divine_astrologer/screens/queue/queue_controller.dart';
import 'package:get/get.dart';



class QueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QueueController());
  }
}
