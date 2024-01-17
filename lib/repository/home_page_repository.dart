import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/feedback_response.dart';
import '../model/home_page_model_class.dart';
import '../model/tarot_response.dart';

class HomePageRepository extends ApiProvider {
  Future<HomePageModelClass> getDashboardData(
      Map<String, dynamic> param) async {
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
  Future<TarotResponse>
  getTarotCardData() async {
    print("response.data3");
    try {
      final response = await get(
        getTarotCardDataApi,
      );
      print("json.decode(response.body)");
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else{

          final tarotResponse =
          TarotResponse.fromJson(json.decode(response.body));
          saveTarotCards(tarotResponse.data!);
          return tarotResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
  Future<void> saveTarotCards(List<TarotCard> cards) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardsJson = json.encode(cards.map((card) => card.toJson()).toList());
    await prefs.setString('tarot_cards', cardsJson);
  }
  Future<FeedbackResponse> getFeedbackData() async {
    try {
      final response = await get(
        getFeedback,
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final feedbackResponse =
          FeedbackResponse.fromJson(json.decode(response.body));
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
