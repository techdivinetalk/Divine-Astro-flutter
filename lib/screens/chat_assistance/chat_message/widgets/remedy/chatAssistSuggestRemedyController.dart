import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/chat_suggest_remedies/chat_suggest_remedies.dart';
import 'package:divine_astrologer/repository/suggest_remedies_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAssistSuggestRemedyController extends GetxController {
  late final ChatRemediesRepository remediesRepository;
  Rx<ChatSuggestRemediesListResponse> remedies =
      ChatSuggestRemediesListResponse().obs;
  RxBool isLoading = false.obs;

  ChatAssistSuggestRemedyController(this.remediesRepository);

  @override
  void onInit() {
    getChatRemediesListApi();
    super.onInit();
  }

  getChatRemediesListApi() async {
    isLoading(true);
    update();
    try {
      ChatSuggestRemediesListResponse response =
      await remediesRepository.getChatSuggestRemediesList();
      remedies.value = response;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    } finally {
      isLoading(false);
      update();
    }
  }
}