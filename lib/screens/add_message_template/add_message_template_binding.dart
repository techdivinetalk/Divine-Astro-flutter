import 'package:divine_astrologer/repository/message_template_repository.dart';
import 'package:get/get.dart';

import 'add_message_template_controller.dart';


class AddMessageTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddMessageTemplateController(Get.put(MessageTemplateRepo())));
  }
}
