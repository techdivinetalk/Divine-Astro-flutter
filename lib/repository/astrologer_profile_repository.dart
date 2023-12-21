import 'dart:convert';

import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AstrologerProfileRepository extends ApiProvider {
  Future<GiftResponse> getAllGiftsAPI() async {
    GiftResponse data = GiftResponse();
    try {
      final response = await get(getAllGifts);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = GiftResponse.fromJson(responseBody);
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {}
      } else {}
    } on Exception catch (error, stack) {
      debugPrint("getAllGiftsAPI(): Exception caught: error: $error");
      debugPrint("getAllGiftsAPI(): Exception caught: stack: $stack");
    }
    return Future<GiftResponse>.value(data);
  }
}
