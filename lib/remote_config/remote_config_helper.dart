
import 'dart:developer';


import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class RemoteConfigHelper {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigHelper({required this.remoteConfig});

  Future<void> initialize() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      // await remoteConfig.setDefaults(<String, dynamic>{
      //   // 'welcome': 'default welcome',
      //   // 'hello': 'default hello',
      // });
      RemoteConfigValue(null, ValueSource.valueStatic);
      await remoteConfig.fetchAndActivate();
      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
        log("Config Updated... ${remoteConfig.getString("background")}");
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




  Future<void> updateGlobalConstantWithFirebaseData() async {
    try {
      /// update colors
      // remoteConfigData = remoteConfig.getString("background");

    } catch (exception) {
      debugPrint('Error fetching remote config: $exception');
    }
  }
}
