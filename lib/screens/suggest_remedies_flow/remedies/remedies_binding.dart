import 'package:divine_astrologer/screens/remedies/controller/remedies_controller.dart';
import 'package:get/get.dart';

class RemediesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RemediesController());
  }
}
