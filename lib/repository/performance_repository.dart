import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/performance_model_class.dart';

class PerformanceRepository extends ApiProvider {

  Future<PerformanceModelClass> getPerformance(Map<String, dynamic> param) async {
    try {
      final response = await post(getPerformanceData,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
          PerformanceModelClass.fromJson(json.decode(response.body));
          return blockedCustomerList;
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
