import 'package:divine_astrologer/repository/all_fine_details_repository.dart';
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/screens/all_fine_details/all_fine_controller.dart';
import 'package:get/get.dart';

class AllFineDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AllFineDetailsController(Get.put(AllFineDetailsRepository() as FAQsRepository)));
  }
}
