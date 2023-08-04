import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferAstrologerController extends GetxController {
  RxBool isYesSelected = false.obs;
  RxBool isNoSelected = false.obs;
  final formKey = GlobalKey<FormState>();

  yesOrNoOptionTapped({required bool? isYesTapped}) {
    isYesSelected.value = isYesTapped ?? false;
    isNoSelected.value = !isYesTapped!;
  }
}
