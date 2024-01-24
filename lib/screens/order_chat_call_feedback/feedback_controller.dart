import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/astrr_feedback_details.dart';
import 'package:divine_astrologer/model/chat_history/order_chat_history.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/repository/chat_call_feeback_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  var loading = Loading.initial.obs;
  var isFeedbackAvailable = false.obs;
  final messageScrollController = ScrollController();
  RxList chatMessageList = [].obs;
  Set<int> processedPages = {};
  RxInt currentPage = 1.obs;

  AstroFeedbackDetailData? astroFeedbackDetailData;
  RxList<FeedbackData> feedbacks = <FeedbackData>[].obs;


  final CallChatFeedBackRepository callChatFeedBackRepository = Get.put(
      CallChatFeedBackRepository());

  @override
  void onInit() async {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      int orderId = arguments['order_id'];
      print("Id :: $orderId");
      getAstroFeedbackDetail(orderId);
      getAstroChatList(24580);
    }
  }

  Future<void> getAstroFeedbackDetail(int orderId) async {
    loading.value = Loading.initial;
    update();
    try {
      var response =
      await callChatFeedBackRepository.getAstroFeedbackDetail(orderId);
      isFeedbackAvailable.value = response.success ?? false;
      if (isFeedbackAvailable.value) {
        astroFeedbackDetailData = response.data;
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  Future<void> getAstroChatList(int orderId) async {
    loading.value = Loading.initial;
    update();
    try {
      if (processedPages.contains(currentPage.value)) {
        return;
      }
      var response = await callChatFeedBackRepository.getAstrologerChats(orderId);

      if (response != null) {
        if (response.success) {
          // Process the chat history data
          List<ChatMessage> chatMessages = response.data ?? [];
          if (chatMessages.isNotEmpty) {
            chatMessageList.addAll(chatMessages);
            processedPages.add(currentPage.value);
          }
        } else {
          throw CustomException(response.message ?? 'Failed to get chat history');
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

}
