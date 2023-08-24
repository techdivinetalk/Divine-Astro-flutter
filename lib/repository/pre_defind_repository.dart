import 'dart:convert';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:flutter/material.dart';

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
}
