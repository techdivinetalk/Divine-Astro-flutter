import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

typedef ConditionCallback = bool Function();

class CustomGetPage<T> extends GetPage<T> {
  CustomGetPage({
    required String name,
    required GetPageBuilder page,
    ConditionCallback? condition,
  }) : super(
    name: name,
    page: () {
      // checkInternetSpeed(true, navigatorKey.currentContext!);
      return page();
    },
  );
}