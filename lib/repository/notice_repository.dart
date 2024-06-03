import 'dart:convert';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/astro_schedule_response.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class NoticeRepository extends ApiProvider {
  Future<NoticeResponse> noticeAPi() async {
    try {
      final response =
          await get(getAstroAllNotice, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        final noticeResponse = noticeResponseFromJson(response.body);
        if (noticeResponse.statusCode == successResponse &&
            noticeResponse.success!) {
          return noticeResponse;
        } else {
          throw CustomException(json.decode(response.body));
        }
      } else {
        throw CustomException(json.decode(response.body));
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<AstroScheduleResponse> astroScheduleOnlineAPI(
      Map<String, dynamic> param) async {
    try {
      final response = await post(
        astroScheduleOnline,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        final astroScheduleResponse =
            astroScheduleResponseFromJson(response.body);
        if (astroScheduleResponse.statusCode == successResponse &&
            astroScheduleResponse.success) {
          return astroScheduleResponse;
        } else {
          throw CustomException(json.decode(response.body)["message"]);
        }
      } else {
        throw CustomException(json.decode(response.body));
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
