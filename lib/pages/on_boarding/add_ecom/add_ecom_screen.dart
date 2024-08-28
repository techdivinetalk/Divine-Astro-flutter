import 'dart:io';

import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/add_ecom/add_ecom_controller.dart';
import 'package:divine_astrologer/pages/on_boarding/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_image_view.dart';
import '../../../common/custom_widgets.dart';
import '../../../gen/assets.gen.dart';

class AddEcomScreen extends GetView<AddEcomController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEcomController>(
      assignId: true,
      init: AddEcomController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: appColors.white,
          appBar: AppBar(
            backgroundColor: AppColors().white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4),
                constraints: BoxConstraints.loose(Size.zero),
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titleSpacing: 0,
            title: Text(
              "Add Ecommerce",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.darkBlue,
              ),
            ),
            actions: [
              Text(
                "Skip",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 25,
                            color: appColors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              "You can upload products or pujas, which will be listed on your profile with a chat option for users to purchase, after approval.",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: appColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Remedy Type',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 10),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    menuMaxHeight: 200,
                    borderRadius: BorderRadius.circular(14),
                    disabledHint: Text(
                      'Please select',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: appColors.black,
                      ),
                    ),
                    // underline: SizedBox(),
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      // labelText: widget.labelText,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: appColors.black,
                      ),
                      // prefixIcon: widget.prefixIcon,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: appColors.textColor.withOpacity(0.2)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: appColors.textColor.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: appColors.textColor.withOpacity(0.2)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: appColors.textColor.withOpacity(0.2)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: appColors.textColor.withOpacity(0.2)),
                      ),
                    ),
                    hint: Text(
                      'Please select Types',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: appColors.black,
                      ),
                    ), // Not necessary for Option 1
                    value:
                        controller.selected != '' ? controller.selected : null,
                    // value: controller.selected,
                    onChanged: (newValue) {
                      controller.selectedDropDown(newValue);
                    },
                    items: controller.dropDownItems.map((data) {
                      return DropdownMenuItem(
                        value: data,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            data,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: appColors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                controller.selected == "Puja"
                    ? Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: appColors.textColor.withOpacity(0.2),
                              ),
                            ),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: controller.tags
                                  .map<Widget>((element) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 6.h),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w,
                                                  vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: appColors.guideColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 1.0,
                                                      offset: const Offset(
                                                          0.0, 3.0)),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                              ),
                                              child: Text(
                                                element.name.toString(),
                                                style: AppTextStyle.textStyle14(
                                                    fontColor: appColors.white),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            InkWell(
                                              onTap: () {
                                                // controller.tagIndexes.removeAt(
                                                //     controller.tags.indexWhere(
                                                //         (val) => val.id == element.id));
                                                controller.tags.removeWhere(
                                                    (val) =>
                                                        val.id == element.id);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all()),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()
                                ..add(InkWell(
                                  onTap: () {
                                    // openBottomSheet(context, functionalityWidget:
                                    //     StatefulBuilder(
                                    //         builder: (context, state) {
                                    //   return Padding(
                                    //     padding: const EdgeInsets.all(8),
                                    //     child: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         ChipsChoice<int>.multiple(
                                    //           spacing: 10,
                                    //           value: controller.tagIndexes,
                                    //           onChanged: (val) {
                                    //             controller.tagIndexes.clear();
                                    //             controller.tags.clear();
                                    //             for (int element in val) {
                                    //               controller.tagIndexes
                                    //                   .add(element);
                                    //               controller.tags.add(controller
                                    //                   .options[element]);
                                    //             }
                                    //             state(() {});
                                    //           },
                                    //           choiceItems:
                                    //               C2Choice.listFrom<int, String>(
                                    //             source: controller.options
                                    //                 .map((e) => e.name.toString())
                                    //                 .toList(),
                                    //             value: (i, v) => i,
                                    //             label: (i, v) => v,
                                    //             tooltip: (i, v) => v,
                                    //             delete: (i, v) => () {
                                    //               controller.options.removeAt(i);
                                    //             },
                                    //           ),
                                    //           choiceStyle: C2ChipStyle.toned(
                                    //             iconSize: 0,
                                    //             backgroundColor: Colors.white,
                                    //             selectedStyle: C2ChipStyle.filled(
                                    //               selectedStyle: C2ChipStyle(
                                    //                 foregroundStyle:
                                    //                     AppTextStyle.textStyle16(
                                    //                         fontColor:
                                    //                             appColors.white),
                                    //                 borderWidth: 1,
                                    //                 backgroundColor:
                                    //                     appColors.darkBlue,
                                    //                 borderStyle:
                                    //                     BorderStyle.solid,
                                    //                 borderRadius:
                                    //                     const BorderRadius.all(
                                    //                         Radius.circular(25)),
                                    //               ),
                                    //             ),
                                    //             borderWidth: 1,
                                    //             borderStyle: BorderStyle.solid,
                                    //             borderColor: appColors.darkBlue,
                                    //             borderRadius:
                                    //                 const BorderRadius.all(
                                    //               Radius.circular(20),
                                    //             ),
                                    //           ),
                                    //           wrapped: true,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   );
                                    // }));
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.h, top: 4.h),
                                    child: Container(
                                      width: ScreenUtil().screenWidth / 3.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 1,
                                              color: appColors.darkBlue)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 9.h, bottom: 9.h),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: appColors.darkBlue,
                                              size: 19.sp,
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              "Add Skills".tr,
                                              style: AppTextStyle.textStyle12(
                                                  fontColor: appColors.darkBlue,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                InkWell(
                  onTap: () {
                    controller.updateProfileImage();
                  },
                  child: controller.selectedImage == null
                      ? CircleAvatar(
                          backgroundColor: appColors.grey.withOpacity(0.3),
                          radius: 40,
                          child: Icon(
                            Icons.add,
                            color: appColors.white,
                            size: 50,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: appColors.grey.withOpacity(0.1),
                            child: Image.file(
                              File(controller.selectedImage.toString()),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    'Upload Image',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: appColors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remedy Name*',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        hint: "",
                        maxLength: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remedy Description',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 100,
                        child: CustomTextField(
                          hint: "",
                          maxLength: 500,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remedy Price ( In INR )*',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        hint: "",
                        maxLength: 20,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '*Mandatory Field',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: appColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: controller.selected == null ? 60 : 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        text:
                            '* Confused? Don’t worry, We are here to help you! ',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: appColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Click here for a tutorial video.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.poppins,
                              fontWeight: FontWeight.w400,
                              color: appColors.red,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle tap
                                print('Link tapped');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.selected == null
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                updateProfileImage(
                                    controller.selected.toString());
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: appColors.red,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Submit ${controller.selected.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                      color: AppColors().white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  updateProfileImage(selected) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return Material(
          color: appColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  color: appColors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    CommonImageView(
                      imagePath: "assets/images/done.png",
                      height: 50,
                      width: 50,
                      placeHolder: Assets.images.defaultProfile.path,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      '$selected Submitted'.tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      'We will review your product details to begin showcasing on your profile for purchase.'
                          .tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.grey,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: appColors.red,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: AppColors().white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
