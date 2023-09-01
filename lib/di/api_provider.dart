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
  final String baseUrlv7 = "https://wakanda-api.divinetalk.live/admin/v7/";
  static String imageBaseUrl = "https://divinenew.s3.ap-south-1.amazonaws.com/";

  final String jsonHeaderName = "Content-Type";
  final String jsonCookietName = "Cookie";
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

  //Basic Auth
  final String username = "625170";
  final String password = "4eb3e540da68887ac72d4d45d7da9906";

  ///ReferAn Astrologer Base
  final elasticDivineTalkBase = "https://crm-api.divinetalk.live/api/v1/";

  final referAnAstrologer = "testaddQuickLeadByApp";

  //
  final NetworkService networkManager = Get.find<NetworkService>();
  final ProgressService progressService = Get.find<ProgressService>();
  final SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();

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
    header[jsonCookietName] = version == 6
        ? 'XSRF-TOKEN=eyJpdiI6ImRHY1FIZ2J1eS8wenMvQlk0cWM5R1E9PSIsInZhbHVlIjoiNXZsMHVTZ1c1bEtSUUF3eVdvTDVpdy9QL1FpY0g4S0Nncit5OUw2YlhVbW5uVXhBNTNORzdZdmEyVVkra0hBMjFaTXJ5YWdHTHlwMG5BWFlaZGVMWDZSN3AwUUxIUEMxQ1ZiZmxOWkZJaXhJeStMUzBsZnhLeWd4MW5XMCtMNnkiLCJtYWMiOiI5YjkxY2VhNGE0OGE2OTY3NzhmZTVlMjQ4M2I4MTBlMjA1MTdjNGRlZjdmYzFlNzMzYTNkMGRiMjM2NjM1N2EzIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6Iml6THowdW85NUZxMzZPTldmV2JySEE9PSIsInZhbHVlIjoiNklBTHJxVi9Eek1lWDNkVnVhNGphdHRyZ2tFQXlCVWFTeFE4b2FJUTZqSlpuV0xtdkJTSmdtVFFkMWtLYi9FejRmZWE5Wis1azFXaG1UMnNVOE01UE1CNVBSc2JVVkR3WnAxeWc4bTF6WU1Xb3drNmpvREJMM1UxS0xzNTdFaXYiLCJtYWMiOiI4NmQxNzliNmQ0MzlhNTNiYzAwODgwMjU5NWU4ZTg0MzAxZjE3YWE3ODA2NjhmNjRiYjg2YmVjNmM2NjlkZWMzIiwidGFnIjoiIn0%3D'
        : "XSRF-TOKEN=eyJpdiI6InhaMncwZnBRSjhBMWs2Wm9sYjM4ZUE9PSIsInZhbHVlIjoiZVFDeTA2R29VbElhV3B5V2Z4N1dXQ0NidWwySzBFVFZaRENsdGJKMkk0azVXM3ZCcEdDblFIeEdYejhkcURqRi9wRHlxQnRPTEtYRGJYVVhTZGNHbGhZWGVKMjFndjZpQ2xOdEdGODl4TlY3dXdvZlA3M09YdHpZdm0rM21YYS8iLCJtYWMiOiIyYmVlOTk5M2IzMjIzMDRmYzRkN2ZhZTFkYjJjODNkNGUzMjhlNjJhOWQxZjhjMDA1YTAxNzVmMWE4MGJkNjAwIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IjQ2d0NTSUdOcStUeHYyc29kSWFsVnc9PSIsInZhbHVlIjoiMTlnVitFQUtvdmw1U2lYaFRDcEpIdjR6N2dSbUd1VFRGQ1I3WGFaRk51Y1JVU3psczdVRXZCQWd4ZUl5VENaK2RJNlZ4ZmltZHFaajU3SXJydlN0QzhvVnlaczNvbkxsYVo4bnp0VU5HR0VmaFNNbUkwRklvUmJRUGZzV1NtdXAiLCJtYWMiOiI4OTk1MDUyMDMzZWU3NTA2MWJiNTM3M2JmZDdhMDk5NTI0NjA1NjE3MmI2NWMxMmM4YmEyYTk2MWFjN2U1MjU1IiwidGFnIjoiIn0%3D ";
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

  get(String url, {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
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

  delete(String url, {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
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

  getWithPrams(Uri url, {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url:$baseUrl$url');
      var response =
          await http.get(url, headers: headers).timeout(const Duration(seconds: 15), onTimeout: () {
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
      log("headers: $headers");
      var response = await http
          .post(Uri.parse(endPoint + url), headers: headers, body: body, encoding: encoding)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      // log('response: ${response.body}');
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
          .put(Uri.parse(baseUrl + url), headers: headers, body: body, encoding: encoding)
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

  Future uploadImage(Map<String, File> images, Map<String, dynamic> body, String url,
      {String type = "POST", Map<String, String>? headers}) async {
    if (await networkManager.isConnected() ?? false) {
      var uri = Uri.parse(baseUrl + url);
      debugPrint("url: $baseUrl$url");
      http.MultipartRequest request = http.MultipartRequest(type, uri);
      request.headers.addAll(headers ?? await getAuthorisedHeader());
      debugPrint("header : ${request.headers}");
      images.forEach((key, value) async {
        final multipartFile = await http.MultipartFile.fromPath(key, value.path);
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
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    return headers;
  }
}
