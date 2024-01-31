import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../model/chat_assistant/chat_assistant_chats_response.dart';

class ChatAssistantRepository extends ApiProvider {
  Future<ChatAssistantAstrologerListResponse> getChatAssistantAstrologerList() async {
    try {
      final response = await get(getChatAssistAstrologers);
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerList =
              ChatAssistantAstrologerListResponse.fromJson(json.decode(response.body));
          if (assistantAstrologerList.statusCode == successResponse && assistantAstrologerList.success!) {
            return assistantAstrologerList;
          } else {
            throw CustomException(assistantAstrologerList.message!);
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
Future<ChatAssistantAstrologerListResponse> getConsulation() async {
    try {
      final response = await get(getConsulationData);
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          print("objectAsist ${json.decode(response.body)}");
          throw CustomException(json.decode(response.body)["error"]);
          //
          // final assistantAstrologerList =
          //     ChatAssistantAstrologerListResponse.fromJson(json.decode(response.body));
          // if (assistantAstrologerList.statusCode == successResponse && assistantAstrologerList.success!) {
          //   return assistantAstrologerList;
          //   throw CustomException(assistantAstrologerList.message!);
          // } else {
          //   throw CustomException(assistantAstrologerList.message!);
          // }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ChatAssistChatResponse> getAstrologerChats(Map<String, dynamic> params) async {
    try {
      final response = await post(getChatAssistCustomerData, body: jsonEncode(params));
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerChatList = ChatAssistChatResponse.fromJson(json.decode(response.body));
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
