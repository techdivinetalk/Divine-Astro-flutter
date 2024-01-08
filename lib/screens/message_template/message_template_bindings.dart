import 'package:divine_astrologer/repository/message_template_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'message_template_controller.dart';


class MessageTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageTemplateController(Get.put(MessageTemplateRepo())));
  }
}
