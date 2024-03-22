import 'dart:convert';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
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
import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:divine_astrologer/screens/add_puja/model/puja_product_categories_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/screens/puja/model/add_edit_puja_model.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/screens/remedies/model/remedies_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../common/app_exception.dart';
import '../common/routes.dart';
import '../di/api_provider.dart';
import "../model/blocked_customers_response.dart";
import '../model/constant_details_model_class.dart';
import '../model/delete_customer_model_class.dart';
import '../model/report_review_model_class.dart';
import '../model/res_blocked_customers.dart';
import '../model/res_login.dart';
import '../model/res_review_ratings.dart';
import '../model/send_feed_back_model.dart';
import '../model/send_otp.dart';
import '../model/verify_otp.dart';
import '../model/view_training_video_model.dart';

class UserRepository extends ApiProvider {
  Future sentOtp(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response = await post(sendOtp, body: jsonEncode(param).toString());
      //progressService.showProgressDialog(false);
      print(response.statusCode);
      print("response.statusCode");
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else if (json.decode(response.body)["status_code"] == 400) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["message"]);
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
      //progressService.showProgressDialog(false);
      print("messResponse");
      print(json.decode(response.body)["message"]);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

  //
  Future<ResLogin> astrologerLoginWithTrueCaller({
    required Map<String, dynamic> params,
  }) async {
    ResLogin data = ResLogin();
    try {
      final String requestBody = jsonEncode(params);
      final response = await post(loginUrl, body: requestBody);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = ResLogin.fromJson(responseBody);
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PujaListingModel> getPujaList(Map<String, dynamic> param) async {
    try {
      final response = await post(getPoojaListUrl,
          body: jsonEncode(param).toString(),
          headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<ConstantDetailsModelClass> constantDetailsData() async {
    print(DateTime.now());
    print("DateTime.now()");
    try {
      // debugPrint("Params $param");
      final response =
          await post(constantDetails, headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        final constantDetailsModelClass =
            ConstantDetailsModelClass.fromJson(json.decode(response.body));
        if (constantDetailsModelClass.statusCode == successResponse &&
            constantDetailsModelClass.success == true) {
          return constantDetailsModelClass;
        } else {
          throw CustomException(json.decode(response.body)["error"]);
        }
      } else {
        throw CustomException(json.decode(response.body)[0]["message"]);
      }
    } catch (e, s) {
      preferenceService.erase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<UpdateProfileResponse> updateProfile(
      Map<String, dynamic> param) async {
    try {
      final response = await post(updateProfileDetails,
          body: jsonEncode(param), headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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
        if (json.decode(response.body)["status_code"] == 401) {
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
        if (json.decode(response.body)["status_code"] == 401) {
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

  Future<PujaProductCategoriesModel> getTagProductAndPooja(
      Map<String, dynamic> param) async {
    try {
      final response = await get(
        getTag,
        queryParameters: param,
        headers: await getJsonHeaderURL(),
      );

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final logOutResponse = logOutResponseFromJson(response.body);
          if (logOutResponse.statusCode == successResponse &&
              logOutResponse.success!) {
            print("One time log out");
            isLogOut = true;
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
      preferenceService.erase();
      debugPrint("we got $e $s");
      rethrow;
    }
  }

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    try {
      // debugPrint("Params $param");
      final response = await post(privacyPolicy);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
      preferenceService.erase();
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
      //progressService.showProgressDialog(false);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
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

  Future<UpdateSessionTypeResponse> updateSessionTypeApi(
      Map<String, dynamic> params) async {
    try {
      final response = await post(astroOnline,
          body: jsonEncode(params), headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
        } else {
          final updateSessionTypeResponse =
              updateSessionTypeResponseFromJson(response.body);
          print(jsonEncode(updateSessionTypeResponse));
          print("jsonEncode(updateSessionTypeResponse)");
          if (updateSessionTypeResponse.statusCode == successResponse &&
              (updateSessionTypeResponse.success ?? false)) {
            return updateSessionTypeResponse;
          } else {
            throw CustomException(updateSessionTypeResponse.message ?? '');
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

  Future<UpdateOfferResponse> updateOfferTypeApi(
      Map<String, dynamic> params) async {
    try {
      final response = await post(customOfferManage,
          body: jsonEncode(params), headers: await getJsonHeaderURL());

      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
          throw CustomException(json.decode(response.body)["error"]);
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
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if (responseBody["status_code"] == HttpStatus.ok) {
          data = UpdateSessionTypeResponse.fromJson(responseBody);
          successCallBack(responseBody["message"] ?? "Unknown Error Occurred");
        } else if (responseBody["status_code"] == HttpStatus.unauthorized) {
          await preferenceService.erase();
          await Get.offAllNamed(RouteName.login);
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

  Future<CustomProductModel> customeEcommerceApi(Map<String, dynamic> param) async {
    //progressService.showProgressDialog(true);
    try {
      final response =
      await post(customeEcommerce, body: jsonEncode(param).toString());

      print("messResponse");
      print(json.decode(response.body)["message"]);
      if (response.statusCode == 200) {
        if (json.decode(response.body)["status_code"] == 401) {
          preferenceService.erase();
          Get.offNamed(RouteName.login);
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
