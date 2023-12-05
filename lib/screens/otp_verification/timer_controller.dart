import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/lottie_animation.dart';

class TimerController extends GetxController {
  Rx<int> timerValue = 59.obs;
  final isDialogVisible = false.obs;

  void startTimer() {
    isDialogVisible.value = true;
    countdown();
  }

  extractTimerValue(String errorMessage) {
    final regex = RegExp(r'(\d+) seconds');
    final match = regex.firstMatch(errorMessage);
    if (match != null) {
      timerValue = (int.tryParse(match.group(1) ?? "")!).obs;
      openAlertViewObx();
    }
  }

  openAlertViewObx() {
    Get.dialog(
      Obx(() {
        if (isDialogVisible.value) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ExclamationMark(),
                  const SizedBox(height: 15),
                  Material(
                    child: Text(
                      'Too many requests. Please try again after $timerValue seconds.',
                      style:
                      AppTextStyle.textStyle16(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                      height: 50.h,
                      minWidth: 139.w,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      onPressed: () {
                        Get.back();
                        //Get.toNamed(RouteName.kundliDetailPage);
                      },
                      color: AppColors.yellow,
                      child: Text("Okay",
                          style: AppTextStyle.textStyle16(
                            fontColor: AppColors.brown,
                            fontWeight: FontWeight.w600,
                          ))),
                ],
              ),
            ),
          );
        } else {
          Get.back();
          return const SizedBox();
        }
      }),
    );
    startTimer();
  }

  void countdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        timer.cancel();
        isDialogVisible.value = false;
      }
    });
  }
}
