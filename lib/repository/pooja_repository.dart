import 'dart:convert';

import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/route_manager.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja/pooja_module_detail_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja/pooja_module_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/add_user_address_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/delete_user_address_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_booked_pooja_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_pooja_addones_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_pooja_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_single_pooja_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/get_user_address_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/insufficient_balance_model.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/update_user_address_response.dart';
import '../screens/chat_assistance/chat_message/widgets/product/pooja/pooja_dharam/wallet_recharge_response.dart';


class PoojaRepository extends ApiProvider {
  Future<PoojaModuleResponse> getPoojaData() async {
    try {
      final response = await post(
          'https://occultism-gleams.000webhostapp.com/pooja.php',
          endPoint: '');
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
          final apiResponse =
              PoojaModuleResponse.fromJson(json.decode(response.body));
          if (apiResponse.events != null || apiResponse.events!.isNotEmpty) {
            return apiResponse;
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

  Future<PoojaModuleDetailResponse> getPoojaDetailData() async {
    try {
      final response = await post(
          'https://occultism-gleams.000webhostapp.com/poojadetail',
          endPoint: '');
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      print("--------- pooja detail response ------------ ${json.encode(response.body)}");
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"]  == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final apiResponse =
              PoojaModuleDetailResponse.fromJson(json.decode(response.body));
          if (apiResponse.statusCode == 200) {
            return apiResponse;
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

  // Dharam
  Future<GetPoojaResponse> getPoojaApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GetPoojaResponse data = GetPoojaResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await get(getPooja);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = GetPoojaResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("getPoojaApi(): Exception caught: error: $error");
      debugPrint("getPoojaApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<GetPoojaResponse>.value(data);
  }

  Future<GetBookedPoojaResponse> getBookedPoojaApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GetBookedPoojaResponse data = GetBookedPoojaResponse();
    // try {
    //   final String requestBody = jsonEncode(params);
    //   final response = await post(getBookedPooja, body: requestBody);
    //   final Map<String, dynamic> responseBody = json.decode(response.body);
    //   if (response.statusCode == HttpStatus.ok) {
    //     if (responseBody["status_code"] == HttpStatus.ok) {
    //       data = GetBookedPoojaResponse.fromJson(responseBody);
    //       successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
    //     } else if (responseBody["status_code"] == HttpStatus.unauthorized || json.decode(response.body)["status_code"] ==
    //             HttpStatus.badRequest) {
    // Utils().handleStatusCodeUnauthorized();
    //     } else {
    //       failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
    //     }
    //   } else {
    //     failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
    //   }
    // } on Exception catch (error, stack) {
    //   debugPrint("getBookedPoojaApi(): Exception caught: error: $error");
    //   debugPrint("getBookedPoojaApi(): Exception caught: stack: $stack");
    //   failureCallBack("Unknown Error Occurred");
    // }
    return Future<GetBookedPoojaResponse>.value(data);
  }

  Future<GetSinglePoojaResponse> getSinglePoojaApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GetSinglePoojaResponse data = GetSinglePoojaResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(getSinglePooja, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = GetSinglePoojaResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("getSinglePoojaApi(): Exception caught: error: $error");
      debugPrint("getSinglePoojaApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<GetSinglePoojaResponse>.value(data);
  }

  Future<GetPoojaAddOnesResponse> getPoojaAddOnesApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GetPoojaAddOnesResponse data = GetPoojaAddOnesResponse();
    // try {
    //   final String requestBody = jsonEncode(params);
    //   final response = await post(getPoojaAddOns, body: requestBody);
    //   final Map<String, dynamic> responseBody = json.decode(response.body);
    //   if (response.statusCode == HttpStatus.ok) {
    //     if (responseBody["status_code"] == HttpStatus.ok) {
    //       data = GetPoojaAddOnesResponse.fromJson(responseBody);
    //       successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
    //     } else if (responseBody["status_code"] == HttpStatus.unauthorized || json.decode(response.body)["status_code"] ==
    //             HttpStatus.badRequest) {
    // Utils().handleStatusCodeUnauthorized();
    //     } else {
    //       failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
    //     }
    //   } else {
    //     failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
    //   }
    // } on Exception catch (error, stack) {
    //   debugPrint("getPoojaAddOnesApi(): Exception caught: error: $error");
    //   debugPrint("getPoojaAddOnesApi(): Exception caught: stack: $stack");
    //   failureCallBack("Unknown Error Occurred");
    // }
    return Future<GetPoojaAddOnesResponse>.value(data);
  }

  Future<GetUserAddressResponse> getUserAddressApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    GetUserAddressResponse data = GetUserAddressResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(getUserAddressForPooja, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = GetUserAddressResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("getUserAddressApi(): Exception caught: error: $error");
      debugPrint("getUserAddressApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<GetUserAddressResponse>.value(data);
  }

  Future<AddUserAddressResponse> addUserAddressApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    AddUserAddressResponse data = AddUserAddressResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(addUserAddressForPooja, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = AddUserAddressResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("addUserAddressApi(): Exception caught: error: $error");
      debugPrint("addUserAddressApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<AddUserAddressResponse>.value(data);
  }

  Future<UpdateUserAddressResponse> updateUserAddressApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    UpdateUserAddressResponse data = UpdateUserAddressResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(updateUserAddressForPooja, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = UpdateUserAddressResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("updateUserAddressApi(): Exception caught: error: $error");
      debugPrint("updateUserAddressApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<UpdateUserAddressResponse>.value(data);
  }

  Future<DeleteUserAddressResponse> deleteUserAddressApi({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    DeleteUserAddressResponse data = DeleteUserAddressResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(deleteUserAddressForPooja, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = DeleteUserAddressResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("deleteUserAddressApi(): Exception caught: error: $error");
      debugPrint("deleteUserAddressApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<DeleteUserAddressResponse>.value(data);
  }

  Future<WalletRecharge> walletRechargeApi({
    required Map<String, dynamic> params,
    required Function(InsufficientBalModel balModel) needRecharge,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    WalletRecharge data = WalletRecharge();
    try {
      final String requestBody = jsonEncode(params);
      print("$params");
      final response = await post(generateOrderAPI, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = WalletRecharge.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == 800) {
          InsufficientBalModel balModel = InsufficientBalModel();
          balModel = InsufficientBalModel.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
          needRecharge(balModel);
        } else if (responseBody["status_code"] == HttpStatus.unauthorized ||
            json.decode(response.body)["status_code"] ==
                HttpStatus.badRequest) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("walletRechargeApi(): Exception caught: error: $error");
      debugPrint("walletRechargeApi(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<WalletRecharge>.value(data);
  }
}
