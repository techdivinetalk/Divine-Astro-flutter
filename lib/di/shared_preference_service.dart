import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/model/update_bank_response.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat_assistant/chat_assistant_chats_response.dart';
import '../model/constant_details_model_class.dart';
import '../model/res_login.dart';

class SharedPreferenceService extends GetxService {
  SharedPreferences? prefs;
  static const tokenKey = "token";
  static const deviceTokenKey = "deviceTokenKey";
  static const userKey = "user";
  static const specialAbility = "specialAbility";
  static const loginImages = "loginImages";
  static const baseAmazonUrl = "baseAmazonUrl";
  static const assistChatUnreadkey = "chatAssistUnreadMessage";

  static const updatedBankDetails = "updatedBankDetails";
  static const baseImageUrl = "baseImageUrl";
  static const constantData = "constantData";
  static const performanceDialog = "performanceDialog";
  static const talkTime = "talkTime";
  static const messageTemplate = "messageTemplate";

  Future<SharedPreferenceService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  UserData? getUserDetail() {
    UserData? userDetail;
    String userData = prefs?.getString(userKey) ?? "";
    // log("userData:: $userData");
    if (userData.isNotEmpty) {
      log(userData);
      log("userDatauserDatauserDatauserData");
      var jsonDecoded = jsonDecode(userData);
      userDetail = UserData.fromJson(jsonDecoded);
    }
    return userDetail;
  }

  Future<bool> setUserDetail(UserData userData) async {
    return await prefs!.setString(userKey, jsonEncode(userData));
  }

  String? getAmazonUrl() {
    return prefs!.getString(baseAmazonUrl);
  }

  Future<bool> setAmazonUrl(String url) async {
    //added by: dev-dharam
    print("setAmazonUrl:: $url");
    //
    return await prefs!.setString(baseAmazonUrl, url);
  }

  Future<int> getIntPrefs(String key) async {
    return prefs!.getInt(key) ?? 0;
  }


  // Future saveChatAssistUnreadMessage() async {
  //   final SharedPreferences sharedInstance =
  //       await SharedPreferences.getInstance();
  //
  //   final encodedChatAssistList =
  //       assistChatUnreadMessages.map((e) => jsonEncode(e)).toList();
  //   await sharedInstance.setStringList(
  //   assistChatUnreadkey, encodedChatAssistList);
  //   print("called save unread message ${encodedChatAssistList} ${assistChatUnreadMessages}");
  // }
  //
  // Future getChatAssistUnreadMessage() async {
  //   final SharedPreferences sharedInstance =
  //       await SharedPreferences.getInstance();
  //
  //   final localData = sharedInstance.getStringList(assistChatUnreadkey);
  //
  //   if (localData != null) {
  //     assistChatUnreadMessages.value = [];
  //     assistChatUnreadMessages.addAll(localData
  //         .map((e) => AssistChatData.fromJson(jsonDecode(e)))
  //         .toList());
  //   }
  // }

  // Future addChatAssistUnreadMessage(AssistChatData data) async {
  //   final SharedPreferences sharedInstance =
  //       await SharedPreferences.getInstance();
  //
  //   final List<AssistChatData> chatAssistUnreadMessageList =
  //       await getChatAssistUnreadMessage();
  //   chatAssistUnreadMessageList.add(data);
  //   final encodedChatAssistList =
  //       chatAssistUnreadMessageList.map((e) => jsonEncode(e)).toList();
  //   await sharedInstance.setStringList(
  //       assistChatUnreadMessages, encodedChatAssistList);
  // }
  //
  // Future updateChatAssistUnreadMessage(List<AssistChatData> chatMessageList) async {
  //   final SharedPreferences sharedInstance =
  //   await SharedPreferences.getInstance();
  //
  //   final encodedChatAssistList =
  //   chatMessageList.map((e) => jsonEncode(e)).toList();
  //   await sharedInstance.setStringList(
  //       assistChatUnreadMessages, encodedChatAssistList);
  // }
  //
  // Future<List<AssistChatData>> getChatAssistUnreadMessage() async {
  //   final SharedPreferences sharedInstance =
  //       await SharedPreferences.getInstance();
  //
  //   final localData = sharedInstance.getStringList(assistChatUnreadMessages);
  //
  //   if (localData != null) {
  //     return localData
  //         .map((e) => AssistChatData.fromJson(jsonDecode(e)))
  //         .toList();
  //   }
  //   return [];
  // }

  Future<bool> setIntPrefs(String key, int value) async {
    return prefs!.setInt(key, value);
  }

  String? getToken() {
    return prefs!.getString(tokenKey);
  }

  Future<bool> setToken(String token) async {
    return await prefs!.setString(tokenKey, token);
  }

  String? getDeviceToken() {
    return prefs!.getString(deviceTokenKey);
  }

  Future<bool> setDeviceToken(String token) async {
    return await prefs!.setString(deviceTokenKey, token);
  }

  Future remove(String key) {
    return prefs!.remove(key);
  }

  Future erase() async {
    return prefs!.clear();
  }

  Future<bool> setSpecialAbility(String value) async {
    return await prefs!.setString(specialAbility, value);
  }

  String? getSpecialAbility() {
    return prefs!.getString(specialAbility);
  }

  Future<void> saveLoginImages(String json) async {
    prefs!.setString(loginImages, json);
  }

  LoginImages? getLoginImages() {
    String? images = prefs!.getString(loginImages);
    if (images != null) {
      return loginImagesFromJson(images);
    }

    return null;
  }

  Future<void> saveUpdatedBankDetails(String json) async {
    await prefs!.setString(updatedBankDetails, json);
  }

  UpdateBankResponse? getUpdatedBankDetails() {
    String? data = prefs!.getString(updatedBankDetails);
    return updateBankResponseFromJson(data!);
    return null;
  }

  Future<void> saveMessageTemplates(String json) async {
    final SharedPreferences sharedInstance =
        await SharedPreferences.getInstance();

    // sharedInstance.remove(messageTemplate);
    final result = await sharedInstance.setString(messageTemplate, json);
  }

  Future<List<MessageTemplates>> getMessageTemplates() async {
    final SharedPreferences sharedInstance =
        await SharedPreferences.getInstance();
    String data = sharedInstance.getString(messageTemplate) ?? '';
    print("getMessageTemplates $data");
    final list = (json.decode(data));
    return list
        .map<MessageTemplates>((element) => MessageTemplates.fromJson(element))
        .toList();
    // return null;
  }

  // Future<List<MessageTemplates>> getMessageTemplates() async {
  //   final SharedPreferences sharedInstance =
  //   await SharedPreferences.getInstance();
  //
  //   // Example: encoding a list of message templates to JSON
  //   List<MessageTemplates> templates = []; // Replace with your actual list
  //   String jsonData = json.encode(templates);
  //
  //   // Store the JSON string in SharedPreferences
  //   sharedInstance.setString(messageTemplate, jsonData);
  //
  //   // Retrieve the JSON string from SharedPreferences
  //   String storedData = sharedInstance.getString(messageTemplate) ?? '';
  //
  //   // Parse the stored JSON string
  //   final list = json.decode(storedData);
  //
  //   // Map the decoded list to MessageTemplates objects
  //   return list
  //       .map<MessageTemplates>((element) => MessageTemplates.fromJson(element))
  //       .toList();
  // }


  String? getBaseImageURL() {
    return prefs!.getString(baseImageUrl);
  }

  Future<bool> setBaseImageURL(String imageUrl) async {
    return await prefs!.setString(baseImageUrl, imageUrl);
  }

  ConstantDetailsModelClass getConstantDetails() {
    ConstantDetailsModelClass? constantDetails;
    String constantDatas = prefs!.getString(constantData) ?? "";
    if (constantDatas.isNotEmpty) {
      var jsonDecoded = jsonDecode(constantDatas);
      constantDetails = ConstantDetailsModelClass.fromJson(jsonDecoded);
    }
    return constantDetails!;
  }

  Future<bool> setConstantDetails(
      ConstantDetailsModelClass constantDetails) async {
    return await prefs!.setString(constantData, jsonEncode(constantDetails));
  }

  int getTalkTime() {
    return prefs!.getInt(talkTime) ?? 0;
  }

  Future<bool> setTalkTime(int talkTimeValue) async {
    return await prefs!.setInt(talkTime, talkTimeValue);
  }
}
