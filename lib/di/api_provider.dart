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
  final String baseUrl = "https://wakanda-api.divinetalk.live/admin/v6/";
  static String imageBaseUrl = "https://divinenew.s3.ap-south-1.amazonaws.com/";

  final String jsonHeaderName = "Content-Type";
  final String jsonCookietName = "Cookie";
  final String jsonHeaderValue = "application/json";
  final String jsonAuthenticationName = "Authorization";
  final int successResponse = 200;
  String _token = "";
  //AWS
  final String awsAccessKey = "AKIA2IL7UUQTRWRVLKEB";
  final String awsSecretKey = "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";
  final String awsBucket = "divinenew";
  final String awsRegion = "ap-south-1";

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

  Future<Map<String, String>> getJsonHeaderURL() async {
    _token = await _getAuthToken();
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;
    header[jsonAuthenticationName] = 'Bearer $_token';
    header[jsonCookietName] =
        'XSRF-TOKEN=eyJpdiI6IlVSd20yb0dvNHc1K3JRa0cwbnNINVE9PSIsInZhbHVlIjoiNzBHZlFYeXJ2eWh1RUtBUDgrNlY4U2tEb2tBZjVxazJqcFF0WmJta0FDTDdRSXc1OXFmZGppRGpTM0pldmxOZ0RleFFkYVBUMmVFTUpuVDl2Ty9aa3lYYnN4c2xZa0oxNHFrM2ZWSXBvOWFsNVJHVEVERWwzOFMwWDMwczRWUGUiLCJtYWMiOiI1MDMzZWFhOTk4Mzg2YmRmYTRiNDNmNTU5NTIxMmIzMzEzZmNhMjM4YzcxZmQwZGRhYzA0N2FkZmUxMmZkNDkwIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IkVHMFFFamxaQUxtMGhYek5tSS9oTVE9PSIsInZhbHVlIjoiWXBsS1pDZ3lERmhpYnJzNzRiUlZYYVdHcllHTEhZZ0JsUkpTVmFHTnpNY0YzdFl3bUZGZyt6WFZNNmlmMlRXQ0g0ZDB5TkIzRWYwUjVjK2FzZE1lR3BYUkpkN0ErMnZadDdveDN6NnQyQ2R6Vml5ZHdjWTFFQmkyb0dWVnQ1Q2EiLCJtYWMiOiJjMGQ0YWY4ZWRmMWQ4Zjk2MzU1MjQ0YzRmNDFiYzFjZWRlZjU5ZTBlZjIwNDQ2OWNhMzI3MmQ1NWMzOTRjMjUxIiwidGFnIjoiIn0%3D';
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
      log("headers: $headers");
      var response = await http
          .post(Uri.parse(endPoint + url),
              headers: headers, body: body, encoding: encoding)
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
