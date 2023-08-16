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
  final String loginUrl = "astroLogin";
  final String getProfileUrl = "getAstrologerProfile";
  final String getReviewRating = "getReviewRating";
  final String blockCustomerlist = "blockCustomerlist";
  final String blockCustomer = "blockCustomer";
  final String constantDetails = "constantDetails";

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
        'XSRF-TOKEN=eyJpdiI6IlgwVmd1bkhGSHY5Q0NleDZtN3R6dmc9PSIsInZhbHVlIjoiQ1FteHVNNVg3RnFzMHkxS0JUL3g3dG94TEIvTktBU29CYU8xRmtoajRYZndQTnNsQ1k5YjNUMjlvRWlTS25Od3VhVUZWdHFMRVZSeU9GQ1kybXZmWnplZHZMTXZKTjUrRzkreGZteHZVT2gzUzd4ZzgzNWVqbzI3TTlHUDg2R1MiLCJtYWMiOiIzMDA0YmY4MmJiZTVjY2NhMzVlOTA2NWY2NjAwOGQzOTVkNDA3NjY3YWYzZmUwMGUyMWQ0OGU3ZTM1OTIzOTE0IiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IkxLMk5HUm5qWGoxV1RVT0REcDVoNWc9PSIsInZhbHVlIjoiT0JtbEU1cExneTdxUENOZWovaHB3ajMvdmRkQ24zNC9lT3BSL3BYTjJndmFNR3NPcnkrejRXM1V6bytEd00zRjNVNFlCeEdVd2NacTlEbUVXNE1SYUpNbFBkcUF1bWZ2V0oxakRvd0ZpaVFZWHZZNSt6bE1BMVk1TnUwNWJCbmoiLCJtYWMiOiJjZjNkYTQ0YzAzZTA4YzBlOTczZmRjZjIyYzYwMWI1N2UzOGUwNDA1NTdhZGVjZjg0MzUzMmUwNjNlZmY5OWEwIiwidGFnIjoiIn0%3D';
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
}
