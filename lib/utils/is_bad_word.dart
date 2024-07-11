import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../di/shared_preference_service.dart';
import '../screens/live_dharam/live_shared_preferences_singleton.dart';

// check how much time it is taking
bool isBadWord(String sentence) {
  final SharedPreferenceService pref = Get.put(SharedPreferenceService());
  DateTime start = DateTime.now();
  // get bad words list
  List<String> badWords = LiveSharedPreferencesSingleton().getBadWordsList();
  // check if word is in bad words list
  List<String> words = sentence.split(' ');

  for (String word in words) {
    // Check for bad words
    for (String badWord in badWords) {
      if (word.toLowerCase() == badWord.toLowerCase()) {
        DateTime end = DateTime.now();
        print(
            'Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
        return true;
      }
    }

    // Check for 10 digit number
    if (word.length == 10 && RegExp(r'^[0-9]').hasMatch(word)) {
      DateTime end = DateTime.now();
      print(
          'Time taken to check for 10 digit number: ${end.difference(start).inMilliseconds} ms');
      return true;
    }

    // Check for email
    if (RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
        .hasMatch(word)) {
      DateTime end = DateTime.now();
      print(
          'Time taken to check for email: ${end.difference(start).inMilliseconds} ms');
      return true;
    }
  }
  DateTime end = DateTime.now();
  log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
  return false;
}
