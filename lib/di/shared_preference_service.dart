import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/res_login.dart';

class SharedPreferenceService extends GetxService {
  SharedPreferences? prefs;
  static const tokenKey = "token";
  static const userKey = "user";

  Future<SharedPreferenceService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  UserData? getUserDetail() {
    UserData? userDetail;
    String userData = prefs!.getString(userKey) ?? "";
    log("userData:: $userData");
    if (userData.isNotEmpty) {
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

  Future remove(String key) {
    return prefs!.remove(key);
  }

  Future erase() {
    return prefs!.clear();
  }
}
