import 'package:divine_astrologer/model/add_message_template_response.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/chat_message/chat_message_controller.dart';
import 'package:divine_astrologer/screens/message_template/message_template_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../model/message_template_response.dart';
import '../../model/update_message_template_response.dart';
import '../../repository/message_template_repository.dart';
import '../chat_message_with_socket/chat_message_with_socket_controller.dart';

class AddMessageTemplateController extends GetxController {
  final MessageTemplateRepo repository;

  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  AddMessageTemplateController(this.repository);

  RxInt nameLenght = 0.obs;
  RxString nameErrorText = ''.obs;
  RxString messageErrorText = ''.obs;
  RxBool enableTextField = true.obs;
  bool fromChat = false;
  bool isUpdate = false;
  late MessageTemplates messageTemplate;
  final messageTemplateController =
      Get.put(MessageTemplateController(MessageTemplateRepo()));

  @override
  void onInit() {
    super.onInit();
    var argument = Get.arguments;
    if (argument != null) {
      fromChat = argument.first;
      isUpdate = argument[1];
    }
    if (isUpdate) {
      messageTemplate = argument[2];
      nameController.text = messageTemplate.message ?? '';
      messageController.text = messageTemplate.description ?? '';
      nameLenght.value = nameController.text.trim().length;
    }

    nameController.addListener(() {
      if (nameController.text.trim().length <= 15) {
        nameLenght.value = nameController.text.trim().length;
        nameErrorText.value = '';
      } else {
        nameErrorText.value = 'Template Name can have maximum 15 characters';
        enableTextField.value = false;
      }
    });
  }

  bool validate() {
    bool value = false;
    if (nameController.text.trim().length <= 15 &&
        messageController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty) {
      value = true;
      messageErrorText.value = '';
      nameErrorText.value = '';
    }
    return value;
  }

  submit() async {
    if (validate()) {
      Map<String, dynamic> params = {
        "message": nameController.text.trim(),
        "description": messageController.text.trim(),
      };
      AddMessageTemplateResponse response =
          await repository.addTemplates(params);
      print("added message template ${response.toJson()}");
      if (response.statusCode == 200) {
        await messageTemplateController.addedMessageTemplates();
        Get.back(result: {'updated': true});
      }
      if (response.statusCode == 400 || response.success == false) {
        Fluttertoast.showToast(
            msg: response.message ?? 'Only 10 Templates are allowed');
      }
    } else {
      if (nameController.text.isEmpty) {
        nameErrorText.value = 'Please enter template name';
      } else if (messageController.text.isEmpty) {
        messageErrorText.value = 'Please enter message';
      }
    }
  }

  updateForm() async {
    if (validate()) {
      Map<String, dynamic> params = {
        "message": nameController.text.trim(),
        "description": messageController.text.trim(),
        "template_id": messageTemplate.id,
      };
      UpdateMessageTemplateResponse response =
          await repository.updateTemplates(params);
      if (response.statusCode == 200) {
        Get.find<MessageTemplateController>().getMessageTemplates();
        Get.back();
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.message.toString());
      }
    } else {
      if (nameController.text.isEmpty) {
        nameErrorText.value = 'Please enter template name';
      } else if (messageController.text.isEmpty) {
        messageErrorText.value = 'Please enter message';
      }
    }
  }
}
