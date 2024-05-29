import 'dart:convert';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/res_get_shop.dart';
import '../model/res_product_detail.dart';
import '../model/res_product_list.dart';
import '../model/shop_model_response.dart';

class ShopRepository extends ApiProvider {
  // Future<ResOrderHistory> getOrderHistory(Map<String, dynamic> param) async {
  //   try {
  //     final response = await post(getOrderHistoryUrl,
  //         body: jsonEncode(param).toString(),
  //         headers: await getJsonHeaderURL());
  //
  //     if (response.statusCode == 200) {
  //       if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized || json.decode(response.body)["status_code"] ==
  //               HttpStatus.badRequest) {
  // Utils().handleStatusCodeUnauthorized();
  //         throw CustomException(json.decode(response.body)["error"]);
  //       } else {
  //         final orderHistoryModel =
  //             ResOrderHistory.fromJson(json.decode(response.body));
  //         if (orderHistoryModel.statusCode == successResponse &&
  //             orderHistoryModel.success!) {
  //           return orderHistoryModel;
  //         } else {
  //           throw CustomException(json.decode(response.body)["message"]);
  //         }
  //       }
  //     } else {
  //       throw CustomException(json.decode(response.body)["message"]);
  //     }
  //   } catch (e, s) {
  //     debugPrint("we got $e $s");
  //     rethrow;
  //   }
  // }


  Future<ShopModel> getShopList(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(getShopUrl, body: jsonEncode(param).toString());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final shopModel = shopModelFromJson(response.body);
          if (shopModel.statusCode == successResponse && shopModel.success!) {
            return shopModel;
          } else {
            throw CustomException(shopModel.message!);
          }
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

  Future<ResGetShop> getShopData(Map<String, dynamic> param) async {
    try {
      final response = await post(getShopUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final shopModel = ResGetShop.fromJson(json.decode(response.body));
          if (shopModel.statusCode == successResponse && shopModel.success!) {
            return shopModel;
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

  Future<ResProductList> getProductList(Map<String, dynamic> param) async {
    try {
      final response = await post(getProductListUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final shopModel = ResProductList.fromJson(json.decode(response.body));
          if (shopModel.statusCode == successResponse && shopModel.success!) {
            return shopModel;
          } else {
            throw CustomException("Unknown Error");
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

  Future<ResProductDetail> getProductDetail(Map<String, dynamic> param) async {
    try {
      final response = await post(getProductDetailsUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final shopModel =
              ResProductDetail.fromJson(json.decode(response.body));
          if (shopModel.statusCode == successResponse && shopModel.success!) {
            return shopModel;
          } else {
            throw CustomException("Unknown Error");
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

  Future<SaveRemediesResponse> saveRemedies(Map<String, dynamic> param) async {
    try {
      final response = await post(saveRemediesUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final responseModel =
          SaveRemediesResponse.fromJson(json.decode(response.body));
          if (responseModel.statusCode == successResponse && responseModel.success!) {
            return responseModel;
          } else {
            throw CustomException("Unknown Error");
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

  Future<SaveRemediesResponse> saveRemediesForChatAssist(Map<String, dynamic> param) async {
    try {
      final response = await post(saveRemediesChatAssistUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final responseModel =
          SaveRemediesResponse.fromJson(json.decode(response.body));
          if (responseModel.statusCode == successResponse && responseModel.success!) {
            return responseModel;
          } else {
            throw CustomException("Unknown Error");
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
