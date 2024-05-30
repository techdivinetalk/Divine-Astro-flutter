import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/model/astrologer_training_session_response.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_data_response.dart';
import 'package:divine_astrologer/model/home_model/training_video_model.dart';
import 'package:divine_astrologer/model/live/new_tarot_card_model.dart';
import 'package:divine_astrologer/model/sample_text_response.dart';
import 'package:divine_astrologer/model/wallet_deatils_response.dart';
import 'package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
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
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      log("Dashboard:: chat_previous_status:: ${json.decode(response.body)["data"]["chat_previous_status"]}");
      log("Dashboard:: call_previous_status:: ${json.decode(response.body)["data"]["call_previous_status"]}");
      log("Dashboard:: video_call_previous_status:: ${json.decode(response.body)["data"]["video_call_previous_status"]}");

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<TarotResponse> getTarotCardData() async {
    print("response.data3");
    try {
      final response = await get(
        getTarotCardDataApi,
      );
      print("json.decode(response.body)");
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final tarotResponse =
              TarotResponse.fromJson(json.decode(response.body));
          saveTarotCards(tarotResponse.data!);

          NewTarotCardModel model =
              NewTarotCardModel.fromJson(json.decode(response.body));
          await LiveSharedPreferencesSingleton().setAllTarotCard(model: model);

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

  Future<WalletPointResponse> getWalletDetailsData(wallet) async {
    try {
      final response = await get(
        '$getwalletPointDetail?wallet_type=$wallet',
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final walletDetailsResponse =
              WalletPointResponse.fromJson(json.decode(response.body));
          return walletDetailsResponse;
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
        getNotFeedback,
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final feedbackResponse =
              FeedbackResponse.fromJson(json.decode(response.body));
          print("GetNotSeenFedBack:: ${feedbackResponse.toJson()}");
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

  Future<TrainingVideoModel> getAllTraningVideoApi() async {
    try {
      final response = await post(
        getTrainingVideo,
        headers: await getJsonHeaderURL(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final feedbackResponse =
              TrainingVideoModel.fromJson(json.decode(response.body));
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

  Future<FeedbackResponse> getFeedbackDataList() async {
    try {
      final response = await get(
        getFeedbackList,
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<AstrologerLiveDataResponse> doGetAstrologerLiveData() async {
    // if(Constants.isDebugMode){
    //   try {
    //     final response = await post(
    //       getAstrologerLiveData,
    //       endPoint: 'https://wakanda-api.divinetalk.live/api/astro/v7/',
    //       // headers: await getJsonHeaderURLDebugWakanda(),
    //       headers: await getJsonHeaderURL(),
    //     );
    //
    //     debugPrint("test_response_body: ${response.body}");
    //
    //     if (response.statusCode == 200) {
    //       if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized || json.decode(response.body)["status_code"] ==
    //              HttpStatus.badRequest) {
    //         Utils().handleStatusCodeUnauthorized();
    //         throw CustomException(json.decode(response.body)["error"]);
    //       } else {
    //         final feedbackResponse =
    //         AstrologerLiveDataResponse.fromJson(json.decode(response.body));
    //         return feedbackResponse;
    //       }
    //     } else {
    //       throw CustomException(json.decode(response.body)["error"]);
    //     }
    //   } catch (e, s) {
    //     debugPrint("we got $e $s");
    //     rethrow;
    //   }
    // }else{
    try {
      final response = await post(
        getAstrologerLiveData,
        headers: await getJsonHeaderURL(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      debugPrint("test_response_body: ${response.body}");

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final feedbackResponse =
              AstrologerLiveDataResponse.fromJson(json.decode(response.body));
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

  // }

  Future<SampleTextResponse?> doGetSampleText() async {
    try {
      final response = await post(getSampleText);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200 && json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] == 200 &&
            json.decode(response.body)["success"] == true &&
            json.decode(response.body)["data"] != null) {
          return SampleTextResponse.fromJson(json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<AstrologerTrainingSessionResponse?>
      doGetAstrologerTrainingSession() async {
    try {
      final response = await post(getAstrologerTrainingSession);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200 && json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] == 200 &&
            json.decode(response.body)["success"] == true &&
            json.decode(response.body)["data"] != null) {
          return AstrologerTrainingSessionResponse.fromJson(
              json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
