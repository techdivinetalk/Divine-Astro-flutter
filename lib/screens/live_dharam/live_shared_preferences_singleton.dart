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
  final String _badWordsList = "badWordsList";

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    print("LiveSharedPreferencesSingleton:: init():: ${_pref?.getKeys()}");
    return Future<void>.value();
  }

  Future<bool> setSingleTarotCard({required String value}) async {
    final bool isSaved = await _pref?.setString(_singleTarot, value) ?? false;
    print("LiveSharedPreferencesSingleton:: setSingleTarotCard():: $value");
    return Future<bool>.value(isSaved);
  }

  String getSingleTarotCard() {
    final String value = _pref?.getString(_singleTarot) ?? "";
    print("LiveSharedPreferencesSingleton:: getSingleTarotCard():: $value");
    return value;
  }

  Future<bool> setAllTarotCard({required NewTarotCardModel model}) async {
    final Map<String, dynamic> jsonMap = model.toJson();
    final String value = json.encode(jsonMap);
    final bool isSaved = await _pref?.setString(_allTarot, value) ?? false;
    print("LiveSharedPreferencesSingleton:: setAllTarotCard():: $value");
    return Future<bool>.value(isSaved);
  }

  NewTarotCardModel getAllTarotCard() {
    final String map = _pref?.getString(_allTarot) ?? "";
    final Map<String, dynamic> jsonMap = json.decode(map);
    final NewTarotCardModel res = NewTarotCardModel.fromJson(jsonMap);
    print("LiveSharedPreferencesSingleton:: getAllTarotCard():: $jsonMap");
    return res;
  }

  Future<bool> setBadWordsList({required List<String> values}) async {
    final bool isSaved =
        await _pref?.setStringList(_badWordsList, values) ?? false;
    print("LiveSharedPreferencesSingleton:: setBadWordsList():: $values");
    return Future<bool>.value(isSaved);
  }

  List<String> getBadWordsList() {
    final List<String> values =
        _pref?.getStringList(_badWordsList) ?? <String>[];
    print("LiveSharedPreferencesSingleton:: getBadWordsList():: $values");
    return values;
  }
}
