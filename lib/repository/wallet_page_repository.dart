import 'dart:convert';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/wallet/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletListRepo extends ApiProvider {

  Future<PayoutDetails> walletPayOutDetails() async {
    try {
      final response = await post(walletPayout);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final walletPayoutList =
          PayoutDetails.fromJson(json.decode(response.body));
          if (walletPayoutList.statusCode == successResponse &&
              walletPayoutList.success!) {
            return walletPayoutList;
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