import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astrr_feedback_details.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_history/order_chat_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallChatFeedBackRepository extends ApiProvider {

  Future<AstroFeedbackDetailResponse> getAstroFeedbackDetail(int orderId) async {
    try {
      final response = await post(
        getAstroFeedback,
        body: json.encode({'order_id': orderId}),
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse["status_code"] == 401) {
          throw CustomException(jsonResponse["error"]);
        } else {
          final data = jsonResponse["data"];

          if (data is List) {
            return AstroFeedbackDetailResponse(data: AstroFeedbackDetailData());
          } else {
            final astroFeedbackDetailResponse =
            AstroFeedbackDetailResponse.fromJson(jsonResponse);
            return astroFeedbackDetailResponse;
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }


  Future<ChatHistoryResponse> getAstrologerChats(int orderId) async {
    try {
      final response = await post(getChatHistory, body: json.encode({'order_id': orderId}));
      log('response --- ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(responseData["error"]);
        } else {
          final assistantAstrologerChatList = ChatHistoryResponse.fromJson(responseData);

          if (assistantAstrologerChatList.statusCode == successResponse &&
              assistantAstrologerChatList.success!) {
            return assistantAstrologerChatList;
          } else {
            throw CustomException(assistantAstrologerChatList.message!);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ChatHistoryResponse> getAstrologerCall(int orderId) async {
    try {
      final response = await post(getOrderCallHistory, body: json.encode({'order_id': orderId}));
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerChatList = ChatHistoryResponse.fromJson(json.decode(response.body));
          if (assistantAstrologerChatList.statusCode == successResponse &&
              assistantAstrologerChatList.success!) {
            return assistantAstrologerChatList;
          } else {
            throw CustomException(assistantAstrologerChatList.message!);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

}