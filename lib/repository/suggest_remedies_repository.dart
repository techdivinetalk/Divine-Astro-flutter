import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/chat_suggest_remedies/chat_suggest_remedies.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../model/chat_assistant/chat_assistant_chats_response.dart';

class ChatRemediesRepository extends ApiProvider {

  Future<ChatSuggestRemediesListResponse> getChatSuggestRemediesList() async {
    try {
      final response = await get(getChatSuggestRemedies);
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerList =
          ChatSuggestRemediesListResponse.fromJson(json.decode(response.body));
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

  Future<ChatSuggestRemediesListResponse> getChatSuggestRemediesDetails(int page, int masterRemedyId) async {
    try {
      final response = await get(getChatSuggestRemediesDetail,
          queryParameters: {'page': page.toString(), 'master_remedy_id': masterRemedyId.toString()});
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerList =
          ChatSuggestRemediesListResponse.fromJson(json.decode(response.body));
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

}
