import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/custom_light_yellow_btn.dart';
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.h, bottom: 50.h),
                    child: Assets.images.divineLogo
                        .image(width: ScreenUtil().screenWidth * 0.55),
                  ),
                  GetBuilder<LoginController>(
                    builder: (controller) => imageSlider(),
                  ),
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
                  Obx(
                    () => CustomLightYellowButton(
                      name: "Verify",
                      onTaped: controller.enable.value
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                controller.enable.value = false;
                                controller.login();
                              }
                            }
                          : () {},
                    ),
                  )
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
          height: ScreenUtil().screenHeight * 0.40,
          viewportFraction: 1,
          autoPlay: true),
      items: controller.images
          .asMap()
          .entries
          .map((item) => Column(
                children: [
                  //item.value,
                  //SizedBox(height: 10.h),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: LoadImage(
                      boxFit: BoxFit.fitHeight,
                      imageModel: ImageModel(
                        placeHolderPath: Assets.images.defaultProfile.path,
                        imagePath: item.value.getImageUrl(controller.amazonUrl),
                        loadingIndicator: SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: const CircularProgressIndicator(
                            color: Color(0XFFFDD48E),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Html(
                          data: controller.images[item.key].descriptioin
                              .toString(),
                        )),
                  ),
                ],
              ))
          .toList(),
    );
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Valid Phone Number';
              } else if (value.length != 10) {
                return 'Mobile number should be 10 digits';
              }
              return null;
            },
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
              hintText: "Enter Registered Number",
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
