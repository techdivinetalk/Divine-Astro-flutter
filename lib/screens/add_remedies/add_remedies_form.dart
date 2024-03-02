import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_text_field.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/add_remedies/add_remedies_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddRemedies extends GetView<AddRemediesController> {
  const AddRemedies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColors.white,
          surfaceTintColor: appColors.white,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title:  Obx(() => controller.id == 0 ? CustomText('Add Remedies',) : CustomText('Edit Remedies'))),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  if (controller.formKey.currentState?.validate() ?? false) {
                  }
                },
                child: Text(
                  'Add Puja',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: appColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              durationWidget(),
              SizedBox(height: 40.h),
              Column(
                children: [
                  InkWell(
                      onTap: () async {
                        if (await PermissionHelper()
                            .askMediaPermission()) {
                          controller.updateProfileImage();
                        }
                      },
                      child: CommonImageView(
                        imagePath: Assets
                            .images.icUploadStory.path,
                        fit: BoxFit.cover,
                        height: 90.h,
                        width: 90.h,
                        placeHolder: Assets
                            .images.defaultProfile.path,
                        radius: BorderRadius.circular(
                            100.h),
                      )),
                  SizedBox(height: 10.h),
                  CustomText('Upload Puja Image',fontColor: appColors.textColor,)
                ],
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                topLabel: CustomText('Puja Name', fontColor: appColors.textColor,),
                maxLength: 20,
                suffixIconPadding: 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Puja Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                topLabel: CustomText('Puja Description',fontColor: appColors.textColor,),
                maxLines: 5,
                maxLength: 100,
                suffixIconPadding: 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Puja Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                textInputFormatter: [LengthLimitingTextInputFormatter(10)],
                topLabel: CustomText('Puja Price ( In INR )', fontColor: appColors.textColor,),
                suffixIconPadding: 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Puja Price is required';
                  }
                  // Additional validation logic can be added here
                  return null;
                },
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Remedy Type',
          fontColor: appColors.textColor,
        ),
        SizedBox(height: 8.h), // Adjust the spacing between label and container
        Container(
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
              width: 1.0, // Adjust the border width as needed
            ),
          ),
          child: durationOptions(),
        ),
      ],
    );
  }

  Widget durationOptions() {
    return Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "puja",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            ),
            items: controller.durationOptions
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          item.tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400,
                              fontColor: appColors.darkBlue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "daily".tr;
            },
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              iconSize: 35,
              iconEnabledColor: appColors.blackColor,
            ),
            dropdownStyleData: DropdownStyleData(
              width: ScreenUtil().screenWidth * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: appColors.white,
              ),
              offset: const Offset(-8, -17),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(false),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ));
  }
}