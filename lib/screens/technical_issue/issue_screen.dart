import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'issue_controller.dart';

class TechnicalIssueScreen extends GetView<TechnicalIssueController> {
  TechnicalIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TechnicalIssueController>(
      init: TechnicalIssueController(UserRepository()),
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
              "Technical Issues",
              style: AppTextStyle.textStyle16(),
            ),
            // centerTitle: true,
            actions: [
              // IconButton(
              //   iconSize: 20,
              //   onPressed: () {
              //     Get.toNamed(RouteName.allTechnicalIssues);
              //   },
              //   icon: Icon(Icons.history),
              // ),
              InkWell(
                onTap: () {
                  Get.toNamed(RouteName.allTechnicalIssues);
                },
                child: Text(
                  "Tickets",
                  style: TextStyle(
                    color: AppColors().black,
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
                    title: "Description",
                    maxLines: 5,
                    textInputFormatter: [CustomSpaceInputFormatter()],
                    controller: controller.descriptionController,
                    maxLength: 500,
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
                                    imagePath: controller.poojaImageUrl.isEmpty
                                        ? Assets.images.icUploadStory.path
                                        : controller.poojaImageUrl,
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
                          controller.submitIssues();
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: appColors.textColor.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    // child:Text("Ticket"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
