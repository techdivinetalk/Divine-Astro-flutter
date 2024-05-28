import 'dart:convert';

import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/add_message_template_response.dart';
import '../model/update_message_template_response.dart';

class MessageTemplateRepo extends ApiProvider {

  Future<MessageTemplateResponse> fetchTemplates() async {
    try {
      final response = await get(getMessageTemplate,
          headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final messageTemplates =
          MessageTemplateResponse.fromJson(json.decode(response.body));
          if (messageTemplates.statusCode == successResponse &&
              messageTemplates.success!) {
            return messageTemplates;
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

  Future<AddMessageTemplateResponse> addTemplates(Map<String, dynamic> param) async {
    try {
      final response = await post(addMessageTemplate,
          body: jsonEncode(param),
          headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final addMessageResponse =
          AddMessageTemplateResponse.fromJson(json.decode(response.body));
          if (addMessageResponse.statusCode == successResponse &&
              addMessageResponse.success!) {
            return addMessageResponse;
          } else {
            Fluttertoast.showToast(msg: json.decode(response.body)["message"]);
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

  Future<UpdateMessageTemplateResponse> updateTemplates(Map<String, dynamic> param) async {
    try {
      final response = await post(editMessageTemplate,
          body: jsonEncode(param),
          headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final updateMessageResponse =
          UpdateMessageTemplateResponse.fromJson(json.decode(response.body));
          if (updateMessageResponse.statusCode == successResponse &&
              updateMessageResponse.success!) {
            return updateMessageResponse;
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