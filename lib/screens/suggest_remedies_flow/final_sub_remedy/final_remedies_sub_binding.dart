import 'package:divine_astrologer/screens/suggest_remedies_flow/final_sub_remedy/final_remedies_sub_controller.dart';
import 'package:get/get.dart';

class FinalRemediesSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinalRemediesSubController());
  }
}
