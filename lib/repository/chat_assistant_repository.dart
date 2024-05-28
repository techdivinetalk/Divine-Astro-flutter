import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/chat_assistant/CustomerDetailsResponse.dart';
import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../model/chat_assistant/chat_assistant_chats_response.dart';

class ChatAssistantRepository extends ApiProvider {
  Future<ChatAssistantAstrologerListResponse>
      getChatAssistantAstrologerList() async {
    try {
      final response = await get(getChatAssistAstrologers);
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerList =
              ChatAssistantAstrologerListResponse.fromJson(
                  json.decode(response.body));
          if (assistantAstrologerList.statusCode == successResponse &&
              assistantAstrologerList.success!) {
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

  Future<CustomerDetailsResponse> getConsulation() async {
    try {
      final response = await get(getConsulationData);
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          print("objectAssist ${json.decode(response.body)}");
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] == 500) {
          print("objectAssist ${json.decode(response.body)}");
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final customerDetailsResponse =
              CustomerDetailsResponse.fromJson(json.decode(response.body));
          if (customerDetailsResponse.statusCode == successResponse &&
              customerDetailsResponse.success) {
            return customerDetailsResponse;
          } else {
            print("objectAssist ${json.decode(response.body)}");
            throw CustomException(json.decode(response.body)["error"]);
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

  Future<ChatAssistChatResponse> getAstrologerChats(
      Map<String, dynamic> params) async {
    try {
      final response =
          await post(getChatAssistCustomerData, body: jsonEncode(params));
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerChatList =
              ChatAssistChatResponse.fromJson(json.decode(response.body));
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

  Future<MessageTemplateResponse?> doGetMessageTemplateForChatAssist() async {
    try {
      final response = await post(getMessageTemplateForChatAssist);
      if (response.statusCode == 200 && json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if (json.decode(response.body)["status_code"] == 200 &&
            json.decode(response.body)["success"] == true &&
            json.decode(response.body)["data"] != null) {
          return MessageTemplateResponse.fromJson(json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
