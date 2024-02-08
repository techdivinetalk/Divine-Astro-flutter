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
      if (condition != null && !condition()) {
        return Container(); // Return an empty container if the condition is not met
      }
      return page();
    },
  );
}