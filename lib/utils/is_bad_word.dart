import 'dart:async';
import 'dart:developer';

import '../screens/live_dharam/live_shared_preferences_singleton.dart';

// check how much time it is taking
bool isBadWord(String sentence) {
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
        print('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
        return true;
      }
    }

    // Check for 10 digit number
    if (RegExp(r'\b\d{10}\b').hasMatch(word)) {
      DateTime end = DateTime.now();
      print('Time taken to check for 10 digit number: ${end.difference(start).inMilliseconds} ms');
      return true;
    }

    // Check for +91 mobile number
    if (RegExp(r'\+91\d{10}').hasMatch(word)) {
      DateTime end = DateTime.now();
      print('Time taken to check for +91 mobile number: ${end.difference(start).inMilliseconds} ms');
      return true;
    }

    // Check for numbers
    if (RegExp(r'\d').hasMatch(word)) {
      DateTime end = DateTime.now();
      print('Time taken to check for numbers: ${end.difference(start).inMilliseconds} ms');
      return true;
    }

    // Check for email
    if (RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}').hasMatch(word)) {
      DateTime end = DateTime.now();
      print('Time taken to check for email: ${end.difference(start).inMilliseconds} ms');
      return true;
    }
  }
  DateTime end = DateTime.now();
  log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
  return false;
}