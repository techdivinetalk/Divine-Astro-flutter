import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/order_history_model/all_order_history.dart';
import '../model/order_history_model/call_order_history.dart';
import '../model/order_history_model/chat_order_history.dart';
import '../model/order_history_model/gift_order_history.dart';
import '../model/order_history_model/remedy_suggested_order_history.dart';
import 'package:http/http.dart' as http;

class OrderHistoryRepository extends ApiProvider {

  Future<AllOrderHistoryModelClass> getAllOrderHistory(Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final orderHistoryModel =
          AllOrderHistoryModelClass.fromJson(json.decode(response.body));
          if (orderHistoryModel.statusCode == successResponse &&
              orderHistoryModel.success!) {
            return orderHistoryModel;
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


  Future<CallOrderHistoryModelClass> getCallOrderHistory(Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final orderHistoryModel =
          CallOrderHistoryModelClass.fromJson(json.decode(response.body));
          if (orderHistoryModel.statusCode == successResponse &&
              orderHistoryModel.success!) {
            return orderHistoryModel;
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

  Future<ChatOrderHistoryModelClass> getChatOrderHistory(Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final orderHistoryModel =
          ChatOrderHistoryModelClass.fromJson(json.decode(response.body));
          if (orderHistoryModel.statusCode == successResponse &&
              orderHistoryModel.success!) {
            return orderHistoryModel;
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

  Future<GiftOrderHistoryModelClass> getGiftOrderHistory(Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final orderHistoryModel =
          GiftOrderHistoryModelClass.fromJson(json.decode(response.body));
          if (orderHistoryModel.statusCode == successResponse &&
              orderHistoryModel.success!) {
            return orderHistoryModel;
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


  Future<RemedySuggestedOrderHistoryModelClass> getRemedySuggestedOrderHistory(Map<String, dynamic> param, Map<String, String>? header) async {
    //progressService.showProgressDialog(true);
    try {
      // final response = await post(getOrderHistoryUrl, endPoint: baseUrlv7, body: jsonEncode(param), headers: await getJsonHeaderURL());
      var response = await http
          .post(Uri.parse("https://wakanda-api.divinetalk.live/admin/v7/getOrderHistory"),
          headers: header, body: jsonEncode(param));

      print('Response: ${response.request}');
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        final orderHistoryShop = remedySuggestedOrderHistoryModelClassFromJson(response.body);
        if (orderHistoryShop.statusCode == successResponse && orderHistoryShop.success!) {
          return orderHistoryShop;
        } else {
          print("Error-=-=->${orderHistoryShop.message!}");
          throw CustomException(orderHistoryShop.message!);
        }
      } else {
        print("ErrorData-->"+ json.decode(response.body)["message"]);
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  // Future<RemedySuggestedOrderHistoryModelClass> getRemedySuggestedOrderHistory(Map<String, dynamic> param) async {
  //   try {
  //     final response = await post(getOrderHistoryUrl,endPoint: baseUrlv7,
  //         body: jsonEncode(param).toString(),
  //         headers: await getJsonHeaderURL());
  //
  //     // print("-->"+ response.request.toString());
  //     // print("-->"+ response.body.toString());
  //     if (response.statusCode == 200) {
  //       if (json.decode(response.body)["status_code"] == 401) {
  //         preferenceService.erase();
  //         Get.offNamed(RouteName.login);
  //         throw CustomException(json.decode(response.body)["error"]);
  //       } else {
  //         final orderHistoryModel =
  //         RemedySuggestedOrderHistoryModelClass.fromJson(json.decode(response.body));
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

}
