import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pinput/pinput.dart';

import '../../common/colors.dart';
import '../../common/custom_widgets.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../bank_details/widgets.dart';
import 'otp_verification_controller.dart';

class OtpVerificationUI extends GetView<OtpVerificationController> {
  const OtpVerificationUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:  SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: appColors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BackNavigationWidget(
                    onPressedBack: () => Get.back(),
                    title: "otpVerification".tr),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),
                      Assets.images.otpImage.svg(height: 293.w, width: 293.w),
                      SizedBox(height: 50.h),
                      OtpVerificationField(),
                      OtpFieldView(
                          controller: controller.pinController,
                          onChanged: (value) =>
                              controller.otpLength.value = value.trim().length),
                      InCorrectOtpWidget(),
                      SizedBox(height: 12.h),
                      Obx(
                        () => controller.isResendOtp.value
                            ? SizedBox(
                                height: 30.h,
                                width: 30.h,
                                child:  CircularProgressIndicator(
                                    strokeWidth: 3, color: appColors.brown),
                              )
                            : NotReceiveOtpText(
                                onResend: () => controller.resendOtp(),
                              ),
                      ),
                      Obx(
                        () => controller.enableSubmit.value
                            ? CustomMaterialButton(
                                buttonName: "submit".tr,
                                radius: 10.sp,
                                textColor: appColors.brown,
                                disabledColor:
                                    appColors.guideColor.withOpacity(0.5),
                                onPressed: controller.otpLength.value == 6
                                    ? () {
                                        if (controller.attempts.value == 0) {
                                          showOtpSheet(context);
                                        } else {
                                          controller.verifyOtp();
                                          // controller.enableSubmit.value = false;
                                        }
                                      }
                                    : null,
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(vertical: 15.sp),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        height: 55.h,
                                        disabledColor: appColors.guideColor,
                                        highlightElevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(79.sp)),
                                        onPressed: null,
                                        child: SizedBox(
                                            height: 30.h,
                                            width: 30.h,
                                            child:
                                                 CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    color: appColors.brown)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpVerificationField extends StatelessWidget {
  OtpVerificationField({
    Key? key,
  }) : super(key: key);
  final controller = Get.find<OtpVerificationController>();

  TextStyle get descriptionTextStyle => TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.notoSans,
      color: appColors.darkBlue,
      fontSize: 16.sp);

  TextStyle get mobileNumberTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: appColors.darkBlue,
      fontFamily: FontFamily.notoSans,
      fontSize: 16.sp);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "otpTextMsg".tr,
          style: descriptionTextStyle,
        ),
        Obx(
          () => Text(
            "${controller.countryCode} ${controller.number.value}",
            style: mobileNumberTextStyle,
          ),
        )
      ],
    );
  }
}

class NotReceiveOtpText extends StatefulWidget {
  const NotReceiveOtpText({Key? key, required this.onResend}) : super(key: key);

  final VoidCallback onResend;

  @override
  State<NotReceiveOtpText> createState() => _NotReceiveOtpTextState();
}

class _NotReceiveOtpTextState extends State<NotReceiveOtpText> {
  late Timer _timer;
  int _remainingTime = 60;
  final controller = Get.find<OtpVerificationController>();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "notReceiveOTP".tr,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: appColors.textColor,
            fontFamily: FontFamily.notoSans,
          ),
        ),
        // SizedBox(width: 4.w),
        CustomButton(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          onTap: _remainingTime == 0 ? widget.onResend : () {},
          child: Text(
            _remainingTime == 0 ? "resend".tr : "Resend in $_remainingTime seconds",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: _remainingTime == 0 ? appColors.textColor : appColors.grey,
              fontFamily: FontFamily.notoSans,
              decoration: _remainingTime == 0 ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

class OtpFieldView extends StatelessWidget {
  OtpFieldView({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmit,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final contro = Get.find<OtpVerificationController>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 52.w,
      textStyle: TextStyle(
          color: contro.isWrongOtp.isTrue ? appColors.red : appColors.darkBlue,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
            color: contro.isWrongOtp.isTrue
                ? appColors.red.withOpacity(0.5)
                : appColors.guideColor.withOpacity(0.5),
            width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(
            color: contro.isWrongOtp.isTrue ? appColors.red : appColors.guideColor,
            width: 2),
        borderRadius: BorderRadius.circular(10));

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(
            color: contro.isWrongOtp.isTrue ? appColors.red : appColors.guideColor,
            width: 2),
        borderRadius: BorderRadius.circular(10));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22.0.sp),
      child: Column(
        children: [
          Pinput(
              length: 6,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsRetrieverApi,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              keyboardType: TextInputType.number,
              controller: controller,
              focusNode: focusNode,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onChanged: onChanged,
              onCompleted: onSubmit),

          // PinInputTextField(
          //     pinLength: 6,
          //     keyboardType: TextInputType.number,
          //     controller: controller,
          //     focusNode: focusNode,
          //     tapRegionCallback: (event) => FocusScope.of(context).unfocus(),
          //     cursor: Cursor(enabled: true, color: appColors.yellow, width: 2, height: 20),
          //     inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          //     textInputAction: TextInputAction.done,
          //     decoration: BoxLooseDecoration(
          //         textStyle: TextStyle(
          //             color: contro.isWrongOtp.isTrue ? appColors.red : appColors.darkBlue,
          //             fontSize: 20.sp,
          //             fontWeight: FontWeight.w600),
          //         strokeWidth: 2.sp,
          //         strokeColorBuilder: PinListenColorBuilder(
          //             contro.isWrongOtp.isTrue ? appColors.red : appColors.yellow,
          //             contro.isWrongOtp.isTrue
          //                 ? appColors.red.withOpacity(0.5)
          //                 : appColors.yellow.withOpacity(0.5))),
          //     onChanged: onChanged,
          //     onSubmit: onSubmit),
        ],
      ),
    );
  }
}

Future<void> showOtpSheet(BuildContext context) async =>
    await showModalBottomSheet(
      context: context,
      builder: (context) => const OtpSheet(),
    );

class OtpSheet extends StatelessWidget {
  const OtpSheet({Key? key}) : super(key: key);

  TextStyle get textStyle => TextStyle(
      fontWeight: FontWeight.w600, fontSize: 16.sp, color: appColors.red);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp)),
      child: SizedBox(
        width: context.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 30.h),
                child: Assets.svg.caution.svg(height: 70.h, width: 160.w)),
            Text("noAttemptsLeft".tr, style: textStyle),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: CustomMaterialButton(
                    radius: 10,
                    buttonName: "okay".tr,
                    onPressed: () {
                      Get.offAllNamed(RouteName.login);
                    })),
            SizedBox(height: 12.h)
          ],
        ),
      ),
    );
  }
}

class InCorrectOtpWidget extends StatelessWidget {
  InCorrectOtpWidget({
    Key? key,
  }) : super(key: key);
  final controller = Get.find<OtpVerificationController>();

  TextStyle get currentOtpStyle => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        color: appColors.red,
        fontFamily: FontFamily.notoSans,
      );

  TextStyle get attemptsStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.sp,
        color: appColors.darkBlue,
        fontFamily: FontFamily.notoSans,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => (controller.validationMsg.value.isNotEmpty)
            ? Text('Please Enter Correct OTP.',
                //  controller.validationMsg.value,
                style: currentOtpStyle)
            : const SizedBox.shrink()),
        Obx(() => controller.attempts.value < 3
            ? Text.rich(
                TextSpan(
                  text: "${"attemptsRemaining".tr} : ",
                  children: [
                    TextSpan(
                      text: controller.attempts.toString(),
                      style: currentOtpStyle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                style: attemptsStyle,
              )
            : const Offstage())
      ],
    );
  }
}
