import 'package:divine_astrologer/screens/final_sub_remedy/final_remedies_sub_controller.dart';
import 'package:get/get.dart';


class FinalRemediesSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinalRemediesSubController());
  }
}
