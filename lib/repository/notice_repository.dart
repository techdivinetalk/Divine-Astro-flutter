import 'dart:convert';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:flutter/material.dart';

class NoticeRepository extends ApiProvider {
  Future<NoticeResponse> noticeAPi() async {
    try {
      final response =
          await get(astroNoticeBoard, headers: await getJsonHeaderURL());

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
      preferenceService.erase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
