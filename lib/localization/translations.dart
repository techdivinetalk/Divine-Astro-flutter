import 'dart:ui';

import 'package:get/get.dart';

import 'en.dart';
import 'gu.dart';
import 'hi.dart';
import 'mr.dart';

class AppTranslations extends Translations {
  static Locale  locale = Get.deviceLocale!;
  static const fallbackLocale = Locale('en', 'US');
  static const gujaratiLocale = Locale('gu', 'IN');
  static const hindiLocale = Locale('hi', 'IN');
  static const marathiLocale = Locale('mr', 'IN');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en(),
        'gu_IN': gu(),
        'hi_IN': hi(),
        'mr_IN': mr(),
      };
}
