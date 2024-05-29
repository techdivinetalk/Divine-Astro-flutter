import 'dart:convert';

import 'package:divine_astrologer/model/order_history_model/feed_order_history.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../model/order_history_model/all_order_history.dart';
import '../model/order_history_model/call_order_history.dart';
import '../model/order_history_model/chat_order_history.dart';
import '../model/order_history_model/gift_order_history.dart';
import '../model/order_history_model/remedy_suggested_order_history.dart';

class OrderHistoryRepository extends ApiProvider {
  Future<AllOrderHistoryModelClass> getAllOrderHistory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<CallOrderHistoryModelClass> getCallOrderHistory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<ChatOrderHistoryModelClass> getChatOrderHistory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<FeedBackOrder> getFeedbackChatOrderHistory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final orderFeedHistoryModel =
          FeedBackOrder.fromJson(json.decode(response.body));
          if (orderFeedHistoryModel.statusCode == successResponse &&
              orderFeedHistoryModel.success!) {
            return orderFeedHistoryModel;
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

  Future<GiftOrderHistoryModelClass> getGiftOrderHistory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      print("Body :: ${jsonEncode(param)}");

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
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

  Future<RemedySuggestedOrderHistoryModelClass> getRemedySuggestedOrderHistory(
      Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(getOrderHistoryUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }

      debugPrint('Response: ${response.request}');
      if (response.statusCode == 200) {
        final orderHistoryShop =
            remedySuggestedOrderHistoryModelClassFromJson(response.body);
        if (orderHistoryShop.statusCode == successResponse &&
            orderHistoryShop.success!) {
          return orderHistoryShop;
        } else {
          throw CustomException(orderHistoryShop.message ?? "");
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
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
//       if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized || json.decode(response.body)["status_code"] ==
//                 HttpStatus.badRequest) {
//           Utils().handleStatusCodeUnauthorized();
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
