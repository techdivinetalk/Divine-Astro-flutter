import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/auth/login/true_caller_fault_widget.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:divine_astrologer/true_caller_divine/true_caller_divine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/colors.dart';
import 'login_controller.dart';

class LoginUI extends GetView<LoginController> {
  LoginUI({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  const ImageSliderWidget(),
                  SizedBox(height: 5.h),
                  mobileField(),
                  SizedBox(height: 5.h),
                  Text(
                    "verificationHintText".tr,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: controller.enable.value
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              controller.enable.value = false;
                              controller.login();
                            }
                          }
                        : () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            "verify".tr,
                            style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.brownColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: controller.showTrueCaller.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              oAuthFlowUsable =
                                  await TrueCallerService().isOAuthFlowUsable();

                              oAuthFlowUsable
                                  ? await TrueCallerService().startTrueCaller()
                                  : trueCallerFaultPopup();
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
  }

  Future<void> trueCallerFaultPopup() async {
    await showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return TrueCallerFaultWidget(onClose: Get.back);
      },
    );
    return Future<void>.value();
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
        child: GetBuilder<LoginController>(
          builder: (controller) => TextFormField(
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
            enabled: controller.enable.value,
            maxLength: 10,
            showCursor: true,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              counterText: '',
              hintText: "enterRegisteredNumber".tr,
              fillColor: AppColors.white,
              hintStyle:
                  AppTextStyle.textStyle16(fontColor: AppColors.greyColor),
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
                  AppTextStyle.textStyle16(fontColor: AppColors.appRedColour),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.appYellowColour,
                    width: 1.0,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.appYellowColour,
                    width: 1.0,
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.redColor,
                    width: 1.0,
                  )),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.redColor,
                    width: 1.0,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageSliderWidget extends StatefulWidget {
  const ImageSliderWidget({Key? key}) : super(key: key);

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  final controller = Get.find<LoginController>();
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
            height: ScreenUtil().screenHeight * 0.464,
            viewportFraction: 1,
            autoPlay: true,
          ),
          items: controller.staticImages
              .asMap()
              .entries
              .map((item) => Column(
                    children: [
                      item.value.expand(),
                      Text(controller.imageDec[item.key]).centered()
                    ],
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.staticImages
              .asMap()
              .entries
              .map(
                (e) => Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 2.w),
                  child: e.key == swipeIndex
                      ? Assets.svg.pinkSlider.svg(
                          colorFilter: const ColorFilter.mode(
                              AppColors.appYellowColour, BlendMode.srcIn))
                      : Assets.svg.blackDot.svg(),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
