import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoteConfigHelper {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigHelper({required this.remoteConfig});

  Future<void> initialize() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration.zero,
          minimumFetchInterval: Duration.zero,
        ),
      );
      // await remoteConfig.setDefaults(<String, dynamic>{
      //   // 'welcome': 'default welcome',
      //   // 'hello': 'default hello',
      // });
      RemoteConfigValue(null, ValueSource.valueStatic);
      bool b = await remoteConfig.fetchAndActivate();
      print(b);
      print("bbbbbbbbbbbbb");
      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
        log("Config Updated... ${remoteConfig.getString("back_groundcolor")}");
        updateGlobalConstantWithFirebaseData();
      });
    } catch (e) {
      debugPrint('Error initializing Remote Config: $e');
    }
  }

  String getString(String key) {
    return remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return remoteConfig.getBool(key);
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }

  double getDouble(String key) {
    return remoteConfig.getDouble(key);
  }

  /// primaryLiteColor
  Future<void> updateGlobalConstantWithFirebaseData() async {
    try {
      /// update colors
      Get.put(AppColors());
      final appColors = Get.find<AppColors>();
      appColors.guideColor =fromHex(remoteConfig.getString("guideColor"));

      appColors.brownColour =fromHex(remoteConfig.getString("brownColour"));

      Get.put(AppColors()).update();
    } catch (exception) {
      debugPrint('Error fetching remote config: $exception');
    }
  }

  Color fromHex(String hexString) {
    Color color = Colors.transparent;
    if (hexString.isEmpty) {
      color = Theme.of(Get.context!).scaffoldBackgroundColor;
    } else {
      final StringBuffer buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write("ff");
      } else {}
      buffer.write(hexString.replaceFirst("#", ""));
      color = Color(int.parse(buffer.toString(), radix: 16));
    }
    return color;
  }
}
/*
import "dart:convert";
import "dart:developer";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_remote_config/firebase_remote_config.dart";

class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  final String paramColor = "background";

  Future<void> initFirebaseRemoteConfig() async {
    const Duration duration = Duration.zero;
    final RemoteConfigSettings remoteConfigSettings = RemoteConfigSettings(
      fetchTimeout: duration,
      minimumFetchInterval: duration,
    );
    await remoteConfig.setConfigSettings(remoteConfigSettings);
    await fetchAndActivate();
    remoteConfig.onConfigUpdated.listen(
          (RemoteConfigUpdate event) async {
        await instance.remoteConfig.activate();

        if (event.updatedKeys.contains(instance.paramColor)) {
          print("colors aave 6e");
        } else {}
      },
    );
    return Future<void>.value();
  }

  Future<bool> fetchAndActivate() async {
    bool activate = false;
    try {
       activate = await remoteConfig.fetchAndActivate();
      log("RemoteConfigService: fetchAndActivate(): value: $activate");
    } on FirebaseException catch (error) {
      log("RemoteConfigService: fetchAndActivate(): error: $error");
    } finally {}
    return Future<bool>.value(false);
  }

  // Future<bool> getBool() async {
  //   final bool value = remoteConfig.getBool(paramBoolean);
  //   return Future<bool>.value(value);
  // }
  //
  // Future<Map<String, dynamic>> getJson() async {
  //   final String value = remoteConfig.getString(paramJson);
  //   return Future<Map<String, dynamic>>.value(jsonDecode(value));
  // }
  //
  // Future<double> getDouble() async {
  //   final double value = remoteConfig.getDouble(paramNumber);
  //   return Future<double>.value(value);
  // }
  //
  // Future<String> getString() async {
  //   final String value = remoteConfig.getString(paramString);
  //   return Future<String>.value(value);
  // }

  Future<String> getColor() async {
    final String value = remoteConfig.getString(paramColor);
    return Future<String>.value(value);
  }
}*/
