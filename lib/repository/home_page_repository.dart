import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/home_page_model_class.dart';

class HomePageRepository extends ApiProvider {
  Future<HomePageModelClass> getDashboardData(
      Map<String, dynamic> param) async {
    String ddd = '''
          {
    "data": {
        "total_earning": 2779.4500000000003,
        "todays_earning": 0,
        "on_going_call": {},
        "session_type": {
            "chat": 1,
            "chat_amount": 10,
            "call": 1,
            "chat_schedual_at": "",
            "audio_call_amount": 10,
            "video": 1,
            "video_call_amount": 25,
            "video_schedual_at": ""
        },
        "offer_type": [
            {
                "id": 34,
                "offer_name": "Free 5 Min",
                "call_rate": 0,
                "is_active": "0"
            },
            {
                "id": 124,
                "offer_name": "5 rs min offer",
                "call_rate": 5,
                "is_active": "0"
            }
        ],
        "training_video": [
            {
                "id": 4,
                "title": "Demo 4",
                "description": "Demo 2",
                "url": "https://www.youtube.com/watch?v=C480i6K8OHE",
                "days": 7
            },
            {
                "id": 3,
                "title": "Demo 3",
                "description": "Demo 2",
                "url": "https://www.youtube.com/watch?v=C480i6K8OHE",
                "days": 7
            },
            {
                "id": 2,
                "title": "Demo 2",
                "description": "Demo 2",
                "url": "https://www.youtube.com/watch?v=C480i6K8OHE",
                "days": 7
            },
            {
                "id": 1,
                "title": "Demo 1 ",
                "description": "Demo 1",
                "url": "https://www.youtube.com/watch?v=C480i6K8OHE",
                "days": 7
            }
        ]
    },
    "success": true,
    "status_code": 200,
    "message": "Get data Successfully"
}
          ''';


    final performanceList =
    HomePageModelClass.fromJson(json.decode(ddd));
    // final performanceList =
    //     HomePageModelClass.fromJson(json.decode(response.body));
    return performanceList;
    try {
      final response = await post(
        getHomePageData,
        body: jsonEncode(param).toString(),
        headers: await getJsonHeaderURL(),
      );

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
