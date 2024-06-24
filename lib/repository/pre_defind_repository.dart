import 'dart:convert';
import 'dart:io';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:flutter/material.dart';

import '../model/ApiNoticeModel.dart';
import '../utils/utils.dart';

class PreDefineRepository extends ApiProvider {
  Future<SpecialityList> loadPreDefineData() async {
    try {
      final response =
          await get(getSpecialityList, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        final specialityResponse = specialityListFromJson(response.body);
        if (specialityResponse.statusCode == successResponse &&
            specialityResponse.success!) {
          return specialityResponse;
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

  Future<ApiNoticeModel> postTermsConditionSubmit(
      Map<String, dynamic> param) async {
    try {
      final response = await post(addNoticeToAstrologer,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 201) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final editResponse =
              ApiNoticeModel.fromJson(jsonDecode(response.body));
          return editResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
