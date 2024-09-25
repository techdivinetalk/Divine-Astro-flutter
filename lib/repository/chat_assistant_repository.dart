import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/chat_assistant/CustomerDetailsResponse.dart';
import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../di/api_provider.dart';
import '../model/ChatAssCallModel.dart';
import '../model/CheckingAssistantCallModel.dart';
import '../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../model/chat_assistant/chat_assistant_chats_response.dart';

class ChatAssistantRepository extends ApiProvider {
  Future<ChatAssistantAstrologerListResponse> getChatAssistantAstrologerList(
      int page) async {
    try {
      final response = await get(getChatAssistAstrologers, queryParameters: {
        'page': page.toString(),
      });
      debugPrint('test_response --- ${response.body}');
      // if (response.statusCode == 200) {
      //   if (json.decode(response.body)["status_code"] ==
      //       HttpStatus.unauthorized) {
      //     Utils().handleStatusCodeUnauthorizedBackend();
      //     throw CustomException(json.decode(response.body)["error"]);
      //   } else {
      //     final getCategoriesData =
      //         ChatAssistantAstrologerListResponse.fromJson(
      //             jsonDecode(response.body));
      //     return getCategoriesData;
      //   }
      // } else {
      //   throw CustomException(json.decode(response.body)["error"]);
      // }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerList =
              ChatAssistantAstrologerListResponse.fromJson(
                  json.decode(response.body));
          if (assistantAstrologerList.statusCode == successResponse &&
              assistantAstrologerList.success!) {
            return assistantAstrologerList;
          } else {
            throw CustomException(assistantAstrologerList.message!);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }

      // if (response.statusCode == 200) {
      //   if (json.decode(response.body)["status_code"] ==
      //       HttpStatus.unauthorized) {
      //     debugPrint('test_response --- ${response.statusCode}');
      //
      //     Utils().handleStatusCodeUnauthorizedBackend();
      //     throw CustomException(json.decode(response.body)["error"]);
      //   } else if (json.decode(response.body)["status_code"] ==
      //       HttpStatus.notFound) {
      //     debugPrint('test_response --- ${response.statusCode}');
      //
      //     final assistantAstrologerList =
      //         ChatAssistantAstrologerListResponse.fromJson(
      //             json.decode(response.body));
      //     return assistantAstrologerList;
      //   } else {
      //     final assistantAstrologerList =
      //         ChatAssistantAstrologerListResponse.fromJson(
      //             json.decode(response.body));
      //     if (assistantAstrologerList.statusCode == successResponse &&
      //         assistantAstrologerList.success!) {
      //       return assistantAstrologerList;
      //     } else {
      //       throw CustomException(assistantAstrologerList.message!);
      //     }
      //   }
      // } else {
      //   throw CustomException(json.decode(response.body)["message"]);
      // }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<CustomerDetailsResponse> getConsulation(int page) async {
    try {
      final response = await get(getConsulationData, queryParameters: {
        'page': page.toString(),
      });
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          print("objectAssist ${json.decode(response.body)}");
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] == 500) {
          print("objectAssist ${json.decode(response.body)}");
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final customerDetailsResponse =
              CustomerDetailsResponse.fromJson(json.decode(response.body));
          if (customerDetailsResponse.statusCode == successResponse &&
              customerDetailsResponse.success) {
            return customerDetailsResponse;
          } else {
            print("objectAssist ${json.decode(response.body)}");
            throw CustomException(json.decode(response.body)["error"]);
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

  Future<ChatAssistChatResponse> getAstrologerChats(
      Map<String, dynamic> params) async {
    try {
      final response =
          await post(getChatAssistCustomerData, body: jsonEncode(params));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      log('response --- ${response.body}');
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final assistantAstrologerChatList =
              ChatAssistChatResponse.fromJson(json.decode(response.body));
          if (assistantAstrologerChatList.statusCode == successResponse &&
              assistantAstrologerChatList.success!) {
            return assistantAstrologerChatList;
          } else {
            throw CustomException(assistantAstrologerChatList.message!);
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

  Future<MessageTemplateResponse?> doGetMessageTemplateForChatAssist() async {
    try {
      final response = await post(getMessageTemplateForChatAssist);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if (response.statusCode == 200 && json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if (json.decode(response.body)["status_code"] == 200 &&
            json.decode(response.body)["success"] == true &&
            json.decode(response.body)["data"] != null) {
          return MessageTemplateResponse.fromJson(json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<CheckingAssistantCallModel?> checkingCallStatus(
      Map<String, dynamic> params) async {
    try {
      final response =
          await post(exotelCallInitiateMes, body: jsonEncode(params));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if ( //response.statusCode == 200 &&
          json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if ( //json.decode(response.body)["status_code"] == 200 &&
            //json.decode(response.body)["success"] == true &&
            json.decode(response.body) != null) {
          return CheckingAssistantCallModel.fromJson(
              json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ChatAssCallModel?> callToAstrologerRepo(
      Map<String, dynamic> params) async {
    try {
      final response =
          await post(exotelCallInitiateCustomer, body: jsonEncode(params));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if ( //response.statusCode == 200 &&
          json.decode(response.body) != null) {
        print("test_body: ${response.body}");
        print("test_body_decode: ${json.decode(response.body)}");

        if ( //json.decode(response.body)["status_code"] == 200 &&
            //json.decode(response.body)["success"] == true &&
            json.decode(response.body) != null) {
          return ChatAssCallModel.fromJson(json.decode(response.body));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
  // Future<ChatAssCallModel?> callToAstrologerRepo(
  //     Map<String, dynamic> params) async {
  //   try {
  //     final response = await post(exotelCallInitiateCustomer);
  //     if (response.statusCode == HttpStatus.unauthorized) {
  //       Utils().handleStatusCodeUnauthorizedServer();
  //     } else if (response.statusCode == HttpStatus.badRequest) {
  //       Utils().handleStatusCode400(response.body);
  //     }
  //
  //     final responseBody = json.decode(response.body);
  //     if (responseBody != null) {
  //       print("test_body: ${response.body}");
  //       print("test_body_decode: $responseBody");
  //
  //       if (responseBody["success"] == true &&
  //           responseBody["status_code"] == 200) {
  //         if (responseBody["data"] != null) {
  //           return ChatAssCallModel.fromJson(responseBody);
  //         } else {
  //           return null;
  //         }
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       return null;
  //     }
  //   } catch (e, s) {
  //     debugPrint("Error occurred: $e\n$s");
  //     rethrow;
  // }
  // }
}
