import 'dart:ui';

import 'package:get/get.dart';

import 'en.dart';

class AppTranslations extends Translations {
  static Locale get locale => Get.deviceLocale!;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en(),
      };
}
