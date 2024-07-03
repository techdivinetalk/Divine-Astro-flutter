import 'dart:async';
import 'dart:developer';

import '../screens/live_dharam/live_shared_preferences_singleton.dart';

// check how much time it is taking
bool isBadWord(String word) {
  DateTime start = DateTime.now();
  // get bad words list
  List<String> badWords = LiveSharedPreferencesSingleton().getBadWordsList();
  // check if word is in bad words list
  for (String badWord in badWords) {
    if (word.toLowerCase() == badWord.toLowerCase()) {
      DateTime end = DateTime.now();
      log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
      return true;
    }
  }
  // check if not only 10 digits
  if (word.length == 10 && !RegExp(r'^[0-9]*$').hasMatch(word)) {
    DateTime end = DateTime.now();
    log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
    return true;
  }
  // check if special character @
  if (RegExp(r'[@]').hasMatch(word)) {
    DateTime end = DateTime.now();
    log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
    return true;
  }
  // check if +91 mobile number
  if (word.length == 13 && word.startsWith('+91')) {
    DateTime end = DateTime.now();
    log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
    return true;
  }
  DateTime end = DateTime.now();
  log('Time taken to check bad word: ${end.difference(start).inMilliseconds} ms');
  return false;
}