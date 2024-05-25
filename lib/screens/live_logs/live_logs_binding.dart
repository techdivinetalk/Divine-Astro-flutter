import 'package:divine_astrologer/repository/message_template_repository.dart';
import 'package:get/get.dart';

import 'live_logs_controller.dart';


class LiveLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LiveLogsController());
  }
}
