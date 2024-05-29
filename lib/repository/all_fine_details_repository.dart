import 'dart:convert';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/all_fine_details_model.dart';
import 'package:divine_astrologer/model/faq_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AllFineDetailsRepository extends ApiProvider {

  Future<FeedbackFineResponse> getFeedBackDetails() async {
    try {
      final response = await post(getAllFeedbackFineDetail); if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(jsonResponse["error"]);
        } else {
          final feedbackResponse = feedbackFineResponseFromJson(response.body);
          return feedbackResponse;
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
