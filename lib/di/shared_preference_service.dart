import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/zego_services.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/model/update_bank_response.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/res_login.dart';

class SharedPreferenceService extends GetxService {
  SharedPreferences? prefs;
  static const tokenKey = "token";
  static const deviceTokenKey = "deviceTokenKey";
  static const userKey = "user";
  static const specialAbility = "specialAbility";
  static const loginImages = "loginImages";
  static const updatedBankDetails = "updatedBankDetails";
  static const baseImageUrl = "baseImageUrl";

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
      var jsonDecoded = jsonDecode(userData);
      userDetail = UserData.fromJson(jsonDecoded);
    }
    return userDetail;
  }

  Future<bool> setUserDetail(UserData userData) async {
    return await prefs!.setString(userKey, jsonEncode(userData));
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
    await ZegoServices().unInitZegoInvitationServices();
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
    if (images != null) return loginImagesFromJson(images);
    return null;
  }

  Future<void> saveUpdatedBankDetails(String json) async {
    await prefs!.setString(updatedBankDetails, json);
  }

  UpdateBankResponse? getUpdatedBankDetails() {
    String? data = prefs!.getString(updatedBankDetails);
    if (data != null) return updateBankResponseFromJson(data);
    return null;
  }

  String? getBaseImageURL() {
    return prefs!.getString(baseImageUrl);
  }

  Future<bool> setBaseImageURL(String imageUrl) async {
    return await prefs!.setString(baseImageUrl, imageUrl);
  }
}
