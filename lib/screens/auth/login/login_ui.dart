import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/auth/login/true_caller_fault_widget.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/colors.dart';
import '../../../true_caller_divine/true_caller_divine_service.dart';
import '../../live_page/constant.dart';
import 'login_controller.dart';

class LoginUI extends GetView<LoginController> {
  LoginUI({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get.put(LoginController(UserRepository()));
    return GetBuilder<LoginController>(
        init: LoginController(UserRepository()),
        assignId: true,
        builder: (controller) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Assets.images.divineLogo
                              .image(width: ScreenUtil().screenWidth * 0.55),
                        ),
                        SizedBox(height: 10.h),
                        ImageSliderWidget(
                          controller: controller,
                        ),
                        TextWithDivider(
                          text: 'Log in or Sign up',
                          textColor: appColors.greyColor,
                          dividerHeight: 1.0,
                        ),
                        SizedBox(height: 20.h),
                        mobileField(),
                        SizedBox(height: 5.h),
                        Center(
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 8.h),
                                child: Text.rich(
                                    textAlign: TextAlign.center,
                                    TextSpan(children: [
                                      WidgetSpan(
                                        child: Text(
                                          "By signing up, you agree to our ",
                                          style: TextStyle(
                                            color: appColors.textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => Get.toNamed(
                                              RouteName.termsCondition),
                                          child: Text(
                                            "terms of use",
                                            style: TextStyle(
                                              color: appColors.textColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Text(
                                          " ${"and".tr} ",
                                          style: TextStyle(
                                            color: appColors.textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                          child: GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () => Get.toNamed(
                                                  RouteName.privacyPolicy),
                                              child: Text("privacy policy",
                                                  style: TextStyle(
                                                      color:
                                                          appColors.textColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration: TextDecoration
                                                          .underline))))
                                    ])))),
                        SizedBox(height: 20.h),
                        Obx(() {
                          return GestureDetector(
                            onTap: controller.enable.value
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.login();
                                      // controller.enable.value = false;
                                    }
                                  }
                                : () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: appColors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: !controller.isLoading.value
                                  ? Text(
                                      "Send OTP",
                                      style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600,
                                        fontColor: appColors.white,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      strokeWidth: 3, color: appColors.brown),
                            ),
                          );
                        }),
                        SizedBox(height: 20.h),
                        Obx(() => Visibility(
                            visible: controller.enable.value &&
                                isTruecaller.value.toString() == "1" || kDebugMode,
                            child: TextWithDivider(
                              text: 'Or',
                              textColor: appColors.greyColor,
                              dividerHeight: 1.0,
                            ))),
                        SizedBox(height: 20.h),
                        Obx(() {
                          print(
                              "showTrueCaller ${controller.showTrueCaller.value}");
                          return Visibility(
                            visible: kDebugMode || (controller.showTrueCaller.value &&
                                controller.enable.value &&
                                isTruecaller.value.toString() == "1"),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: Color(0xff0087FF),
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool oAuthFlowUsable = false;
                                    oAuthFlowUsable = await TrueCallerService()
                                        .isOAuthFlowUsable();

                                    if(Get.currentRoute == RouteName.login){
                                      oAuthFlowUsable
                                        ? await TrueCallerService()
                                        .startTrueCaller()
                                        : controller.trueCallerFaultPopup();
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          "assets/images/true_caller_icon.png"),
                                      const SizedBox(width: 16),
                                      const Text(
                                        "Login with TrueCaller",
                                        style: TextStyle(
                                          color: Color(0xff0087FF),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget mobileField() {
    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
              color: controller.enable.value
                  ? Colors.white
                  : Colors.black.withOpacity(0.3),
              blurRadius: 3.0,
              offset: const Offset(0.3, 3.0)),
        ]),
        child: TextFormField(
          focusNode: controller.numberFocus,
          validator: (value) {
            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            RegExp regExp = RegExp(pattern);
            if (value!.isEmpty) {
              return 'mobileNumberEmptyMsg'.tr;
            } else if (value.length != 10) {
              return 'mobileNumber10Digits'.tr;
            } else if (!regExp.hasMatch(value)) {
              return 'validPhoneNumber'.tr;
            }
            return null;
          },
          onTapOutside: (value) => FocusScope.of(Get.context!).unfocus(),
          controller: controller.mobileNumberController,
          keyboardType: TextInputType.number,
          // enabled: controller.enable.value,
          maxLength: 10,
          showCursor: true,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            counterText: '',
            hintText: "Enter mobile number",
            fillColor: appColors.white,
            hintStyle: AppTextStyle.textStyle16(fontColor: appColors.greyColor),
            prefixIcon: InkWell(
              onTap: () => countryPickerSheet(Get.context!, (value) {
                controller.setCode(value.phoneCode);
                Get.back();
              }),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(width: 15),
                Text(
                  controller.countryCode.value,
                ),
                const Icon(Icons.arrow_drop_down)
              ]),
            ),
            filled: true,
            errorStyle:
                AppTextStyle.textStyle16(fontColor: appColors.appRedColour),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: appColors.greyColor,
                  width: 1.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: appColors.guideColor,
                  width: 1.0,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: appColors.redColor,
                  width: 1.0,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: appColors.redColor,
                  width: 1.0,
                )),
          ),
          onChanged: (value) {
            controller.mobile = value;
          },
        ),
      ),
    );
  }
}

class ImageSliderWidget extends StatefulWidget {
  ImageSliderWidget({required this.controller});
  LoginController controller;
  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  // final controller = Get.find<LoginController>();
  int swipeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() => swipeIndex = index);
            },
            height: ScreenUtil().screenHeight * 0.350,
            viewportFraction: 1,
            autoPlay: true,
          ),
          items: widget.controller.staticImages
              .asMap()
              .entries
              .map((item) => Column(
                    children: [
                      item.value.expand(),
                      Text(widget.controller.imageDec[item.key],
                              textAlign: TextAlign.center)
                          .centered()
                    ],
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.controller.staticImages
              .asMap()
              .entries
              .map(
                (e) => Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 2.w),
                  child: e.key == swipeIndex
                      ? Assets.svg.pinkSlider.svg(
                          colorFilter: ColorFilter.mode(
                              appColors.greyColor, BlendMode.srcIn))
                      : Assets.svg.blackDot.svg(),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

/// Test Divider
class TextWithDivider extends StatelessWidget {
  final String text;
  final Color textColor;
  final double dividerHeight;

  const TextWithDivider({
    super.key,
    required this.text,
    this.textColor = Colors.black,
    this.dividerHeight = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          height: dividerHeight,
          color: Colors.grey[300],
        ).expand(),
        SizedBox(
          width: 10.w,
        ),
        Center(
          child: CustomText(
            text,
            fontColor: textColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Container(
          height: dividerHeight,
          color: Colors.grey[300],
        ).expand(),
      ],
    );
  }
}
