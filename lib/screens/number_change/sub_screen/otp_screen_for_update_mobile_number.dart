import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/screens/bank_details/widgets.dart';
import 'package:divine_astrologer/screens/number_change/number_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpVerificationForNumberChange
    extends GetView<NumberChangeReqController> {
  const OtpVerificationForNumberChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.transparent,
      ),
      child: WillPopScope(
        onWillPop: () async {
          controller.pinController.clear();
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                BackNavigationWidget(
                  onPressedBack: () {
                    controller.pinController.clear();
                    Get.back();
                  },
                  title: "otpVerification".tr,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      const OtpVerificationField(),
                      OtpFieldView(
                        controller: controller.pinController,
                        focusNode: controller.focusNodeOtp,
                      ),
                      const InCorrectOtpWidget(),
                      SizedBox(height: 12.h),
                      NotReceiveOtpText(
                        onResend: () => controller.sendOtpForNumberChange(),
                      ),
                      CustomMaterialButton(
                        buttonName: "submit".tr,
                        textColor: AppColors.brownColour,
                        onPressed: () {
                          controller.verifyOtpForNumberChange();
                        },
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

class OtpVerificationField extends GetView<NumberChangeReqController> {
  const OtpVerificationField({
    Key? key,
  }) : super(key: key);

  TextStyle get descriptionTextStyle => TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: FontFamily.poppins,
        color: AppColors.darkBlue,
        fontSize: 16.sp,
      );

  TextStyle get mobileNumberTextStyle => TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.darkBlue,
        fontFamily: FontFamily.poppins,
        fontSize: 16.sp,
      );

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
            "${controller.countryCode.value} ${controller.controller.text}",
            style: mobileNumberTextStyle,
          ),
        )
      ],
    );
  }
}

class NotReceiveOtpText extends StatelessWidget {
  const NotReceiveOtpText({Key? key, required this.onResend}) : super(key: key);

  final void Function() onResend;

  TextStyle get textStyle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.darkBlue,
        fontFamily: FontFamily.poppins,
      );

  TextStyle get resendTextStyle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.darkBlue,
        fontFamily: FontFamily.poppins,
        decoration: TextDecoration.underline,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "notReceiveOTP".tr,
          style: textStyle,
        ),
        CustomButton(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          onTap: onResend,
          child: Text(
            "resend".tr,
            style: resendTextStyle,
          ),
        ),
      ],
    );
  }
}

class OtpFieldView extends StatelessWidget {
  const OtpFieldView({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 22.0.sp),
      child: PinInputTextField(
        pinLength: 6,
        keyboardType: TextInputType.number,
        controller: controller,
        focusNode: focusNode,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: CirclePinDecoration(
          strokeWidth: 2.sp,
          strokeColorBuilder: PinListenColorBuilder(
            AppColors.lightYellow,
            AppColors.lightYellow,
          ),
        ),
        onChanged: onChanged,
        onSubmit: onSubmit,
      ),
    );
  }
}

Future<void> showOtpSheet(
        {required BuildContext context, required String message}) async =>
    await showModalBottomSheet(
      context: context,
      builder: (context) => OtpSheet(message: message),
    );

class OtpSheet extends StatelessWidget {
  const OtpSheet({Key? key, required this.message}) : super(key: key);

  final String message;

  TextStyle get textStyle => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        color: AppColors.redColor,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.sp),
        topRight: Radius.circular(20.sp),
      ),
      child: SizedBox(
        width: context.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.h),
              child: Assets.svg.loginLogo.svg(height: 70.h, width: 160.w),
            ),
            Text(
              "noAttemptsLeft".tr,
              style: textStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              message,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CustomMaterialButton(
                buttonName: "okay".tr,
                onPressed: () {
                  Navigator.of(context).popUntil(
                    ModalRoute.withName(RouteName.dashboard),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class InCorrectOtpWidget extends StatelessWidget {
  const InCorrectOtpWidget({
    Key? key,
  }) : super(key: key);

  TextStyle get currentOtpStyle => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        color: AppColors.redColor,
        fontFamily: FontFamily.poppins,
      );

  TextStyle get attemptsStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.sp,
        color: AppColors.darkBlue,
        fontFamily: FontFamily.poppins,
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NumberChangeReqController>(
      builder: (controller) {
        if (controller.errorMessage == null) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.errorMessage != null)
              Expanded(
                child: Text(
                  "${controller.errorMessage}",
                  style: currentOtpStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (controller.errorMessage == null) const SizedBox(),
            Text.rich(
              TextSpan(
                text: "${"attemptsRemaining".tr} : ",
                children: [
                  TextSpan(
                    text: "${controller.remainingCount}",
                    style: currentOtpStyle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              style: attemptsStyle,
            )
          ],
        );
      },
    );
  }
}
