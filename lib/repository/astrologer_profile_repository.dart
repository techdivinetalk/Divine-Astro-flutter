import 'dart:convert';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:divine_astrologer/model/live/blocked_customer_list_res.dart';
import 'package:divine_astrologer/model/live/blocked_customer_res.dart';
import 'package:divine_astrologer/model/live/notice_board_res.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AstrologerProfileRepository extends ApiProvider {
  Future<GiftResponse> getAllGiftsAPI({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GiftResponse data = GiftResponse();
    try {
      final response = await get(getAllGifts);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = GiftResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("getAllGiftsAPI(): Exception caught: error: $error");
      debugPrint("getAllGiftsAPI(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<GiftResponse>.value(data);
  }

  Future<BlockedCustomerListRes> blockedCustomerListAPI({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    BlockedCustomerListRes data = BlockedCustomerListRes();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(blockCustomerlist, body: requestBody);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = BlockedCustomerListRes.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("blockedCustomerListAPI(): Exception caught: error: $error");
      debugPrint("blockedCustomerListAPI(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<BlockedCustomerListRes>.value(data);
  }

  Future<BlockedCustomerRes> blockedCustomerAPI({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    BlockedCustomerRes data = BlockedCustomerRes();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(blockCustomer, body: requestBody);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = BlockedCustomerRes.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("blockedCustomerAPI(): Exception caught: error: $error");
      debugPrint("blockedCustomerAPI(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<BlockedCustomerRes>.value(data);
  }

  Future<NoticeBoardRes> noticeBoardAPI({
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    NoticeBoardRes data = NoticeBoardRes();
    try {
      final response = await get(getAstroAllNoticeType2);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = NoticeBoardRes.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("noticeBoardAPI(): Exception caught: error: $error");
      debugPrint("noticeBoardAPI(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<NoticeBoardRes>.value(data);
  }

  Future<String> endLiveApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    String data = "";
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(agoraEndCall, body: requestBody);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = "";
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("endLiveApi(): Exception caught: error: $error");
      debugPrint("endLiveApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<String>.value(data);
  }
}
