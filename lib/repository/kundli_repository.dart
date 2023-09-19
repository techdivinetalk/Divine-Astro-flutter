import 'dart:convert';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/routes.dart';
import '../model/get_kundli_data.dart' as kundli_data;
import '../model/internal/astro_details_model.dart';
import '../model/internal/birth_details_model.dart';
import '../model/internal/dasha_chart_data_model.dart';
import '../model/internal/horo_chart_model_class.dart';
import '../model/internal/kp_data_model.dart';
import '../model/internal/kundli_prediction_model.dart';
import '../model/internal/manglik_dosh_model.dart';
import '../model/internal/planet_detail_model.dart';
import '../model/internal/pran_dasha_model.dart';
import '../model/internal/pratyantar_dasha_model.dart';
import '../model/internal/sookshma_dasha_model.dart';

class KundliRepository extends ApiProvider {
  //done
  Future<AstroDetailsModel> getAstroDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(getAstroDetailsInt,
          headers: await getJsonHeaderURL(version: 7),
          body: jsonEncode(params).toString());
      if (response.statusCode == 200) {
        final astroDetails = astroDetailsModelFromJson(response.body);
        return astroDetails;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //done
  Future<BirthDetailsModel> getBirthDetails(Map<String, dynamic> params) async {
    try {
      final response = await post(getBirthDetailsInt,
          headers: await getJsonHeaderURL(version: 7),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final birthDetails = birthDetailsModelFromJson(response.body);
        return birthDetails;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]['message']);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

//done
  Future<ManglikDoshModel> getManglikDoshDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await post(getManglikDetailsInt,
          headers: await getJsonHeaderURL(version: 7),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final manglikDosh = manglikDoshModelFromJson(response.body);
        return manglikDosh;
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error']}');
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //done
  Future<HoroChartModel> getHoroChart(
      Map<String, dynamic> params, String chartId) async {
    try {
      final response = await post('$horoChartImageInt$chartId',
          headers: await getJsonHeaderURL(), body: jsonEncode(params));
      if (response.statusCode == 200) {
        final horoChart = horoChartModelFromJson(response.body);
        return horoChart;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //done
  Future<KundliPredictionModel> getKundliPredictionDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await post(getGeneralNakshatraReportInt,
          headers: await getJsonHeaderURL(version: 7),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final kundliPrediction = kundliPredictionModelFromJson(response.body);
        return kundliPrediction;
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

  //KP chart Data
  Future<KpDataModel> getKpTableData(Map<String, dynamic> params) async {
    try {
      final response = await post(getKpDetails,

          // endPoint: astrologyBaseUrl,
          headers: await getJsonHeaderURL(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final kpData = kpDataModelFromJson(response.body);
        return kpData;
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error']}');
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PlanetlDetailModel> getPlanetDetailsAPI(
      Map<String, dynamic> params, String planetId) async {
    try {
      final response = await post('$getPlanetlDetails$planetId',
          // endPoint: astrologyBaseUrl,
          headers: await getJsonHeaderURL(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final planetData = planetlDetailModelFromJson(response.body);
        return planetData;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //dasha chart
  Future<DashaChartDataModel> getDashaChart(Map<String, dynamic> params) async {
    try {
      final response = await post(getDasha,
          // endPoint: astrologyBaseUrl,
          headers: await getJsonHeaderURL(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final kpData = dashaChartDataModelFromJson(response.body);
        return kpData;
      } else {
        debugPrint('Json: ${jsonDecode(response.body)['error']}');
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PratyantarDashaModel> getPratyantarDashaDetailsAPI(
      Map<String, dynamic> params, String planetId, String antarDasha) async {
    try {
      final response = await post('$getPratyantarDasha$planetId/$antarDasha',
          // endPoint: astrologyBaseUrl,
          headers: await getJsonHeaderURL(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final planetData = getPratyantarDashaModelFromJson(response.body);
        return planetData;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //Sookshma Dasha
  Future<SookshmaDashaModel> getSookshmaDashaDetailsAPI(
      Map<String, dynamic> params,
      String planetId,
      String antarDasha,
      String pratyantarName) async {
    try {
      final response =
          await post('$getSookshmaDasha$planetId/$antarDasha/$pratyantarName',
              // endPoint: astrologyBaseUrl,
              headers: await getJsonHeaderURL(),
              body: jsonEncode(params));
      if (response.statusCode == 200) {
        final planetData = sookshmaDashaModelFromJson(response.body);
        return planetData;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  //Pran Dasha
  Future<PranDashaModel> getPranDashaDetailsAPI(
      Map<String, dynamic> params,
      String planetId,
      String antarDasha,
      String pratyantarName,
      String sookshmaName) async {
    try {
      final response = await post(
          '$getPranDasha$planetId/$antarDasha/$pratyantarName/$sookshmaName',
          // endPoint: astrologyBaseUrl,
          headers: await getJsonHeaderURL(),
          body: jsonEncode(params));
      if (response.statusCode == 200) {
        final planetData = pranDashaModelFromJson(response.body);
        return planetData;
      } else {
        throw CustomException(
            json.decode(response.body)["error"][0]["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
