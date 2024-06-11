import 'dart:convert';

import 'package:divine_astrologer/model/home_model/astrologer_live_log_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';

class LiveLogsPageRepository extends ApiProvider {
  Future<AstrologerLiveLogResponse> doAstrologerLiveLog(
      Map<String, dynamic> param) async {
    try {
      final response = await post(
        astrologerLiveLog,
        body: jsonEncode(param),
        headers: await getJsonHeaderURL(),
      );

      debugPrint("test_response_body: ${response.body}");
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final feedbackResponse =
              AstrologerLiveLogResponse.fromJson(json.decode(response.body));
          return feedbackResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
