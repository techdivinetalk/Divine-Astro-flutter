import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:divine_astrologer/di/progress_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_global_singleton.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common/app_exception.dart';
import '../common/strings.dart';
import 'network_service.dart';
import 'shared_preference_service.dart';

class ApiProvider {
  static const String version = 'v7';

  // static const String socketUrl = "http://13.127.116.89:4000"
  // static const String socketUrl = "https://list.divinetalk.live";
  static const String socketUrl = "https://list.divinetalk.live";
  // static const String socketUrl = "https://list.divinetalk.live";

  static String debugingUrl = "http://13.235.46.27/api/astro/$version/";
  static String baseUrl =
      "https://uat-divine-partner.divinetalk.live/api/astro/$version/";
  static const String getOnlineOfflineStatus =
      "https://list.divinetalk.live/api/v3/getAstroStatus?uniqueNo=";
  static String imageBaseUrl =
      "${imageUploadBaseUrl.value}/api/astro/$version/";
  static const String astOnlineOffline =
      "https://list.divinetalk.live/api/v3/updateAstroStatusV2?unique_no=";
  static const String onlineOfflineStatus =
      "https://list.divinetalk.live/api/v3/getAstrologersData";

  //Socket Event
  final String deleteSession = "deleteSession";
  final String deleteSessionResponse = "deleteSessionResponse";
  static String playStoreLiveUrl =
      "https://play.google.com/store/apps/details?id=app.divine.astrologer";

  final String initResponse = "initResponse";
  final String initLeaderBoardSession = "initLeaderBoardSession";
  final String leaderBoardResponse = "leaderBoardResponse";
  final String liveStarResponse = "liveStarResponse";
  final String top5UsersResponse = "top5UsersResponse";
  final String liveStarUser = "liveStarUser";
  final String fetchTop5Users = "fetchTop5Users";
  final String userGiftResponse = "userGiftResponse";

  final String jsonHeaderName = "Content-Type";
  final String jsonCookieName = "Cookie";
  final String jsonHeaderValue = "application/json";
  final String jsonAuthenticationName = "Authorization";
  final int successResponse = 200;
  String _token = "";

  //
  final String generateOrderAPI = "wallet/recharge";
  final String getPooja = "getPooja";

  //final String getBookedPooja = "getBookedPooja";
  final String getSinglePooja = "getSinglPooja";

  //final String getPoojaAddOns = "addOns";
  final String getUserAddressForPooja = "getUserAddress";
  final String addUserAddressForPooja = "saveUserAddress";
  final String updateUserAddressForPooja = "editUserAddress";
  final String deleteUserAddressForPooja = "deleteUserAddress";

  final String loginUrl = "astroLogin";
  final String viewTrainingVideo = "viewTrainingVideo";
  final String saveAstrologerExperience = "saveAstrologerExperience";
  final String getProfileUrl = "getAstrologerProfile";
  final String getReviewRatingUrl = "getReviewRating";
  final String getPoojaListUrl = "getPoojaList";
  final String getRemedyUrl = "getRemedy";
  final String blockCustomerlistUrl = "blockCustomerlist";
  final String blockCustomerUrl = "blockCustomer";
  final String uploadAstroImage = "uploadAstroImage";
  final String getShopUrl = "getShop";
  final String getProductListUrl = "getProductList";
  final String getProductDetailsUrl = "getProductDetails";
  final String saveRemediesUrl = "saveRemedies";
  final String saveRemediesChatAssistUrl = "saveRemediesForChatAssist";
  final String getMessageTemplateForChatAssist =
      "getMessageTemplateForChatAssist";
  final String constantDetails = "constantDetails";
  final String currentChatOrder = "getCurrentChatOrder";
  final String getOrderHistoryUrl = "getOrderHistory";
  final String reviewReplyUrl = "reviewReply";
  final String astroNoticeBoard = "astroNoticeBoard";
  final String getAstroAllNotice = "getAstroAllNotice";
  final String getSpecialityList = "getSpecialityList";
  final String getAstrologerCategory = "getAstrologerCategory";
  final String addNoticeToAstrologer = "addNoticeToAstrologer";
  final String updateProfileDetails = "updateProfileDetails";
  final String getAstrologerImages = "getAstrologerImages";
  final String addPooja = "addPooja";
  final String addProductByAstrologer = "addProductByAstrologer";
  final String getCategory = "getCategory";
  final String getPoojaNameMaster = "getPoojaNameMaster";
  final String getTag = "getTag";
  final String deletePuja = "pooja";
  final String uploadAstroStories = "uploadAstroStories";
  final String deleteAccount = "deleteAccount";
  final String reportUserReview = "reportReview";
  final String getPerformanceData = "performance";
  final String getFilteredPerformace = "performanceFilter";
  final String getIntroPageDesc = "getIntroPageDesc";
  final String logout = "Logout";
  final String updateBankDetails = "updateBankDetails";
  final String getKundliData = "getKundliData";
  final String getHomePageData = "astroDashboard";
  final String getTarotCardDataApi = "getTarotCard";
  final String getwalletPointDetail = "getwalletPointDetail";
  final String getNotFeedback = "getNotSeenFeedback";
  final String getTrainingVideo = "getTrainingVideo";
  final String getFeedbackList = "getAstroFeedbackList";
  final String getAstroFeedback = "getAstroFeedbackDetail";
  final String viewChatHistory = "getAllChatHistory";
  final String agoraCallEnd = "agoraCallEnd";
  final String getWaitingListQueue = "getWaitingListQueue";
  final String partnerOfflineChoiceOrder = "PartnerOfflineChoiceOrder";
  final String getImportantNumber = "getImportantNumber";
  final String getMessageTemplate = "getMessageTemplate";
  final String addMessageTemplate = "addMessageTemplate";
  final String editMessageTemplate = "editMessageTemplate";
  final String getDonationList = "getDonationList";
  final String updateSessionType = "updateSessionType";
  final String astroOnline = "astroOnline";
  final String getCityAstrology = "getCityAstrology";
  final String getPassbookDetail = "getPassbookDetail";
  final String updateOfferFlag = "updateOfferFlag";
  final String customOfferManage = "customOfferManage";
  final String faq = "faq";
  final String getAllFeedbackFineDetail = "getAllFeedbackFineDetail";
  final String walletPayout = "payoutDetails";
  final String getAstrologerLiveData = "getAstrologerLiveData";
  final String astrologerLiveLog = "astrologerLiveLog";
  final String getSampleText = "getMarqueeForAstrologer";
  final String getAstrologerTrainingSession = "getAstrologerTrainingSession";
  final String getAstroNoticeBoard = "astro-NoticeBoard";

  //Astro Internal API
  final String horoChartImageInt = "getChartImage/";
  final String getAstroDetailsInt = "getAstroDetails";
  final String getBirthDetailsInt = "getBirthDetails";
  final String getManglikDetailsInt = "getManglikDetails";
  final String getPlanets = "getPlanets";
  final String getGeneralNakshatraReportInt = "getGeneralNakshatraReport";
  final String getKpDetails = "getKpDetails";
  final String getPlanetlDetails = "getPlanetlDetails/";
  final String getDasha = "getDasha";
  final String getPratyantarDasha = "getPratyantarDasha/";
  final String getSookshmaDasha = "getSookshmaDasha/";
  final String getPranDasha = "getPranDasha/";

  //Kundli APIs
  final String astrologyBaseUrl = "https://json.astrologyapi.com/v1/";
  final String astroDetails = "astro_details";
  final String birthDetails = "birth_details";
  final String kundliPrediction = "general_nakshatra_report";
  final String manglik = "manglik";
  final String kalsarpaDetails = "kalsarpa_details";
  final String sadhesatiStatus = "sadhesati_current_status";
  final String pitraDoshReport = "pitra_dosha_report";
  final String horoChartImage = "horo_chart_image/";

  //chat
  final String getChatList = "getChatList";
  final String saveKundliDetails = "saveKundliDetails";
  final String chatAcceptAPI = "partner_chat_accept";
  final String endChatAPI = "end_chat";
  final String uploadAstrologerimage = "uploadAstrologerimage";
  final String getChatHistory = "getOrderChatHistory";
  final String getOrderCallHistory = "getOrderCallHistory";
  final String getChatSuggestRemedies = "getMasterRemedies";
  final String getChatSuggestRemediesDetail = "getRemediesForMasterRemedy";

  //Socket Events for Chat
  final String initChat = "initChat";
  final String initChatResponse = "initChatResponse";
  final String chatType = "chatType";
  final String chatTypeResponse = "chatTypeResponse";
  final String deleteChatSession = "deleteChatSession";
  final String deleteChatSessionResponse = "deleteChatSessionResponse";

  final String startAstroCustPrivateChat = "start-astro-cust-private-chat";
  final String astrologerJoinedPrivateChat = "astrologer-joined-private-chat";
  final String userJoinedPrivateChat = "user-joined-private-chat";
  final String userTyping = "user-typing";
  final String sendMessage = "send-message";
  final String messageSent = "message-sent";
  final String changeMsgStatus = "change-msg-status";
  final String msgStatusChanged = "msg-status-changed";
  final String leavePrivateChat = "leave-private-chat";
  final String userDisconnected = "user-disconnected";
  final String sendConnectRequest = "send-connect-request";
  final String getChatAssistAstrologers = "getChatAssistCustomers";
  final String getConsulationData = "getConsulationData";
  final String sendChatAssistMessage = "send-chat-assist-message";
  final String listenChatAssistMessage = "listen-chat-assist-message";
  final String chatAssistMessageSent = "chat-assist-message-sent";
  final String startAstroCustChatAssist = "start-astro-cust-chatAssist";
  final String astrologerLeftChatAssist = "leave-chat-assist";
  final String enterChatAssist = "enter-chat-assist";
  final String astrologerJoinedChatAssist = "astro-joined-chatAssist";
  final String userJoinedChatAssist = "user-joined-chatAssist";

  // Added By: divine-dharam
  final String joinLive = "join-live";

  //Resignation Apis
  final String resignationReasons = "resignation-reasons"; //Get Api
  final String submitResignation = "submit-resignation"; //Post Api
  final String resignationStatus = "resignation-status"; //Get Api
  final String cancelResignation = "cancel-resignation"; //Get Api

  //Leave Apis
  final String leaveReasons = "leave-reasons"; //Get Api
  final String submitLeave = "submit-leave"; //Post Api
  final String leaveStatus = "leave-status"; //Get Api
  final String cancelLeave = "cancel-leave"; //Get Api

  //Technical Support
  final String technicalSupport = "addTechnicalSupport"; //Post Api
  final String getTechnicalSupportlist = "getTechnicalSupportlist"; //Get Api

  //privacy policy & terms
  final String termsAndCondition = "termsAndCondition";
  final String privacyPolicy = "privacyPolicy";

  final String astroScheduleOnline = "astroScheduleOnline";
  final String getChatAssistCustomerData = "getChatAssistCustomerData";

  //Basic Auth
  final String username = "625170";
  final String password = "4eb3e540da68887ac72d4d45d7da9906";

  ///ReferAn Astrologer Base
  final elasticDivineTalkBase = "https://crm-api.divinetalk.live/api/v1/";

  final referAnAstrologer = "addQuickLeadByApp";

  ///This End point is for number change request not for login purpose.
  final sendOtp = "sendOtp";
  final verifyOtpUrl = "verifyOtp";

  //added by dev-dharam
  final String getAllGifts = "getAllGifts";
  final String blockCustomerlist = "blockCustomerlist";
  final String blockCustomer = "blockCustomer";
  final String getAstroAllNoticeType2 = "getAstroAllNotice?notice_type=2";
  static const String getAstroAllNoticeType3 =
      "getAstroAllNotice?notice_type=3";
  static const String getAstroAllNoticeType4 =
      "getAstroAllNotice?notice_type=4";
  static const String getCustomEcom = "getCustomEcom";
  final String customeEcommerce = "customeEcommerce";
  final String getTarotCard = "getTarotCard";

  //added by dev-chetan
  final String getCustomOffer = "getCustomOffer";
  final String sendOtpNumberChange = "sendOtpForNumberChange";
  final String verifyOtpNumberChange = "verifyOtpForNumberChange";

  // added by raj
  // final String addNoticeToAstrologer = "addNoticeToAstrologer";

  // // socket
  // final String masterDataSocket = "master-Data";

  //
  final NetworkService networkManager = Get.find<NetworkService>();
  final ProgressService progressService = Get.find<ProgressService>();
  final SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  Map<String, String> getJsonHeader() {
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;

    return header;
  }

  Future<Map<String, String>> getJsonHeaderURL({int version = 6}) async {
    _token = await _getAuthToken();
    debugPrint("test_token: $_token");

    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;
    header[jsonAuthenticationName] = 'Bearer $_token';
    header[jsonCookieName] =
        'XSRF-TOKEN=eyJpdiI6ImdlSWE2a2I0M2FIbHk0VGRHd3RubGc9PSIsInZhbHVlIjoiY1FwMjJYVUh1VnE5SHl4eDR1ZFhXWkFTTWlsMDU3S1Urcm9YWVRVeDBHQzc0OG42ZVMvbUNWZVBzNGZFOTVLOXQzYlk0bGdNNDNmRzJ0b0tJWU5SaU50Z2ZrWkpCbjFXc1plWHl1NFF4R1d0dGJDUnU2STNPVjltNTF6NXN3UVkiLCJtYWMiOiJmODY5MmE4MjI4ZWEyYTFhNzk3MmNiYzZmODkyNDJlYTUyZGE5MDNiN2EzNjA5MTY0NzMzZDc3MjMyNGEzODJmIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6Ikx4WGlYUVlPMWtXM2p6aVh3TEdtWkE9PSIsInZhbHVlIjoieThMZldWYUw3YzVBRGk4dDJNdGptOTAvRmkvS1hDM0NvL1YxZm1ZOVdPdEszTzhEU043aHRXLy9lWUE4d1ZSeE9meUtWUmhnVm0vZ2x2S21kNUw5R1NvWnBOc0g5UmFJTFg5TksyTXV1REoyQXluOEZsdFJSZGk3ZXkwOFdjSk0iLCJtYWMiOiI1YWRjYWRjOTAzMDNjNWEyZmQ4NTY4OWU5ZjI2YzFhODE4ZmQ1MjQzN2E3ZWZjMjEwODlhMThjYzdlZTg1MGMwIiwidGFnIjoiIn0%3D';
    return header;
  }

  // Future<Map<String, String>> getJsonHeaderURLDebugWakanda() async {
  //   // _token = await _getAuthToken();
  //   var header = <String, String>{};
  //   header[jsonHeaderName] = jsonHeaderValue;
  //   header[jsonAuthenticationName] = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5IiwianRpIjoiODQ2OTU2YjMzNDA0NDgwOGNiYTAyNjRlNDZiMmQ0ZDk4ZTUxNjFlNDc1NTk4OWViN2I4ODk0YjU0OTkwMjM4YzUwNmUyM2E0MjJmMWQxMGIiLCJpYXQiOjE3MTcxMzk3MzIuOTA2MTUxLCJuYmYiOjE3MTcxMzk3MzIuOTA2MTUzLCJleHAiOjE4NzQ5MDYxMzIuODgzMTQ3LCJzdWIiOiIzNTYiLCJzY29wZXMiOltdfQ.nus0R6pO1iu2DLiKODGVk97H3BD2CJ2HP_QxUUUrLz7z4i8ZizTQ-f8DgvO3FEZThqCwx6C75_pnEX8Lr_zSflXddiYN6qjhkWoY4JB1usBVj_DgJ6CbKwKtatv0ewZgwYB8KwZCmFHG6DtHZcgGM0rTyevU3lWy0XGtdQty49q77YybuRI8hDkufojjcOunLk-Jy_6ldM0ZgiGzbwoS-AXgyDy5tSwzpz3AULnYH9TzX1F3yBT7fnpNjP4pOPl16w0NQrD342lkpsB_eqDhKdOY2BCF87V5VFwbYW1DI5Uco3SYZDUJuqhbF-8cIL9e4m0WBo-5VvOB1SQgDeLXk7PsmoLkJXQ91X2vFONOtnYghgxuiaLpayHapGwIDWTmqhAi8rNaxWwJeTwTLn-pkkxMbef-ib7NhgtiAuTDRGz1Y_nF1vM4_xev4l4kpfnicqAY6EZt8Vs8hxihaGr4EoC2774Tm_fumvCamBJmk3eQToRfyMHLCgK7Fk5Xxhzmr_aPkrNZuI3zMl3WTc5EWO2L0MVPQi0b3JbCEzC1fvcOxxNCnZhMdOg4vRJgAU17Ycrxv0r3Blb4mhvcjhSOjuk06DfZqh7HfZkl7qpEQg9PSVrN75yTNRP4x7MshfAw8_RYaAXBhnsqujYapngTpzsrGhtCtpbL_sK_oun6lQY';
  //   header[jsonCookieName] =
  //       'XSRF-TOKEN=eyJpdiI6ImdlSWE2a2I0M2FIbHk0VGRHd3RubGc9PSIsInZhbHVlIjoiY1FwMjJYVUh1VnE5SHl4eDR1ZFhXWkFTTWlsMDU3S1Urcm9YWVRVeDBHQzc0OG42ZVMvbUNWZVBzNGZFOTVLOXQzYlk0bGdNNDNmRzJ0b0tJWU5SaU50Z2ZrWkpCbjFXc1plWHl1NFF4R1d0dGJDUnU2STNPVjltNTF6NXN3UVkiLCJtYWMiOiJmODY5MmE4MjI4ZWEyYTFhNzk3MmNiYzZmODkyNDJlYTUyZGE5MDNiN2EzNjA5MTY0NzMzZDc3MjMyNGEzODJmIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6Ikx4WGlYUVlPMWtXM2p6aVh3TEdtWkE9PSIsInZhbHVlIjoieThMZldWYUw3YzVBRGk4dDJNdGptOTAvRmkvS1hDM0NvL1YxZm1ZOVdPdEszTzhEU043aHRXLy9lWUE4d1ZSeE9meUtWUmhnVm0vZ2x2S21kNUw5R1NvWnBOc0g5UmFJTFg5TksyTXV1REoyQXluOEZsdFJSZGk3ZXkwOFdjSk0iLCJtYWMiOiI1YWRjYWRjOTAzMDNjNWEyZmQ4NTY4OWU5ZjI2YzFhODE4ZmQ1MjQzN2E3ZWZjMjEwODlhMThjYzdlZTg1MGMwIiwidGFnIjoiIn0%3D';
  //   return header;
  // }

  Future<Map<String, String>> getAuthorisedHeader() async {
    //if (_token.isEmpty) {
    _token = await _getAuthToken();
    //}
    var header = getJsonHeader();
    if (_token.isNotEmpty) {
      header[jsonAuthenticationName] = 'Bearer $_token';

      // Added by: divine-dharam
      header['Content-type'] = 'application/json';
      header['Accept'] = 'application/json';
      //
    }
    log("Token is $_token");
    return header;
  }

  Future<Map<String, String>> getAuthorisedFormDataHeader() async {
    if (_token.isEmpty) {
      _token = await _getAuthToken();
    }
    var header = <String, String>{};
    if (_token.isNotEmpty) {
      header[jsonAuthenticationName] = 'Bearer $_token';

      // Added by: divine-dharam
      header['Content-type'] = 'application/json';
      header['Accept'] = 'application/json';
      //
    }
    log("Token is $_token");
    return header;
  }

  Future<String> _getAuthToken() async {
    var token = preferenceService.getToken();
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  /*get(String url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      var response = await http
          .get(Uri.parse(baseUrl + url), headers: headers)
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }
*/
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool closeDialogOnTimeout = true,
  }) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }

    if (queryParameters != null) {
      url += '?${Uri(queryParameters: queryParameters).query}';
    }

    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      var response = await http
          .get(Uri.parse(baseUrl + url), headers: headers)
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  delete(String url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      var response = await http
          .delete(Uri.parse(baseUrl + url), headers: headers)
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  getWithPrams(Uri url,
      {Map<String, String>? headers, bool closeDialogOnTimeout = true}) async {
    if (headers == null) {
      headers = await getAuthorisedHeader();
      log("headers: $headers");
    }
    if (await networkManager.isConnected() ?? false) {
      log('url:$baseUrl$url');
      var response = await http
          .get(url, headers: headers)
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future<http.Response> post(String url,
      {String? endPoint,
      Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool closeDialogOnTimeout = true}) async {
    endPoint ??= //kDebugMode == true ? debugingUrl :
        baseUrl;
    headers ??= await getAuthorisedHeader();
    log("Api url: ${endPoint + url}");
    log('body: $body');
    log("headers: $headers");

    if (await networkManager.isConnected() ?? false) {
      var response = await http
          .post(
        Uri.parse(endPoint + url),
        headers: headers,
        body: body,
        encoding: encoding,
      )
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        //print("urlFound ${url} ${response}");
        throw CustomException(AppString.timeoutMessage);
      });

      if (response.statusCode == HttpStatus.unauthorized) {
        Utils().handleStatusCodeUnauthorizedServer();
      } else if (response.statusCode == HttpStatus.badRequest) {
        Utils().handleStatusCode400(response.body);
      }

      if (url != constantDetails) {
        log('response: ${response.body}');
      }
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers,
      dynamic body,
      Encoding? encoding,
      bool closeDialogOnTimeout = true}) async {
    headers ??= await getAuthorisedHeader();
    if (await networkManager.isConnected() ?? false) {
      log('url: $baseUrl$url');
      log('body: $body');
      var response = await http
          .put(Uri.parse(baseUrl + url),
              headers: headers, body: body, encoding: encoding)
          .timeout(const Duration(minutes: 1), onTimeout: () {
        if (closeDialogOnTimeout) {
          progressService.showProgressDialog(false);
        }
        throw CustomException(AppString.timeoutMessage);
      });
      log('response: ${response.body}');
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Future uploadImage(
      Map<String, File> images, Map<String, dynamic> body, String url,
      {String type = "POST", Map<String, String>? headers}) async {
    if (await networkManager.isConnected() ?? false) {
      var uri = Uri.parse(baseUrl + url);
      debugPrint("url: $baseUrl$url");
      http.MultipartRequest request = http.MultipartRequest(type, uri);
      request.headers.addAll(headers ?? await getAuthorisedHeader());
      debugPrint("header : ${request.headers}");
      images.forEach((key, value) async {
        final multipartFile =
            await http.MultipartFile.fromPath(key, value.path);
        request.files.add(multipartFile);
      });
      body.forEach((key, value) {
        if (value is List) {
          int i = 0;
          for (var element in value) {
            request.fields['$key[$i]'] = jsonEncode(element);
            i += 1;
          }
        } else {
          request.fields[key] = value.toString();
        }
      });
      log("request : $request");
      final response = await http.Response.fromStream(await request.send());
      log(response.body);
      await doLiveStreamPendingTasks(response);
      return response;
    } else {
      throw NoInternetException(AppString.noInternetConnection);
    }
  }

  Map<String, String> getAstrologyHeader() {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    Map<String, String> headers = {
      'authorization': basicAuth,
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future<void> doLiveStreamPendingTasks(http.Response response) async {
    final bool cond1 = response.statusCode == HttpStatus.unauthorized;
    final bool cond2 =
        json.decode(response.body)["status_code"] == HttpStatus.unauthorized;
    print("LiveGlobalSingleton:: doLiveStreamPendingTasks():: cond1:: $cond1");
    print("LiveGlobalSingleton:: doLiveStreamPendingTasks():: cond2:: $cond2");

    if (cond1 || cond2) {
      await LiveGlobalSingleton().leaveLiveIfIsInLiveScreen();
    } else {}

    return Future<void>.value();
  }
}
