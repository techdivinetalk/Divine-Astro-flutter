import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat_model.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class CallChatHistoryRepository extends ApiProvider {

  Future<ChatHistoryResponse> getAstrologerChats(int customerId, int partnerId, int page) async {
    try {
      final response = await post(viewChatHistory, body: json.encode({
        "customer_id" : customerId,
        "partner_id" : partnerId,
        "page" : page,
      }));
      log('response --- ${response.body}');

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
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


}