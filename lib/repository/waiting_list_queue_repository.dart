import 'dart:convert';

import 'package:divine_astrologer/model/waiting_list_queue.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';

class WaitingListQueueRepo extends ApiProvider {
  Future<WaitingListQueueModel> fetchData() async {
    try {
      final response = await post(getWaitingListQueue,
          headers: await getJsonHeaderURL(version: 7));

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final waitingListQueueModel =
              WaitingListQueueModel.fromJson(json.decode(response.body));
          if (waitingListQueueModel.statusCode == successResponse &&
              waitingListQueueModel.success!) {
            return waitingListQueueModel;
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

  Future<String> acceptChatApi({dynamic body}) async {
    try {
      final response = await post(
        partnerOfflineChoiceOrder,
        body: jsonEncode(body),
        headers: await getJsonHeaderURL(version: 7),
      );

      if (response.statusCode == 200) {
        return "suceess";
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
