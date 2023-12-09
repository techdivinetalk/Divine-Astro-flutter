import 'dart:convert';

import 'package:divine_astrologer/model/performance_response.dart';
import 'package:flutter/cupertino.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/filter_performance_response.dart';
import '../model/performance_model_class.dart';

class PerformanceRepository extends ApiProvider {

  Future<PerformanceModelClass> getPerformancee(Map<String, dynamic> param) async {
    try {
      final response = await post(getPerformanceData,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final performanceList =
          PerformanceModelClass.fromJson(json.decode(response.body));
          return performanceList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PerformanceResponse> getPerformance() async {
    try {
      final response = await post(getPerformanceData,
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final performanceResponse =
          PerformanceResponse.fromJson(json.decode(response.body));
          return performanceResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PerformanceFilterResponse> getFilteredPerformance(Map<String, dynamic> param) async {
    try {
      final response = await post(getFilteredPerformace,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final performanceResponse =
          PerformanceFilterResponse.fromJson(json.decode(response.body));
          return performanceResponse;
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
