import 'dart:convert';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astrologer_chat_list.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatRepository extends ApiProvider {
  Future<AstrologerChatList> getChatListApi(Map<String, dynamic> param) async {
    try {
      final response = await post(
        getChatList,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final astrologerChatList = astrologerChatListFromJson(response.body);
          if (astrologerChatList.statusCode == successResponse &&
              astrologerChatList.success!) {
            return astrologerChatList;
          } else {
            throw CustomException(json.decode(response.body)["message"]);
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
