import 'dart:convert';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/kundli/astro_details_model.dart';
import 'package:divine_astrologer/model/kundli/birth_details_model.dart';
import 'package:divine_astrologer/model/kundli/horo_chart_model.dart';
import 'package:divine_astrologer/model/kundli/kalsarpa_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/kundli_prediction_model.dart';
import 'package:divine_astrologer/model/kundli/manglik_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/pitra_dosh_model.dart';
import 'package:divine_astrologer/model/kundli/sadhesati_dosh_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/routes.dart';
import '../model/get_kundli_data.dart' as kundli_data;

class KundliRepository extends ApiProvider {
  Future<AstroDetails> getAstroDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(astroDetails,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params).toString());
      if (response.statusCode == 200) {
        final astroDetails = astroDetailsFromJson(response.body);
        // if (astroDetails.status) {
        return astroDetails;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<BirthDetails> getBirthDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(birthDetails,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final birthDetails = birthDetailsFromJson(response.body);
        // if (astroDetails.status) {
        return birthDetails;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]['message']);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<KalsarpaDosh> getKalsarpaDoshDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await post(kalsarpaDetails,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final kalsarpaDoshDetails = kalsarpaDoshFromJson(response.body);
        // if (astroDetails.status) {
        return kalsarpaDoshDetails;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error'][0]['message']}');
        throw CustomException(
            json.decode(response.body)["error"][0]['message']);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ManglikDosh> getManglikDoshDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(manglik,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final manglikDosh = manglikDoshFromJson(response.body);
        // if (astroDetails.status) {
        return manglikDosh;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error']}');
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PitraDosh> getPitraDoshDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(pitraDoshReport,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final pitraDosh = pitraDoshFromJson(response.body);
        // if (astroDetails.status) {
        return pitraDosh;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<HoroChart> getHoroChart(
      Map<String, dynamic> params, String chartId) async {
    try {
      final response = await post('$horoChartImage$chartId',
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final horoChart = horoChartFromJson(response.body);
        // if (astroDetails.status) {
        return horoChart;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<SadesathiDosh> getSadesathiDoshDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await post(sadhesatiStatus,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final sadesathiDosh = sadesathiDoshFromJson(response.body);
        // if (astroDetails.status) {
        return sadesathiDosh;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error'][0]['message']}');
        throw CustomException(
            json.decode(response.body)["error"][0]['message']);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<KundliPrediction> getKundliPredictionDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await post(kundliPrediction,
          endPoint: astrologyBaseUrl,
          headers: getAstrologyHeader(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final kundliPrediction = kundliPredictionFromJson(response.body);
        // if (astroDetails.status) {
        return kundliPrediction;
        // } else {
        //   throw CustomException("Unknown Error");
        // }
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error'][0]['message']}');
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<kundli_data.ResGetKundli> getKundliDetais(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getKundliData,
          endPoint: "https://wakanda-api.divinetalk.live/api/v7/",
          body: jsonEncode(param),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final customerLoginModel =
              kundli_data.ResGetKundli.fromJson(json.decode(response.body));

          return customerLoginModel;
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
