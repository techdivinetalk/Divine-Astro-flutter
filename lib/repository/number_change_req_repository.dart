import 'dart:convert';
import 'package:divine_astrologer/model/number_change_request_model/verify_otp_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/model/number_change_request_model/number_change_response_model.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class NumberChangeReqRepository extends ApiProvider {
  Future<NumberChangeResponse> sendOtpForNumberChange(
      Map<String, dynamic> param) async {
    try {
      final response = await post(
        sendOtpNumberChange,
        headers: await getJsonHeaderURL(version: 7),
        body: jsonEncode(param),
      );

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        }  else {
          final numberChangeResponse =
              NumberChangeResponse.fromJson(json.decode(response.body));
          if (numberChangeResponse.statusCode == successResponse &&
              numberChangeResponse.success!) {
            return numberChangeResponse;
          } else {
            throw CustomException(json.decode(response.body)["message"]);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<VerifyOtpResponse> verifyOtpAPi(Map<String, dynamic> param) async {
    try {
      final response = await post(
        verifyOtpNumberChange,
        headers: await getJsonHeaderURL(version: 7),
        body: jsonEncode(param),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final verifyOtpResponse =
              VerifyOtpResponse.fromJson(json.decode(response.body));
          if (verifyOtpResponse.statusCode == successResponse &&
              verifyOtpResponse.success!) {
            return verifyOtpResponse;
          } else {
            throw CustomException(json.decode(response.body)["message"]);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
