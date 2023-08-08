import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/custom_light_yellow_btn.dart';
import 'login_controller.dart';

class LoginUI extends GetView<LoginController> {
  const LoginUI({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.h, bottom: 50.h),
                    child: Assets.images.divineLogo
                        .image(width: ScreenUtil().screenWidth * 0.55),
                  ),
                  imageSlider(),
                  SizedBox(height: 10.h),
                  mobileField(),
                  SizedBox(height: 10.h),
                  Text(
                    "You will get a call on the number given above for verification",
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomLightYellowButton(
                    name: "Verify",
                    onTaped: () {
                      // if (controller.formKey.currentState!.validate()) {
                      //   controller.formKey.currentState!.save();
                      // } else {}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageSlider() {
    return CarouselSlider(
      options: CarouselOptions(
          height: ScreenUtil().screenHeight * 0.33, viewportFraction: 1),
      items: controller.imgList
          .map((item) => Column(
                children: [
                  item,
                  SizedBox(height: 10.h),
                  Center(
                    child: SizedBox(
                        child: Text(
                      controller.infoList[0],
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ))
          .toList(),
    );
  }

  Widget mobileField() {
    return Container(
      alignment: Alignment.center,
      height: 50.h,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: const Offset(0.3, 3.0)),
      ]),
      child: GetBuilder<LoginController>(
        builder: (controller) => TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Registered Number",
            fillColor: AppColors.white,
            hintStyle: AppTextStyle.textStyle16(fontColor: AppColors.greyColor),
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
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: controller.hasError.value
                      ? AppColors.appRedColour
                      : AppColors.white,
                  width: 1.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.appYellowColour,
                  width: 1.0,
                )),
          ),
        ),
      ),
    );
  }
}
