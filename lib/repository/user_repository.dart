import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/ChatOrderResponse.dart';
import 'package:divine_astrologer/model/leave/LeaveStatusModel.dart';
import 'package:divine_astrologer/model/leave/LeaveSubmitModel.dart';
import 'package:divine_astrologer/model/log_out_response.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/model/pivacy_policy_model.dart';
import 'package:divine_astrologer/model/res_reply_review.dart';
import 'package:divine_astrologer/model/res_user_profile.dart';
import 'package:divine_astrologer/model/terms_and_condition_model.dart';
import 'package:divine_astrologer/model/update_bank_response.dart';
import 'package:divine_astrologer/model/update_offer_type_response.dart';
import 'package:divine_astrologer/model/update_profile_response.dart';
import 'package:divine_astrologer/model/update_session_type_response.dart';
import 'package:divine_astrologer/model/upload_image_model.dart';
import 'package:divine_astrologer/model/upload_story_response.dart';
import 'package:divine_astrologer/screens/add_puja/model/puja_product_categories_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/screens/puja/model/add_edit_puja_model.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/screens/remedies/model/remedies_model.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../common/app_exception.dart';
import '../common/common_functions.dart';
import '../di/api_provider.dart';
import '../model/AddSupportIssueDataModel.dart';
import '../model/AllFinancialIssuesModel.dart';
import '../model/AllSupportIssueModel.dart';
import '../model/FinancialCreateIssueModel.dart';
import '../model/PassBookDataModel.dart';
import '../model/TechnicalIssuesData.dart';
import '../model/TechnicalSupport.dart';
import "../model/blocked_customers_response.dart";
import '../model/cityDataModel.dart';
import '../model/constant_details_model_class.dart';
import '../model/delete_customer_model_class.dart';
import '../model/leave/LeaveCancelModel.dart';
import '../model/leave/LeaveReasonsModel.dart';
import '../model/report_review_model_class.dart';
import '../model/res_blocked_customers.dart';
import '../model/res_login.dart';
import '../model/res_review_ratings.dart';
import '../model/resignation/ResignationCancelModel.dart';
import '../model/resignation/ResignationReasonModel.dart';
import '../model/resignation/ResignationSubmitModel.dart';
import '../model/resignation/Resignation_status_model.dart';
import '../model/send_feed_back_model.dart';
import '../model/send_otp.dart';
import '../model/verify_otp.dart';
import '../model/view_training_video_model.dart';

class UserRepository extends ApiProvider {
  Future sentOtp(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(
        sendOtp,
        body: jsonEncode(param).toString(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      print(response.statusCode);
      print("response.statusCode");
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else if (json.decode(response.body)["status_code"] == 400) {
          preferenceService.erase();
          divineSnackBar(
              data: "Astrologer Not registered, Contact Admin",
              color: appColors.redColor,
              duration: const Duration(milliseconds: 1000));
          // Get.offNamed(RouteName.login);
          //  throw CustomException(json.decode(response.body)["message"]);
        } else {
          print(jsonDecode(response.body));
          SendOtpModel sendOtpModel =
              SendOtpModel.fromJson(jsonDecode(response.body));

          if (sendOtpModel.statusCode == successResponse &&
              sendOtpModel.success!) {
            return sendOtpModel;
          } else {
            throw CustomException(sendOtpModel.message!);
          }
        }
      } else if (response.statusCode == 429) {
        SendOtpModel sendOtpModel =
            SendOtpModel.fromJson(jsonDecode(response.body));
        if (sendOtpModel.statusCode == 429) {
          showCupertinoModalPopup(
            barrierColor: appColors.darkBlue.withOpacity(0.5),
            context: Get.context!,
            builder: (context) =>
                ManyTimeExException(message: sendOtpModel.message),
          );
        }
      } else {
        final errorMessage =
            SendOtpModel.fromJson(jsonDecode(response.body)).message;

        if (errorMessage!
            .contains("Too many requests. Please try again after")) {
          throw OtpInvalidTimerException(errorMessage);
        } else {
          throw CustomException(errorMessage);
        }
      }
    } catch (e, s) {
      //progressService.showProgressDialog(false);
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<VerifyOtpModel> verifyOtp(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response =
          await post(verifyOtpUrl, body: jsonEncode(param).toString());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      print("messResponse");
      print(json.decode(response.body)["message"]);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final verifyOtpModel = verifyOtpModelFromJson(response.body);

          if (verifyOtpModel.statusCode == successResponse &&
              verifyOtpModel.success) {
            return verifyOtpModel;
          } else {
            throw CustomException(verifyOtpModel.message);
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

  Future<ViewTrainingVideoModelClass> viewTrainingVideoApi(
      Map<String, dynamic> param) async {
    try {
      final response = await post(viewTrainingVideo,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ViewTrainingVideoModelClass.fromJson(json.decode(response.body));
          return blockedCustomerList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<SendFeedBackModel> sendFeedBack(Map<String, dynamic> param) async {
    try {
      final response = await post(saveAstrologerExperience,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              SendFeedBackModel.fromJson(json.decode(response.body));
          return blockedCustomerList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResLogin> userLogin(Map<String, dynamic> param) async {
    try {
      final response = await post(loginUrl, body: jsonEncode(param).toString());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

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
        String exceptionmessage = json.decode(response.body)["message"];
        throw CustomException(exceptionmessage);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  /*Future<ResLogin> uploadAstroImageUpload(Map<String, dynamic> param) async {
    try {
      final response = await post(uploadAstroImage, body: FormData);

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
      debugPrint("we got $e $s");
      rethrow;
    }
  }*/

  Future<ResLogin> astrologerLoginWithTrueCaller({
    required Map<String, dynamic> params,
  }) async {
    ResLogin data = ResLogin();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(loginUrl, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = ResLogin.fromJson(responseBody);
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {}
      } else {}
    } on Exception catch (error, stack) {
      debugPrint(
          "astrologerLoginWithTrueCaller(): Exception caught: error: $error");
      debugPrint(
          "astrologerLoginWithTrueCaller(): Exception caught: stack: $stack");
    }
    return Future<ResLogin>.value(data);
  }

  //

  Future<GetUserProfile> getProfileDetail(Map<String, dynamic> param) async {
    try {
      final response = await post(getProfileUrl,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
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
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResReviewRatings> getReviewRatings(Map<String, dynamic> param) async {
    try {
      final response = await post(getReviewRatingUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
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
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PujaListingModel> getPujaList(Map<String, dynamic> param) async {
    try {
      final response = await post(getPoojaListUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final pujaListModel =
              PujaListingModel.fromJson(json.decode(response.body));
          return pujaListModel;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<RemediesModel> getRemedyList(Map<String, dynamic> param) async {
    try {
      final response = await post(getRemedyUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final pujaListModel =
              RemediesModel.fromJson(json.decode(response.body));
          return pujaListModel;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ReportReviewModelClass> reportUserReviews(
      Map<String, dynamic> param) async {
    try {
      final response = await post(reportUserReview,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ReportReviewModelClass.fromJson(json.decode(response.body));
          return blockedCustomerList;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResReviewReply> reviewReply(Map<String, dynamic> param) async {
    try {
      final response = await post(reviewReplyUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final resReviewReply =
              ResReviewReply.fromJson(json.decode(response.body));
          return resReviewReply;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<BlockedCustomersResponse> getBlockedCustomerList(
      Map<String, dynamic> param) async {
    try {
      final response = await post(blockCustomerlistUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              BlockedCustomersResponse.fromJson(json.decode(response.body));
          if (blockedCustomerList.statusCode == successResponse &&
              blockedCustomerList.success!) {
            return blockedCustomerList;
          } else {
            throw CustomException("Data not found");
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResBlockedCustomers> blockUnblockCustomer(
      Map<String, dynamic> param) async {
    try {
      final response = await post(blockCustomerUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
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
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ChatOrderResponse> getChatOrderDetails() async {
    try {
      Map<String, dynamic> param = new Map();
      final response = await post(
        currentChatOrder,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param).toString(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      log(response.body);
      log("CurrentChatOrder");
      if (response.statusCode == 200) {
        log("CurrentChatOrder-1");
        ChatOrderResponse chatOrderResponse =
            ChatOrderResponse.fromJson(json.decode(response.body));
        if (chatOrderResponse.statusCode == successResponse &&
            chatOrderResponse.success == true) {
          log("CurrentChatOrder-2");
          return chatOrderResponse;
        } else {
          log("CurrentChatOrder-3");
          throw CustomException(json.decode(response.body)["error"]);
        }
      } else {
        log("CurrentChatOrder-4");
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      Utils().handleCatchPreferenceServiceErase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ConstantDetailsModelClass> constantDetailsData() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidInfo;
      IosDeviceInfo iosDeviceInfo;
      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
        print('Running on ${androidInfo!.model}'); // e.g., "Pixel 3"
        print('App Version: $version');
      } else {
        iosDeviceInfo = await deviceInfo.iosInfo;
      }

      Map<String, dynamic> param = new Map();
      if (Platform.isAndroid) {
        param["device_brand"] = androidInfo!.brand;
        param["device_model"] = androidInfo.model;
        param["device_manufacture"] = androidInfo.manufacturer;
        param["device_sdk_code"] = buildNumber;
        param["appCurrentVersion"] = version;
        print('🥹🥹🥹🥹🥹🥹🥹🥹');
        print(jsonEncode(param).toString());
        print('🥹🥹🥹🥹🥹🥹🥹🥹');
      }

      final response = await post(
        constantDetails,
        headers: await getJsonHeaderURL(),
        body: jsonEncode(param).toString(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      log('😇😇😇😇😇😇😇😇');
      log(response.body);
      log('😇😇😇😇😇😇😇😇');
      log("response.body");
      if (response.statusCode == 200) {
        final constantDetailsModelClass =
            ConstantDetailsModelClass.fromJson(json.decode(response.body));
        if (constantDetailsModelClass.statusCode == successResponse &&
            constantDetailsModelClass.success == true) {
          log("1111111 - ${constantDetailsModelClass.toString()}");
          return constantDetailsModelClass;
        } else {
          throw CustomException(json.decode(response.body)["error"]);
        }
      } else {
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      Utils().handleCatchPreferenceServiceErase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UpdateProfileResponse> updateProfile(
      Map<String, dynamic> param) async {
    try {
      final response = await post(updateProfileDetails,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final editResponse = updateProfileResponseFromJson(response.body);
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

  Future<UpdateProfileResponse> getAstroImagesApis(
      Map<String, dynamic> param) async {
    try {
      final response = await post(getAstrologerImages,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final editResponse = updateProfileResponseFromJson(response.body);
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

  Future<AddEditPujaModel> addEditPujaApi(Map<String, dynamic> param) async {
    try {
      final response = await post(addPooja,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final editResponse =
              AddEditPujaModel.fromJson(jsonDecode(response.body));
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

  Future<AddEditPujaModel> addEditProductApi(Map<String, dynamic> param) async {
    try {
      final response = await post(addProductByAstrologer,
          body: jsonEncode(param), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final editResponse =
              AddEditPujaModel.fromJson(jsonDecode(response.body));
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

  Future<PujaProductCategoriesModel> getCategoriesProductAndPooja(
      Map<String, dynamic> param) async {
    try {
      final response = await get(getCategory,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getCategoriesData =
              PujaProductCategoriesModel.fromJson(jsonDecode(response.body));
          return getCategoriesData;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PujaProductCategoriesModel> getPoojaNamesApi(
      Map<String, dynamic> param) async {
    try {
      final response = await get(getPoojaNameMaster,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getPujaNamesData =
              PujaProductCategoriesModel.fromJson(jsonDecode(response.body));
          return getPujaNamesData;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

//Resignation Flow Api
  Future<ResignationReasonModel> getResignationReason(
      Map<String, dynamic> param) async {
    try {
      final response = await get(resignationReasons,
          queryParameters: param, headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              ResignationReasonModel.fromJson(json.decode(response.body));
          if (blockedCustomerList.statusCode == successResponse &&
              blockedCustomerList.success!) {
            return blockedCustomerList;
          } else {
            throw CustomException("Data not found");
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResignationStatus> getResignationStatus(
      Map<String, dynamic> param) async {
    try {
      final response = await get(resignationStatus,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getResignationStatus =
              ResignationStatus.fromJson(jsonDecode(response.body));
          return getResignationStatus;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResignationCancelModel> getResignationCancel(
      Map<String, dynamic> param) async {
    try {
      final response = await get(cancelResignation,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getResignationCancel =
              ResignationCancelModel.fromJson(jsonDecode(response.body));
          return getResignationCancel;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ResignationSubmitModel> postsubmitResignation(
      Map<String, dynamic> param) async {
    try {
      final response = await post(submitResignation,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          final submitResignation =
              ResignationSubmitModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  //Leave Flow Api
  Future<LeaveReasonsModel> getLeaveReason(Map<String, dynamic> param) async {
    try {
      final response = await get(leaveReasons,
          queryParameters: param, headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final blockedCustomerList =
              LeaveReasonsModel.fromJson(json.decode(response.body));
          if (blockedCustomerList.statusCode == successResponse &&
              blockedCustomerList.success!) {
            return blockedCustomerList;
          } else {
            throw CustomException("Data not found");
          }
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<LeaveStatusModel> getLeaveStatus(Map<String, dynamic> param) async {
    try {
      final response = await get(leaveStatus,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getResignationStatus =
              LeaveStatusModel.fromJson(jsonDecode(response.body));
          return getResignationStatus;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<LeaveCancelModel> getLeaveCancel(Map<String, dynamic> param) async {
    try {
      final response = await get(cancelLeave,
          queryParameters: param, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getResignationCancel =
              LeaveCancelModel.fromJson(jsonDecode(response.body));
          return getResignationCancel;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<LeaveSubmitModel> postsubmitLeave(Map<String, dynamic> param) async {
    log(1.toString());

    try {
      log(11.toString());

      final response = await post(submitLeave,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());

          final submitResignation = LeaveSubmitModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  ///

  Future<TechnicalSupport> submitTechnicalIssues(
      Map<String, dynamic> param) async {
    log(1.toString());

    try {
      log(11.toString());

      final response = await post(technicalSupport,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());

          final submitResignation = TechnicalSupport.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<FinancialCreateIssueModel> submitFinancialIssues(
      Map<String, dynamic> param) async {
    log(1.toString());

    try {
      log(11.toString());

      final response = await post(financialSupport,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());

          final submitResignation =
              FinancialCreateIssueModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<AddSupportIssueDataModel> submitSupportIssues(
      Map<String, dynamic> param) async {
    log(1.toString());

    try {
      log(11.toString());

      final response = await post(addSupport,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());

          final submitResignation =
              AddSupportIssueDataModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<PassBookDataModel> getpassbookData(Map<String, dynamic> param) async {
    log(1.toString());

    try {
      log(11.toString());

      final response = await post(getPassbookDetail,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());

          final passBookData = PassBookDataModel.fromJson(responseBody);
          return passBookData;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<TechnicalIssuesData> getTechnicalIssuesApi() async {
    log(1.toString());

    try {
      log(11.toString());

      final response =
          await get(getTechnicalSupportlist, headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());
          log(responseBody.toString());

          final submitResignation = TechnicalIssuesData.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<AllFinancialIssuesModel> getFinancialIssuess() async {
    log(1.toString());

    try {
      log(11.toString());

      final response =
          await get(getFinancialSupportlist, headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());
          log(responseBody.toString());

          final submitResignation =
              AllFinancialIssuesModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<AllSupportIssueModel> getSupportIssuess() async {
    log(1.toString());

    try {
      log(11.toString());

      final response =
          await get(getSupportlist, headers: await getJsonHeaderURL());
      log(111.toString());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
        throw CustomException('Unauthorized access');
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
        throw CustomException('Bad request');
      }

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        log(1111.toString());

        final responseBody = json.decode(response.body);
        if (responseBody["status_code"] == HttpStatus.unauthorized) {
          log(2.toString());
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(responseBody["error"] ?? 'Unauthorized access');
        } else {
          log(11111.toString());
          log(responseBody.toString());

          final submitResignation = AllSupportIssueModel.fromJson(responseBody);
          return submitResignation;
        }
      } else {
        log(22.toString());

        final errorBody = json.decode(response.body);
        throw CustomException(
            errorBody["message"]?.toString() ?? 'Unknown error');
      }
    } catch (e, s) {
      log(222.toString());

      debugPrint("Exception occurred: $e\nStack trace: $s");
      rethrow;
    }
  }

  Future<PujaProductCategoriesModel> getTagProductAndPooja(
      Map<String, dynamic> param) async {
    try {
      final response = await get(
        getTag,
        queryParameters: param,
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final getCategoriesData =
              PujaProductCategoriesModel.fromJson(jsonDecode(response.body));
          return getCategoriesData;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<AddEditPujaModel> deletePujaApi({String? id}) async {
    try {
      final response = await delete(
        "${deletePuja}/${id}",
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final deletePujaResponse =
              AddEditPujaModel.fromJson(jsonDecode(response.body));
          return deletePujaResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UploadStoryResponse> uploadAstroStory(
      Map<String, dynamic> param) async {
    try {
      final response = await post(uploadAstroStories,
          body: jsonEncode(param), headers: await getJsonHeaderURL());

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body));
        } else {
          final uploadStoryResponse =
              uploadStoryResponseFromJson(response.body);
          return uploadStoryResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<DeleteAccountModelClass> deleteUserAccount(
      Map<String, dynamic> param) async {
    try {
      final response =
          await post(deleteAccount, body: jsonEncode(param).toString());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final deleteProfile = customerDeleteFromJson(response.body);
          if (deleteProfile.statusCode == successResponse &&
              deleteProfile.success) {
            return deleteProfile;
          } else {
            throw CustomException(deleteProfile.message);
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

  Future<LogOutResponse> logOut() async {
    try {
      final response = await post(logout, headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final logOutResponse = logOutResponseFromJson(response.body);
          if (logOutResponse.statusCode == successResponse &&
              logOutResponse.success!) {
            print("One time log out");
            return logOutResponse;
          } else {
            throw CustomException(logOutResponse.message!);
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
    throw CustomException("json.decode(response.body)['message']");
  }

  Future<LoginImages> getInitialLoginImages() async {
    try {
      final response = await post(getIntroPageDesc);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if (response.statusCode == 200) {
        final loginImagesResponse = loginImagesFromJson(response.body);
        if (loginImagesResponse.statusCode == successResponse &&
            loginImagesResponse.success) {
          return loginImagesResponse;
        } else {
          throw CustomException(loginImagesResponse.message);
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UpdateBankResponse> updateBankDetailsApi(
      Map<String, dynamic> param) async {
    try {
      final response = await post(updateBankDetails,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL(version: 7));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final updatedBankResponse = updateBankResponseFromJson(response.body);
          return updatedBankResponse;
        }
      } else {
        throw CustomException(json.decode(response.body)["error"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<TermsConditionModel> getTermsCondition() async {
    try {
      // debugPrint("Params $param");
      final response = await post(termsAndCondition);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final termsConditionResponse =
              termsConditionModelFromJson(response.body);
          if (termsConditionResponse.statusCode == successResponse &&
              termsConditionResponse.success) {
            return termsConditionResponse;
          } else {
            throw CustomException(json.decode(response.body)["error"]);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      Utils().handleCatchPreferenceServiceErase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    try {
      // debugPrint("Params $param");
      final response = await post(privacyPolicy);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final privacyPolicyResponse =
              privacyPolicyModelFromJson(response.body);
          if (privacyPolicyResponse.statusCode == successResponse &&
              privacyPolicyResponse.success) {
            return privacyPolicyResponse;
          } else {
            throw CustomException(json.decode(response.body)["error"]);
          }
        }
      } else {
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      Utils().handleCatchPreferenceServiceErase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UploadImageResponse> uploadYourPhotoApi(
      Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(
        uploadAstrologerimage,
        body: jsonEncode(param),
        headers: await getJsonHeaderURL(),
      );
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final uploadImageResponse =
              uploadImageResponseFromJson(response.body);
          if (uploadImageResponse.statusCode == successResponse &&
              uploadImageResponse.success) {
            return uploadImageResponse;
          } else {
            throw CustomException(uploadImageResponse.message);
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

  Future<String> endCall(Map<String, dynamic> param) async {
    try {
      final response = await post(agoraCallEnd, body: jsonEncode(param));
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          return response.body;
        }
      } else {
        throw CustomException(json.decode(response.body)["message"]);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UpdateOfferResponse> updateOfferTypeApi(
      Map<String, dynamic> params) async {
    try {
      final response = await post(customOfferManage,
          body: jsonEncode(params), headers: await getJsonHeaderURL());
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] ==
            HttpStatus.badRequest) {
          Utils().handleStatusCode400(json.decode(response.body)["message"]);
          throw CustomException(json.decode(response.body)["message"]);
        } else {
          final updateOfferResponse =
              updateOfferResponseFromJson(response.body);
          if (updateOfferResponse.statusCode == successResponse &&
              (updateOfferResponse.success ?? false)) {
            return updateOfferResponse;
          } else {
            throw CustomException(updateOfferResponse.message ?? '');
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

  Future<UpdateSessionTypeResponse> astroOnlineAPIForLive({
    required Map<String, dynamic> params,
    required Function(String message) successCallBack,
    required Function(String message) failureCallBack,
  }) async {
    UpdateSessionTypeResponse data = UpdateSessionTypeResponse();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(astroOnline, body: requestBody);
      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = UpdateSessionTypeResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
        } else {
          data = UpdateSessionTypeResponse.fromJson(responseBody);
          failureCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        }
      } else {
        failureCallBack(response.reasonPhrase ?? "Unknown Error Occurred");
      }
    } on Exception catch (error, stack) {
      debugPrint("astroOnlineAPIForLive(): Exception caught: error: $error");
      debugPrint("astroOnlineAPIForLive(): Exception caught: stack: $stack");
      failureCallBack("Unknown Error Occurred");
    }
    return Future<UpdateSessionTypeResponse>.value(data);
  }

  Future<NewCityStateModel> cityApi(Map<String, dynamic> param) async {
    try {
      final response =
          await post(getCityAstrology, body: jsonEncode(param).toString());
      log('login response ==> ${response.body}');

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final cityModel =
              NewCityStateModel.fromJson(jsonDecode(response.body));
          if (cityModel.statusCode == successResponse && cityModel.success!) {
            return cityModel;
          } else {
            throw CustomException("Unknown Error");
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

  Future<CustomProductModel> customeEcommerceApi(
      Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response =
          await post(customeEcommerce, body: jsonEncode(param).toString());

      print("messResponse");
      print(json.decode(response.body)["message"]);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] ==
            HttpStatus.unauthorized) {
          Utils().handleStatusCodeUnauthorizedBackend();
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          CustomProductModel savedRemediesData =
              CustomProductModel.fromJson(jsonDecode(response.body));

          if (savedRemediesData.statusCode == successResponse &&
              savedRemediesData.success!) {
            return savedRemediesData;
          } else {
            throw CustomException(savedRemediesData.message!);
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
}
