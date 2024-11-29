import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/chat_suggest_remedies/chat_suggest_remedies.dart';
import 'package:divine_astrologer/repository/suggest_remedies_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSuggestRemedyDetailsController extends GetxController {
  late final ChatRemediesRepository remediesRepository;
  Rx<ChatSuggestRemediesListResponse> remedies = ChatSuggestRemediesListResponse().obs;
  Loading loading = Loading.initial;

  ChatSuggestRemedyDetailsController(this.remediesRepository);

  RxInt selectedIndex = (-1).obs;

  RxString name = ''.obs;

  // Setter function to update the name
  void setName(String newName) {
    name.value = newName;
  }

  @override
  void onInit() {
    var remedy = Get.arguments['remedy'];
    if (remedy != null) {
      // Access the name from the remedy and set it
      setName(remedy.name);
      getChatRemediesListDetails(1, remedy.id);
    }
    super.onInit();
  }

  getChatRemediesListDetails(int page, int masterRemedyId) async {
    loading = Loading.loading;
    update();
    try {
      ChatSuggestRemediesListResponse response =
      await remediesRepository.getChatSuggestRemediesDetails(page,masterRemedyId);
      remedies.value = response;
      loading = Loading.loaded;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
      loading = Loading.loaded;
    }
    update();
  }

  @override
  void onClose() {
    selectedIndex.close();
    super.onClose();
  }
}
