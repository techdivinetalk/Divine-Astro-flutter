import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/common_button.dart';
import 'package:divine_astrologer/screens/signature_module/controller/agreement_controller.dart';
import 'package:divine_astrologer/screens/signature_module/controller/signature_controller.dart';
import 'package:divine_astrologer/screens/signature_module/widget/siganture_textfiled.dart';
import 'package:divine_astrologer/screens/signature_module/widget/signature_draw_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

class SignatureView extends GetView<SignatureController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignatureController>(
      assignId: true,
      init: SignatureController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            forceMaterialTransparency: true,
            backgroundColor: appColors.white,
            title: Text("Your Signature",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                )),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: SignatureTextFiled(
                            onChanged: (value) {
                              if(value.isEmpty){
                                // controller.isRegenerate = false;
                                controller.update();
                              }
                            },
                            controller: controller.signature,
                            onTap: (){
                              // controller.resetScreen();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: appColors.guideColor,
                            ),
                            child: Icon(
                              Icons.send_outlined,
                              color: appColors.white,
                              // size: controller.isAILoading ? 30.0 : 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SignatureDrawContainer(
                    isRadius: controller.isRadius,
                    screenshotController: controller.screenshotController,
                    signatureKey: controller.signaturePadKey,
                    minimumStrokeWidth: controller.minimumStrokeWidth,
                    maximumStrokeWidth: controller.minimumStrokeWidth,
                    strokeColor: controller.selectedStrokeColor,
                    backgroundColor: controller.selectedBackgroundColor,
                    ContainerColor: controller.containerColor,
                    backgroundImage: controller.selectedBackgroundImage,
                    onDraw: (o, d) {
                      // controller.resetScreen();
                      controller.update();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CommonButton(
                        buttonText: "Submit",
                        buttonCallback: () {
                          controller.saveDrawSignature();
                        }),
                  ),
                ],
              ),
              // buildAnimatedWidget(
              //   context,
              //   controller,
              //   height: controller.isPenExpand ? MediaQuery
              //       .of(context)
              //       .size
              //       .height * 0.24 : 0.0,
              //   title: AppStrings.penSize,
              //   widget: Padding(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: responsiveWidth(15)),
              //     child: Column(
              //       children: [
              //         SizedBox(height: responsiveHeight(7.0)),
              //         Row(
              //           children: [
              //             AppText(
              //               AppStrings.size + ":",
              //               fontFamily: FontFamily.montserratBold,
              //               fontSize: responsiveText(16),
              //             ),
              //             SizedBox(width: responsiveWidth(10)),
              //             Expanded(
              //               child: SignatureSlider(
              //                 max: 10,
              //                 onChanged: (double value) {
              //                   controller.minimumStrokeWidth = value;
              //                   controller.update();
              //                 },
              //                 value: controller.minimumStrokeWidth,
              //               ),
              //             ),
              //             SizedBox(width: responsiveWidth(10)),
              //             AppText(
              //               controller.minimumStrokeWidth.toStringAsFixed(0)
              //                   .toString(),
              //               fontFamily: FontFamily.montserratBold,
              //               fontSize: responsiveText(18),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // buildAnimatedWidget(
              //   context,
              //   controller,
              //   height: controller.isColorExpand ? MediaQuery
              //       .of(context)
              //       .size
              //       .height * 0.32 : 0.0,
              //   title: AppStrings.penColor,
              //   widget: Column(
              //     children: [
              //       SizedBox(
              //         height: responsiveHeight(50),
              //         child: ListView.separated(
              //           physics: BouncingScrollPhysics(),
              //           padding: EdgeInsets.only(left: responsiveWidth(10.0)),
              //           itemCount: blackColorsShads.length,
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           itemBuilder: (context, index) {
              //             return GestureDetector(
              //               onTap: () {
              //                 controller.selectedStrokeColor =
              //                     blackColorsShads[index].color ??
              //                         AppColors.black;
              //                 controller.resetCheckMark();
              //                 blackColorsShads[index].isCheck?.value = true;
              //                 controller.update();
              //               },
              //               child: Stack(
              //                 alignment: Alignment.center,
              //                 children: [
              //                   Container(
              //                     width: responsiveWidth(50),
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10.0),
              //                         color: blackColorsShads[index].color),
              //                   ),
              //                   Icon(
              //                     Ionicons.checkmark_outline,
              //                     color: blackColorsShads[index].isCheck
              //                         ?.value == true
              //                         ? AppColors.white
              //                         : AppColors.transparent,
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //           separatorBuilder: (context, index) =>
              //               SizedBox(width: responsiveWidth(10.0)),
              //         ),
              //       ),
              //       SizedBox(height: responsiveHeight(15)),
              //       SizedBox(
              //         height: responsiveHeight(50),
              //         child: ListView.separated(
              //           physics: BouncingScrollPhysics(),
              //           padding: EdgeInsets.only(left: responsiveWidth(10.0)),
              //           itemCount: singleColorList.length,
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           itemBuilder: (context, index) {
              //             return singleColorList[index].color !=
              //                 AppColors.transparent ? GestureDetector(
              //               onTap: () {
              //                 controller.selectedStrokeColor =
              //                     singleColorList[index].color ??
              //                         AppColors.black;
              //                 controller.resetCheckMark();
              //                 singleColorList[index].isCheck?.value = true;
              //                 controller.update();
              //               },
              //               child: Stack(
              //                 alignment: Alignment.center,
              //                 children: [
              //                   Container(
              //                     width: responsiveWidth(50),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(10.0),
              //                       color: singleColorList[index].color,
              //                     ),
              //                   ),
              //                   Icon(
              //                     Ionicons.checkmark_outline,
              //                     color: singleColorList[index].isCheck
              //                         ?.value == true
              //                         ? AppColors.white
              //                         : AppColors.transparent,
              //                   ),
              //                 ],
              //               ),
              //             )
              //                 : SizedBox();
              //           },
              //           separatorBuilder: (context, index) =>
              //               SizedBox(width: responsiveWidth(
              //                   singleColorList[index].color !=
              //                       AppColors.transparent ? 10.0 : 0.0)),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // buildAnimatedWidget(
              //   context,
              //   controller,
              //   height: controller.isBackGroundExpand ? MediaQuery
              //       .of(context)
              //       .size
              //       .height * 0.31 : 0.0,
              //   title: AppStrings.background,
              //   widget: Column(
              //     children: [
              //       SizedBox(height: responsiveHeight(5.0)),
              //       SizedBox(
              //         height: responsiveHeight(45.0),
              //         child: ListView.separated(
              //           padding: EdgeInsets.symmetric(
              //               horizontal: responsiveWidth(10.0)),
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: singleColorList.length,
              //           itemBuilder: (context, index) =>
              //           index == 0 ? CommonWidget().commonContainer(
              //             icon: AppImages.edit,
              //             onTap: () {
              //               CommonWidget().colorPicker(
              //                 context: context,
              //                 onChanged: (value) {
              //                   controller.selectBGColor = value;
              //                 },
              //                 onPressed: () {
              //                   Get.back();
              //                   controller.selectGradientBackground = null;
              //                   controller.selectedBackgroundImage = "";
              //                   controller.selectedBackgroundColor =
              //                       controller.selectBGColor;
              //                   controller.containerColor = Colors.white;
              //                   controller.resetCheckMark();
              //                   controller.update();
              //                 },
              //               );
              //             },
              //           ) : index == 1 ? CommonWidget().commonContainer(
              //             icon: AppImages.photo,
              //             onTap: () {
              //               controller.pickImageGallery();
              //             },
              //           ) : index == 2 ? CommonWidget().commonContainer(
              //             icon: AppImages.autoGallery,
              //             onTap: () {
              //               controller.selectBackgroundImage();
              //             },
              //           ) : GestureDetector(
              //             onTap: () {
              //               controller.selectedBackgroundImage = "";
              //               controller.selectGradientBackground = null;
              //               controller.selectedBackgroundColor =
              //                   Colors.transparent;
              //               controller.containerColor =
              //                   singleColorList[index].color ?? AppColors.white;
              //               controller.resetCheckMark();
              //               singleColorList[index].isCheck?.value = true;
              //               controller.update();
              //             },
              //             child: Stack(
              //               alignment: Alignment.center,
              //               children: [
              //                 Container(
              //                   width: responsiveWidth(45.0),
              //                   padding: EdgeInsets.all(20),
              //                   decoration: BoxDecoration(
              //                       color: singleColorList[index].color,
              //                       borderRadius: BorderRadius.circular(10.0)
              //                   ),
              //                 ),
              //                 Icon(
              //                   Ionicons.checkmark_outline,
              //                   color: singleColorList[index].isCheck?.value ==
              //                       true ? AppColors.white : AppColors
              //                       .transparent,
              //                 ),
              //               ],
              //             ),
              //           ),
              //           separatorBuilder: (context, index) =>
              //               SizedBox(
              //                 width: 10,
              //               ),
              //         ),
              //       ),
              //       SizedBox(height: responsiveHeight(10.0)),
              //       SizedBox(
              //         height: responsiveHeight(45.0),
              //         child: ListView.separated(
              //           padding: EdgeInsets.symmetric(
              //               horizontal: responsiveWidth(10.0)),
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: gradientColorList.length,
              //           itemBuilder: (context, index) =>
              //               GestureDetector(
              //                 onTap: () {
              //                   if (gradientColorList[index].isPremium?.value ==
              //                       true &&
              //                       !Constants.isPremiumPurchase.value) {
              //                     Get.toNamed(Routes.PREMIUM);
              //                   } else {
              //                     controller.selectedBackgroundImage = "";
              //                     controller.containerColor = AppColors.white;
              //                     controller.selectedBackgroundColor =
              //                         AppColors.transparent;
              //                     controller.selectGradientBackground =
              //                         gradientColorList[index].list ??
              //                             [AppColors.white];
              //                     controller.resetCheckMark();
              //                     gradientColorList[index].isCheck?.value =
              //                     true;
              //                     controller.update();
              //                   }
              //                 },
              //                 child: Stack(
              //                   alignment: Alignment.center,
              //                   children: [
              //                     Container(
              //                       width: responsiveWidth(45.0),
              //                       padding: EdgeInsets.all(20),
              //                       decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(
              //                               10.0),
              //                           gradient: LinearGradient(
              //                             begin: Alignment.topLeft,
              //                             end: Alignment.bottomRight,
              //                             colors: gradientColorList[index]
              //                                 .list ?? [AppColors.white],
              //                           )
              //                       ),
              //                     ),
              //                     Icon(
              //                       Ionicons.checkmark_outline,
              //                       color: gradientColorList[index].isCheck
              //                           ?.value == true
              //                           ? AppColors.white
              //                           : AppColors.transparent,
              //                     ),
              //                     Obx(() =>
              //                     (gradientColorList[index].isPremium?.value ==
              //                         true &&
              //                         !Constants.isPremiumPurchase.value)
              //                         ? Positioned(
              //                       right: 0.0,
              //                       top: 0.0,
              //                       child: CommonWidget.commonCrownWidget(),
              //                     )
              //                         : SizedBox())
              //                   ],
              //                 ),
              //               ),
              //           separatorBuilder: (context, index) =>
              //               SizedBox(
              //                 width: 10,
              //               ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
