import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/financial_support/financial_support_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../common/SvgIconButton.dart';
import '../../common/app_textstyle.dart';
import '../../common/common_image_view.dart';
import '../../common/custom_widgets.dart';
import '../../common/permission_handler.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../repository/user_repository.dart';
import '../add_puja/add_puja_controller.dart';
import '../puja/widget/remedy_text_filed.dart';

class FinancialSupportScreen extends GetView<FinancialSupportController> {
  FinancialSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinancialSupportController>(
      init: FinancialSupportController(UserRepository()),
      builder: (_) {
        return Scaffold(
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
              "Financial Support",
              style: AppTextStyle.textStyle16(),
            ),
            // centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(RouteName.allFinancialSupportIssues);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors().red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Current Tickets",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors().black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(),
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
                      value: controller.selected != ''
                          ? controller.selected
                          : null,
                      // value: controller.selected,
                      onChanged: (newValue) {
                        controller.selectedDropDown(newValue);
                      },
                      items: controller.dropDownItems.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              location,
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
                  const SizedBox(
                    height: 20,
                  ),
                  PoojaRemedyTextFiled(
                    title: "Please explain your issue in detail",
                    maxLines: 5,
                    textInputFormatter: [CustomSpaceInputFormatter()],
                    controller: controller.descriptionController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      controller.update();
                    },
                    isSuffix: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: appColors.textColor.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    if (await PermissionHelper()
                                        .askMediaPermission()) {
                                      controller.updateProfileImage();
                                    }
                                  },
                                  child: CommonImageView(
                                    imagePath: Assets.images.icUploadStory.path,
                                    fit: BoxFit.cover,
                                    height: 90.h,
                                    width: 90.h,
                                    placeHolder:
                                        Assets.images.defaultProfile.path,
                                    radius: BorderRadius.circular(100.h),
                                  )),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: appColors.textColor,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgIconButton(
                                  height: 25.h,
                                  width: 25.w,
                                  svg: Assets.svg.icPoojaAddress.svg(
                                    color: appColors.white,
                                    height: 25.h,
                                    width: 25.w,
                                  ),
                                  onPressed: () async {
                                    if (await PermissionHelper()
                                        .askMediaPermission()) {
                                      controller.updateProfileImage();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          CustomText(
                            'Upload Image',
                            fontColor: appColors.textColor,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...controller.selectedImages.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 30,
                                      child: Image.file(
                                        File(e),
                                        height: 60,
                                        width: 30,
                                        fit: BoxFit.cover,
                                      ),
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
                  SizedBox(height: 10.h),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    height: 48,
                    width: MediaQuery.of(context).size.width * 9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors().red,
                        border: Border.all(color: AppColors().red)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: Colors.red.withOpacity(0.5),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          // if (controller.descriptionController.text.length >
                          //     100) {
                          //   controller.uploadImagesListsFun();
                          // } else {
                          //   Fluttertoast.showToast(msg: "Detail is to short");
                          // }
                          if (controller.selected == null) {
                            Fluttertoast.showToast(msg: "Select Issue type");
                          } else if (controller
                                  .descriptionController.text.length <
                              100) {
                            Fluttertoast.showToast(msg: "Detail is to short");
                          } else if (controller.selectedFiles.isEmpty) {
                            Fluttertoast.showToast(msg: "Select Images");
                          } else {
                            controller.uploadImagesListsFun();
                          }
                        },
                        child: Center(
                          child: controller.isLoading.value == true
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors().white,
                                )
                              : Text(
                                  "Submit Issue",
                                  style: AppTextStyle.textStyle16(
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColors().white,
                                  ).copyWith(fontFamily: "Metropolis"),
                                ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.9,
                  //   height: 300,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: appColors.textColor.withOpacity(0.2)),
                  //     borderRadius: BorderRadius.circular(14),
                  //   ),
                  //   child: Html(
                  //     shrinkWrap: true,
                  //     data: controller.htmlCode,
                  //     onLinkTap: (url, attributes, element) {
                  //       launchUrl(Uri.parse(url ?? ''));
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
