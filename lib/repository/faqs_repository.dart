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

class FAQsRepository extends ApiProvider {
  Future<FAQsResponse> getFAQs() async {
    try {
      final response = await get(faq);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorized();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final faqs = faqsResponseFromJson(response.body);
          return faqs;
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
