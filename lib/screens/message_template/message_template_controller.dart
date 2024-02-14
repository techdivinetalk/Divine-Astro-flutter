import 'dart:convert';

import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../model/message_template_response.dart';
import '../../repository/message_template_repository.dart';
import '../../utils/enum.dart';

class MessageTemplateController extends GetxController {
  final MessageTemplateRepo repository;
  final sharedPreferencesInstance = SharedPreferenceService();

  Loading loading = Loading.initial;
  List<MessageTemplates> messageTemplates = <MessageTemplates>[];
  List<MessageTemplates> messageLocalTemplates = <MessageTemplates>[];

  MessageTemplateController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    loading = Loading.loading;
    print('called again');
    getMessageTemplates();
    getMessageTemplatesLocally();
    update();
  }

  getMessageTemplatesLocally() async {
    final data = await sharedPreferencesInstance.getMessageTemplates();
    messageLocalTemplates = data;
    update();
  }

  updateMessageTemplateLocally() async {
    await sharedPreferencesInstance
        .saveMessageTemplates(json.encode(messageLocalTemplates));
    await getMessageTemplatesLocally();
    // print("result: " + result);
  }

  getMessageTemplates() async {
    try {
      final response = await repository.fetchTemplates();
      if (response.data != null) {
        messageTemplates = response.data!;
        //await preferenceService.saveMessageTemplates(response.toPrettyString());
      }
      //MessageTemplateResponse? res = preferenceService.getMessageTemplates();
      //debugPrint('res: ${res?.data?.length}');
      loading = Loading.loaded;
      update();
    } catch (error) {
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }
}
