
import 'package:flutter/material.dart';

Locale getLanStrToLocale(String lan) {
  if (lan.isEmpty) {
    return const Locale("en", "US");
  }
  String lanCode = lan.split('_').first;
  String countryCode = lan.split('_').last;
  return Locale(lanCode, countryCode);
}
