import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/di/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../model/important_numbers.dart';

class ImportantNumberRepo extends ApiProvider {
  Future<ImportantNumberModel> fetchData() async {
    try {
      final response = await post(getImportantNumber,
          headers: await getJsonHeaderURL(version: 7));
//log("data----> ${response.body.toString()}");
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
           final importantNumbers = ImportantNumberModel.fromJson(json.decode(response.body));
          if (importantNumbers.statusCode == successResponse && importantNumbers.success!) {
            return importantNumbers;
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
