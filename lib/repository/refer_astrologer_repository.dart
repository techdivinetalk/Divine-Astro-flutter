import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/refer_astrologer/refer_astrologer_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';

class ReferAstrologerRepository extends ApiProvider {
  Future<ReferAstrologerResponse> referAstrologer(String json) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(referAnAstrologer,
          // endPoint: "https://list.divinetalk.live/api/v3/",
          endPoint: "http://4.240.97.131:8081/api/v3/",
          body: json,
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        final apiResponse = referAstrologerResponseFromJson(response.body);
        if (apiResponse.status?.code == successResponse &&
            apiResponse.status?.message == "Success") {
          final d = referAstrologerResponseFromJson(response.body);

          return d;
        } else {
          throw CustomException("Unknown Error");
        }
      } else if (response.statusCode == 400) {
        return referAstrologerResponseFromJson(response.body);
      } else {
        throw CustomException(response.body);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
