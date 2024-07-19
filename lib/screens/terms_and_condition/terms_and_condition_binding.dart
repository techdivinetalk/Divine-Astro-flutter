import 'package:divine_astrologer/screens/terms_and_condition/terms_and_condition_controller.dart';
import 'package:get/get.dart';

class TermsAndConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionController>(
          () => TermsAndConditionController(),
    );
  }
}