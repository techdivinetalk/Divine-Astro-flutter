import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/refer_astrologer/refer_astrologer_response.dart';
import 'package:flutter/material.dart';

class ReferAstrologerRepository extends ApiProvider {
  Future<ReferAstrologerResponse> referAstrologer(String json) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(referAnAstrologer,
          endPoint: "https://list.divinetalk.live/api/v3/", body: json);
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        final apiResponse = referAstrologerResponseFromJson(response.body);
        if (apiResponse.status?.code == successResponse &&
            apiResponse.status?.message == "success") {
          return apiResponse;
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
