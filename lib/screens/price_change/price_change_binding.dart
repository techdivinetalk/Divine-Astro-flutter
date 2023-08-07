import 'package:get/get.dart';

import 'price_change_req_controller.dart';


class PriceChangeReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PriceChangeReqController());
  }
}
