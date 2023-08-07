import 'package:get/get.dart';

import '../donation/donation_controller.dart';

class DonationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonationController());
  }
}
