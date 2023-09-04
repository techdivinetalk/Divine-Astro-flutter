
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
abstract class AppException implements Exception {
  void onException(
      {Function()? onButtonClick,
        String title,
        Function()? onDismissClick,
        String buttonText,
        String dismissButtonText});
}
class NoInternetException extends AppException {
  String message;

  NoInternetException(this.message);
  @override
  void onException({Function()? onButtonClick,
    String title = "",
    Function()? onDismissClick,
    String buttonText = "",
    String dismissButtonText = ""}) {
    Get.snackbar(title, message).show();
  }
}
class CustomException extends AppException {
  String message;

  CustomException(this.message);

  @override
  void onException(
      {Function()? onButtonClick,
        String title = "Sorry",
        Function()? onDismissClick,
        String buttonText = "Ok",
        String? dismissButtonText,
        shouldShowFlushBar = true}) {
    if (shouldShowFlushBar) {
      divineSnackBar(data: message,color: AppColors.redColor);
    } else {
      debugPrint(message);
    }
  }
}