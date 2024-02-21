import 'dart:convert';

import 'package:divine_astrologer/model/live/new_tarot_card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveSharedPreferencesSingleton {
  static final LiveSharedPreferencesSingleton _singleton =
      LiveSharedPreferencesSingleton._internal();

  factory LiveSharedPreferencesSingleton() {
    return _singleton;
  }

  LiveSharedPreferencesSingleton._internal();

  SharedPreferences? _pref;

  final String _singleTarot = "singleTarot";
  final String _allTarot = "allTarot";

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    return Future<void>.value();
  }

  Future<bool> setSingleTarotCard({required String value}) async {
    final bool isSaved = await _pref?.setString(_singleTarot, value) ?? false;
    return Future<bool>.value(isSaved);
  }

  String getSingleTarotCard() {
    final String value = _pref?.getString(_singleTarot) ?? "";
    return value;
  }

  Future<bool> setAllTarotCard({required NewTarotCardModel model}) async {
    final Map<String, dynamic> jsonMap = model.toJson();
    final String value = json.encode(jsonMap);
    final bool isSaved = await _pref?.setString(_allTarot, value) ?? false;
    return Future<bool>.value(isSaved);
  }

  NewTarotCardModel getAllTarotCard() {
    final String map = _pref?.getString(_allTarot) ?? "";
    final Map<String, dynamic> jsonMap = json.decode(map);
    final NewTarotCardModel res = NewTarotCardModel.fromJson(jsonMap);
    return res;
  }
}
