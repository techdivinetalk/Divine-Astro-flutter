import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/foundation.dart';

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
  void onException(
      {Function()? onButtonClick,
      String title = "",
      Function()? onDismissClick,
      String buttonText = "",
      String dismissButtonText = ""}) {
    divineSnackBar(data: message, color: AppColors.redColor);
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
      divineSnackBar(data: message, color: AppColors.redColor);
    } else {
      debugPrint(message);
    }
  }
}

class OtpInvalidTimerException implements Exception {
  final String message;

  OtpInvalidTimerException(this.message);

  @override
  String toString() {
    return 'MyCustomException: $message';
  }
}
