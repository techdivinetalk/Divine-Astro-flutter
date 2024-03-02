import 'package:divine_astrologer/screens/add_remedies/add_remedies_controller.dart';
import 'package:get/get.dart';

class AddRemediesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AddRemediesController());
  }
}
