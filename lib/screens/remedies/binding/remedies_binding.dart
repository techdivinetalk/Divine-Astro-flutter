import 'package:divine_astrologer/screens/add_puja/add_puja_controller.dart';
import 'package:divine_astrologer/screens/puja/puja_controller.dart';
import 'package:divine_astrologer/screens/remedies/controller/remedies_controller.dart';
import 'package:get/get.dart';

class RemediesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(RemediesController());
  }
}
