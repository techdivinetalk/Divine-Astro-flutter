// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:divine_astrologer/di/progress_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common/app_exception.dart';
import '../common/strings.dart';
import 'network_service.dart';
import 'shared_preference_service.dart';

class ApiProvider {
  static const String version = 'v7';
  final String baseUrl = "https://wakanda-api.divinetalk.live/admin/$version/";

  final String jsonHeaderName = "Content-Type";
  final String jsonCookieName = "Cookie";
  final String jsonHeaderValue = "application/json";
  final String jsonAuthenticationName = "Authorization";
  final int successResponse = 200;
  String _token = "";

  final String loginUrl = "astroLogin";
  final String getProfileUrl = "getAstrologerProfile";
  final String getReviewRatingUrl = "getReviewRating";
  final String blockCustomerlistUrl = "blockCustomerlist";
  final String blockCustomerUrl = "blockCustomer";
  final String getShopUrl = "getShop";
  final String getProductListUrl = "getProductList";
  final String getProductDetailsUrl = "getProductDetails";
  final String constantDetails = "constantDetails";
  final String getOrderHistoryUrl = "getOrderHistory";
  final String reviewReplyUrl = "reviewReply";
  final String astroNoticeBoard = "astroNoticeBoard";
  final String getSpecialityList = "getSpecialityList";
  final String updateProfileDetails = "updateProfileDetails";
  final String uploadAstroStories = "uploadAstroStories";
  final String deleteAccount = "deleteAccount";
  final String reportUserReview = "reportReview";
  final String getPerformanceData = "performance";
  final String getIntroPageDesc = "getIntroPageDesc";
  final String logout = "Logout";
  final String updateBankDetails = "updateBankDetails";
  final String getKundliData = "getKundliData";
  final String getHomePageData = "astroDashboard";
  final String agoraEndCall = "agoraEndCall";
  final String getWaitingListQueue="getWaitingListQueue";
  final String getImportantNumber="getImportantNumber";

  //Astro Internal API
  final String horoChartImageInt = "getChartImage/";
  final String getAstroDetailsInt = "getAstroDetails";
  final String getBirthDetailsInt = "getBirthDetails";
  final String getManglikDetailsInt = "getManglikDetails";
  final String getGeneralNakshatraReportInt = "getGeneralNakshatraReport";
  final String getKpDetails = "getKpDetails";
  final String getPlanetlDetails = "getPlanetlDetails/";
  final String getDasha = "getDasha";

  //Kundli APIs
  final String astrologyBaseUrl = "https://json.astrologyapi.com/v1/";
  final String astroDetails = "astro_details";
  final String birthDetails = "birth_details";
  final String kundliPrediction = "general_nakshatra_report";
  final String manglik = "manglik";
  final String kalsarpaDetails = "kalsarpa_details";
  final String sadhesatiStatus = "sadhesati_current_status";
  final String pitraDoshReport = "pitra_dosha_report";
  final String horoChartImage = "horo_chart_image/";

  //chat
  final String getChatList = "getChatList";
  final String chatAcceptAPI = "partner_chat_accept";
  final String endChatAPI = "end_chat";

  final String uploadAstrologerimage = "uploadAstrologerimage";

  //privacy policy & terms
  final String termsAndCondition = "termsAndCondition";
  final String privacyPolicy = "privacyPolicy";

  final String astroScheduleOnline = "astroScheduleOnline";

  //Basic Auth
  final String username = "625170";
  final String password = "4eb3e540da68887ac72d4d45d7da9906";

  ///ReferAn Astrologer Base
  final elasticDivineTalkBase = "https://crm-api.divinetalk.live/api/v1/";

  final referAnAstrologer = "testaddQuickLeadByApp";

  //
  final NetworkService networkManager = Get.find<NetworkService>();
  final ProgressService progressService = Get.find<ProgressService>();
  final SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  Map<String, String> getJsonHeader() {
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;

    return header;
  }

  Future<Map<String, String>> getJsonHeaderURL({int version = 6}) async {
    _token = await _getAuthToken();
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;
    header[jsonAuthenticationName] = 'Bearer $_token';
    header[jsonCookieName] = version == 6
        ? 'XSRF-TOKEN=eyJpdiI6IjhaSkFBQklkdXowbGsvWWw2ODNRZ3c9PSIsInZhbHVlIjoiN3FndjFHVVRZU2JjeWQ0ekdrVDBHTEdXYTJ5Z1Z5T3d2ODJ5MmpWaFdwMi9QV0I3L0RUcGdHQStxRWxDLzBHVW4vL25yT1Y3Z3R0TExzek16dTRvb3BtelpnY2UrYitzbW9DL21lZ1U4eUJQRGpYZXp5YmRMR0Z6Z3JPYkNUQTIiLCJtYWMiOiIwMjE0MjgxMGJiZDM4NmVkYjg5YjVmYmYxNDhkY2NjNGEzNTE0ZjU2ZTc4ODQxMzk3YWU5MjQ5NjA3YzdmZWVhIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6InhIc2EyV2YveDkyT0ZNUjJ5T3pFTGc9PSIsInZhbHVlIjoiYnZ2SElvSnVyUHhVTWxOTHRTSzlQNDlFYUJxT1A1Nkx1SDByVkl4bU1oS29NQm4vT1JJNTV5TlZEcnl0M1F1WS8vZFQ1UzRFN3pCekRpQklMTE56Y2NadnQyamlVVDY1OU01dlU5czhUYUlPZDh5TTJ6cENzWmhWVitaUGtnVUQiLCJtYWMiOiI5ZmIyMmY4Zjc3ZDg5ZWE1ZmFlNTZlNzVkNjE1OGUxYmZjZGExNDNmYjg4ZTg4MTdlMTUyZDM2NjQzMTIyN2IzIiwidGFnIjoiIn0%3D'
        : "XSRF-TOKEN=eyJpdiI6IjhaSkFBQklkdXowbGsvWWw2ODNRZ3c9PSIsInZhbHVlIjoiN3FndjFHVVRZU2JjeWQ0ekdrVDBHTEdXYTJ5Z1Z5T3d2ODJ5MmpWaFdwMi9QV0I3L0RUcGdHQStxRWxDLzBHVW4vL25yT1Y3Z3R0TExzek16dTRvb3BtelpnY2UrYitzbW9DL21lZ1U4eUJQRGpYZXp5YmRMR0Z6Z3JPYkNUQTIiLCJtYWMiOiIwMjE0MjgxMGJiZDM4NmVkYjg5YjVmYmYxNDhkY2NjNGEzNTE0ZjU2ZTc4ODQxMzk3YWU5MjQ5NjA3YzdmZWVhIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6InhIc2EyV2YveDkyT0ZNUjJ5T3pFTGc9PSIsInZhbHVlIjoiYnZ2SElvSnVyUHhVTWxOTHRTSzlQNDlFYUJxT1A1Nkx1SDByVkl4bU1oS29NQm4vT1JJNTV5TlZEcnl0M1F1WS8vZFQ1UzRFN3pCekRpQklMTE56Y2NadnQyamlVVDY1OU01dlU5czhUYUlPZDh5TTJ6cENzWmhWVitaUGtnVUQiLCJtYWMiOiI5ZmIyMmY4Zjc3ZDg5ZWE1ZmFlNTZlNzVkNjE1OGUxYmZjZGExNDNmYjg4ZTg4MTdlMTUyZDM2NjQzMTIyN2IzIiwidGFnIjoiIn0%3D";
    return header;
  }

  Future<Map<String, String>> getAuthorisedHeader() async {
    //if (_token.isEmpty) {
    _token = await _getAuthToken();
    //}
    var header = getJsonHeader();
    if (_token.isNotEmpty) {
      header[jsonAuthenticationName] = 'Bearer $_token';
    }
    log("Token is $_token");
    return header;
  }

  Future<Map<String, String>> getAuthorisedFormDataHeader() async {
    if (_token.isEmpty) {
      _token = await _getAuthToken();
    }
    var header = <String, String>{};
    if (_token.isNotEmpty) {
      header[jsonAuthenticationName] = 'Bearer $_token';
    }
    log("Token is $_token");
    return header;
  }

  Future<String> _getAuthToken() async {
    var token = preferenceService.getToken();
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  get(String url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      var response = await http
          .get(Uri.parse(baseUrl + url), headers: headers)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  delete(String url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      var response = await http
          .delete(Uri.parse(baseUrl + url), headers: headers)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  getWithPrams(Uri url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url:$baseUrl$url');
      var response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future<http.Response> post(String url,
      {String? endPoint,
      Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool closeDialogOnTimeout = true}) async {
    endPoint ??= baseUrl;
    headers ??= await getAuthorisedHeader();
    if (await networkManager.isConnected() ?? false) {
       log('url: $endPoint$url');
       log('body: $body');
      // log("headers: $headers");
      var response = await http
          .post(Uri.parse(endPoint + url),
              headers: headers, body: body, encoding: encoding)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
       log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool closeDialogOnTimeout = true}) async {
    headers ??= await getAuthorisedHeader();
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      log('body: $body');
      var response = await http
          .put(Uri.parse(baseUrl + url),
              headers: headers, body: body, encoding: encoding)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future uploadImage(
      Map<String, File> images, Map<String, dynamic> body, String url,
      {String type = "POST", Map<String, String>? headers}) async {
    if (await networkManager.isConnected() ?? false) {
      var uri = Uri.parse(baseUrl + url);
      debugPrint("url: $baseUrl$url");
      http.MultipartRequest request = http.MultipartRequest(type, uri);
      request.headers.addAll(headers ?? await getAuthorisedHeader());
      debugPrint("header : ${request.headers}");
      images.forEach((key, value) async {
        final multipartFile =
            await http.MultipartFile.fromPath(key, value.path);
        request.files.add(multipartFile);
      });
      body.forEach((key, value) {
        if (value is List) {
          int i = 0;
          for (var element in value) {
            request.fields['$key[$i]'] = jsonEncode(element);
            i += 1;
          }
        } else {
          request.fields[key] = value.toString();
        }
      });
      log("request : $request");
      final response = await http.Response.fromStream(await request.send());
      log(response.body);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Map<String, String> getAstrologyHeader() {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    return headers;
  }
}
