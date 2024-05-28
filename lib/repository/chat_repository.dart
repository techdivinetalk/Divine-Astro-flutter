import 'dart:convert';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astrologer_chat_list.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../model/ResSaveKundli.dart';
import '../model/chat/res_common_chat_success.dart';

class ChatRepository extends ApiProvider {
  Future<ResSaveKundli> saveKundliData(Map<String, dynamic> param) async {
    try {
      final response =
      await post(saveKundliDetails, body: jsonEncode(param).toString());

      print("place of birthjson:: ${jsonEncode(param).toString()}");

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final apiResponse =
          ResSaveKundli.fromJson(json.decode(response.body));
          if (apiResponse.statusCode == successResponse &&
              apiResponse.success!) {
            return apiResponse;
          } else {
            throw CustomException("Unknown Error");
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }
  Future<AstrologerChatList> getChatListApi(Map<String, dynamic> param) async {
    try {
      final response = await post(
        getChatList,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
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

  Future<dynamic> chatAccept(Map<String, dynamic> param) async {
    try {
      final response = await post(
        chatAcceptAPI,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final astrologerChatList =
              ResCommonChatStatus.fromJson(jsonDecode(response.body));
          return astrologerChatList;
          // if (astrologerChatList.statusCode == successResponse &&
          //     astrologerChatList.success!) {
          //   return astrologerChatList;
          // } else {
          //   throw CustomException(json.decode(response.body)["message"]);
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

  Future<dynamic> endChat(Map<String, dynamic> param) async {
    try {
      final response = await post(
        endChatAPI,
        body: jsonEncode(param),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final astrologerChatList =
              ResCommonChatStatus.fromJson(json.decode(response.body));
          // if (astrologerChatList.statusCode == successResponse &&
          //     astrologerChatList.success!) {
          return astrologerChatList;
          // } else {
          //   divineSnackBar(
          //       data: json.decode(response.body)["message"],
          //       color: appColors.redColor);
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
}
