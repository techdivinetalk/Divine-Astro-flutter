import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/model/pivacy_policy_model.dart';
import 'package:divine_astrologer/screens/terms_and_condition/terms_and_condition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/assets.dart';



class TermsAndConditionScreen extends GetView<TermsAndConditionController> {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsAndConditionController>(
      assignId: true,
      init: TermsAndConditionController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            leading: const SizedBox(),
            title: Text("Welcome to Divine talk Astrologer",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          body: FutureBuilder(
            future: controller.getPrivacyPolicy(),
            builder: (context, AsyncSnapshot<PrivacyPolicyModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          child: Html(data: snapshot.data!.data.privacyPolicy,
                            onLinkTap: (url, attributes, element) {
                              launchUrl(Uri.parse(url ?? ''));
                            },),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.isReadDone.value) {
                                controller.isIAgree.value =
                                !controller.isIAgree.value;
                              }
                            },
                            child: Transform.scale(
                                scale: 0.8,
                                child: Obx(() =>
                                !controller.isIAgree.value ? SvgPicture.asset(
                                  Assets.svgIcUnCheck,
                                  color: controller.isReadDone.value
                                      ? AppColors().darkBlue
                                      : AppColors().darkBlue.withOpacity(0.5),
                                ) : SvgPicture.asset(Assets.svgIcCheck),)),
                          ),
                          const SizedBox(width: 5.0,),
                          Text("I agree to our privacy policy.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: appColors.darkBlue,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const GenericLoadingWidget();
              }
              if (snapshot.hasError) {
                return Center(
                  child: CustomText("somethingWentWrong".tr, fontSize: 20.sp),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (!controller.isLoading.value &&
                      controller.isReadDone.value) {
                    controller.astroLogin();
                  }
                },
                child: Obx(() =>
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                        color: controller.isReadDone.value ? appColors
                            .guideColor : appColors.guideColor.withOpacity(0.5),
                        borderRadius:
                        BorderRadius.circular(
                            10.0),
                      ),
                      child: Obx(() =>
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5,
                      )
                          : Text(
                        "Next",
                        style: AppTextStyle
                            .textStyle16(
                          fontWeight:
                          FontWeight.w500,
                          fontColor:
                          appColors.white,
                        ),
                      )),
                    )),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .padding
                  .bottom + 10.0),
            ],
          ),
        );
      },
    );
  }

  Row buildRow(text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 7.0),
          child: CircleAvatar(radius: 3.0, backgroundColor: Colors.black,),
        ),
        const SizedBox(width: 5.0,),
        Expanded(
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                color: appColors.darkBlue,
              )),
        ),
      ],
    );
  }
}
