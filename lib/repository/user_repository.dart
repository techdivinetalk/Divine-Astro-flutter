import 'dart:convert';
import 'package:divine_astrologer/model/res_user_profile.dart';
import 'package:flutter/material.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/constant_details_model_class.dart';
import '../model/res_blocked_customers.dart';
import '../model/res_login.dart';
import '../model/res_review_ratings.dart';

class UserRepository extends ApiProvider {
  Future<ResLogin> userLogin(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(loginUrl, body: jsonEncode(param).toString());
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        final astrologerLoginModel =
            ResLogin.fromJson(json.decode(response.body));
        if (astrologerLoginModel.statusCode == successResponse &&
            astrologerLoginModel.success!) {
          return astrologerLoginModel;
        } else {
          throw CustomException("Unknown Error");
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<GetUserProfile> getProfileDetail(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(getProfileUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      //progressService.showProgressDialog(false);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final customerLoginModel =
              GetUserProfile.fromJson(json.decode(response.body));

          return customerLoginModel;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);

      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResReviewRatings> getReviewRatings(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(getReviewRatingUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      //progressService.showProgressDialog(false);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ResReviewRatings.fromJson(json.decode(response.body));
          return blockedCustomerList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResBlockedCustomers> getBlockedCustomerList(
      Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(blockCustomerlistUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      //progressService.showProgressDialog(false);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ResBlockedCustomers.fromJson(json.decode(response.body));
          if (blockedCustomerList.statusCode == successResponse &&
              blockedCustomerList.success!) {
            return blockedCustomerList;
          } else {
            throw CustomException("Unknown Error");
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResBlockedCustomers> blockUnblockCustomer(
      Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(blockCustomerUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ResBlockedCustomers.fromJson(json.decode(response.body));
          return blockedCustomerList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ConstantDetailsModelClass> constantDetailsData() async {
    //progressService.showProgressDialog(true);
    try {
      // debugPrint("Params $param");
      final response = await post(constantDetails, headers: await getJsonHeaderURL());
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        final constantDetailsModelClass = ConstantDetailsModelClass.fromJson(json.decode(response.body));
        if (constantDetailsModelClass.statusCode == successResponse && constantDetailsModelClass.success!) {
          return constantDetailsModelClass;
        } else {
          throw Get.snackbar("message", "",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.darkBlue,
              colorText: AppColors.white,
              duration: const Duration(seconds: 3));
        }
      } else {
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      preferenceService.erase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

}
