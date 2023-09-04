import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/home_page_model_class.dart';

class HomePageRepository extends ApiProvider {


  Future<HomePageModelClass> getDashboardData(Map<String, dynamic> param) async {
    try {
      final response = await post(getHomePageData,
          body: jsonEncode(param).toString(),headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final performanceList =
          HomePageModelClass.fromJson(json.decode(response.body));
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


}
