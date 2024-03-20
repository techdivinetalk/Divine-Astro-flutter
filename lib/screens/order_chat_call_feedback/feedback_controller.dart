// ignore_for_file: unrelated_type_equality_checks

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/astrr_feedback_details.dart';
import 'package:divine_astrologer/model/chat_history/order_chat_history.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/pages/home/home_controller.dart';
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

  Rx<AstroFeedbackDetailData?> astroFeedbackDetailData = Rx<AstroFeedbackDetailData?>(null);
  Order? order;
  RxList<FeedbackData> feedbacks = <FeedbackData>[].obs;


  final CallChatFeedBackRepository callChatFeedBackRepository = Get.put(
      CallChatFeedBackRepository());

  @override
  void onInit() async {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      int orderId = arguments['order_id'];
      int productId = arguments['product_type'];
     // String ordercall = arguments['order_id'];
      print("Id :: $orderId");
      print("Call :: $productId");
      getAstroFeedbackDetail(orderId);
      fetchDataBasedOnProductId(productId, orderId);
    }
  }


  Future<void> fetchDataBasedOnProductId(int productId, int orderId) async {
    try {
      loading.value = Loading.initial;
      update();

      if (productId == 12) {
        await getAstroChatList(orderId);
      } else {
        await getAstroCallList(orderId);
      }


    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  Future<void> getAstroFeedbackDetail(int orderId) async {
    loading.value = Loading.initial;
    update();
    try {
      var response = await callChatFeedBackRepository.getAstroFeedbackDetail(orderId);
      isFeedbackAvailable.value = response.success ?? false;
      if (isFeedbackAvailable.value) {
        astroFeedbackDetailData.value = response.data;
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  Future<void> getAstroChatList(int orderId) async {
   // loading.value = Loading.initial;
    update();
    try {
      if (processedPages.contains(currentPage.value)) {
        return;
      }

      var response = await callChatFeedBackRepository.getAstrologerChats(orderId);

      if (response != null) {
        if (response.success ?? false) {
          // Process the chat history data
          List<ChatMessage> chatMessages = response.data ?? [];

          // Access the order information
          order = response.order?.isNotEmpty == true ? response.order![0] : null;
          print(" Print order ${order?.productType.toString()}");
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
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }

  Future<void> getAstroCallList(int orderId) async {
   // loading.value = Loading.initial;
    update();
    try {
      if (processedPages.contains(currentPage.value)) {
        return;
      }

      var response = await callChatFeedBackRepository.getAstrologerCall(orderId);

      if (response != null) {
        if (response.success ?? false) {
          // Process the chat history data
          List<ChatMessage> chatMessages = response.data ?? [];
          // Access the order information
          order = response.order?.isNotEmpty == true ? response.order![0] : null;
          if (chatMessages.isNotEmpty) {
            chatMessageList.addAll(chatMessages);
            processedPages.add(currentPage.value);
            print("resopnsecall${processedPages.add(currentPage.value)}");
          }
        } else {
          throw CustomException(response.message ?? 'Failed to get call history');
        }
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }
}
