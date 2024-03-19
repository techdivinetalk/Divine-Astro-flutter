import 'package:divine_astrologer/common/SvgIconButton.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_text_field.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/add_puja/add_puja_controller.dart';
import 'package:divine_astrologer/screens/add_puja/model/puja_product_categories_model.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_ui.dart';
import 'package:divine_astrologer/screens/puja/widget/pooja_submited_sheet.dart';
import 'package:divine_astrologer/screens/puja/widget/remedy_text_filed.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widget/category_bottom_sheet.dart';

class AddPujaScreen extends GetView<AddPujaController> {
  const AddPujaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPujaController>(
      assignId: true,
      init: AddPujaController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: appColors.white,
              surfaceTintColor: appColors.white,
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              title: Obx(() => controller.id.value == 0
                  ? CustomText(
                      'Add ${controller.selectedValue}',
                    )
                  : const CustomText('Edit Remedies'))),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: appColors.guideColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {
                      if (controller.formKey.currentState?.validate() ??
                          false) {
                        print("going in inside");
                        if (controller.validation()) {
                          if (controller.selectedValue.value == "Puja") {
                            controller.addEditPoojaApi();
                          } else {
                            controller.addEditProduct();
                          }
                        }
                      }
                    },
                    child: Text(
                      'Add ${controller.selectedValue}',
                      style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: appColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: [
                AllDropDownWidget(),
                SizedBox(height: 40.h),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        InkWell(
                            onTap: () async {
                              if (!controller.isEdit.value) {
                                if (await PermissionHelper()
                                    .askMediaPermission()) {
                                  controller.updateProfileImage();
                                }
                              }
                            },
                            child: CommonImageView(
                              imagePath: controller.poojaImageUrl.isEmpty
                                  ? Assets.images.icUploadStory.path
                                  : controller.poojaImageUrl,
                              fit: BoxFit.cover,
                              height: 90.h,
                              width: 90.h,
                              placeHolder: Assets.images.defaultProfile.path,
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
                              if (controller.isEdit.value) {
                                if (await PermissionHelper()
                                    .askMediaPermission()) {
                                  controller.updateProfileImage();
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      'Upload ${controller.selectedValue} Image',
                      fontColor: appColors.textColor,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                PoojaRemedyTextFiled(
                  title: "${controller.selectedValue} Name",
                  maxLength: 20,
                  controller: controller.poojaName,
                  textInputFormatter: [CustomSpaceInputFormatter()],
                  onChanged: (value) {
                    controller.update();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${controller.selectedValue} Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                PoojaRemedyTextFiled(
                  title: "${controller.selectedValue} Description",
                  maxLines: 5,
                  textInputFormatter: [CustomSpaceInputFormatter()],
                  controller: controller.poojaDes,
                  maxLength: 500,
                  onChanged: (value) {
                    controller.update();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${controller.selectedValue} Description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                PoojaRemedyTextFiled(
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(10),
                    CustomSpaceInputFormatter(),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  isSuffix: false,
                  title: '${controller.selectedValue} Price ( In INR )',
                  controller: controller.poojaPrice,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${controller.selectedValue} Price is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget AllDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Ecom type',
          fontColor: appColors.textColor,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
              width: 1.0, // Adjust the border width as needed
            ),
          ),
          child: EComeTypeDropdown(),
        ),
        SizedBox(height: 10.h),
        CustomText(
          'Categories',
          fontColor: appColors.textColor,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
              width: 1.0, // Adjust the border width as needed
            ),
          ),
          child: EComeTagTypeDropdown(),
        ),
        SizedBox(height: 10.h),
        CustomText(
          'Tags',
          fontColor: appColors.textColor,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            Get.bottomSheet(CategoryBottomSheet(
              categoriesType: controller.tagType,
              onTap: (PujaProductCategoriesData) {
                if (!controller.selectedTag
                    .contains(PujaProductCategoriesData)) {
                  controller.selectedTag.add(PujaProductCategoriesData);
                } else {
                  controller.selectedTag.remove(PujaProductCategoriesData);
                }
                controller.update();
              },
            ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 1.0, // Adjust the border width as needed
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Select tag",
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w400,
                          fontColor: appColors.darkBlue),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 35,
                      color: appColors.black,
                    ),
                  ],
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children:
                      List.generate(controller.selectedTag.length, (index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: appColors.textColor,
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.textColor.withOpacity(0.2),
                                  blurRadius: 1.0,
                                  offset: const Offset(0.0, 3.0),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Text(
                              controller.selectedTag[index].name.toString(),
                              style: AppTextStyle.textStyle14(
                                  fontColor: appColors.white),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () {
                              for (int i = 0;
                                  i < controller.selectedTag.length;
                                  i++) {
                                if (controller.selectedTag[i].id ==
                                    controller.selectedTag[index].id) {
                                  controller.selectedTag[i].isSelected = false;
                                  controller.selectedTag.removeAt(i);
                                  break;
                                }
                              }
                              controller.update();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, border: Border.all()),
                              child: Icon(
                                Icons.close,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),

        controller.selectedValue.value  == "Puja" ?    Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            CustomText(
              'Select puja name',
              fontColor: appColors.textColor,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0, // Adjust the border width as needed
                ),
              ),
              child: PujaNameDropdown(),
            ),
          ],
        ):SizedBox(),

      ],
    );
  }

  Widget EComeTypeDropdown() {
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
                      child: Text(
                        item.tr,
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.darkBlue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "Puja".tr;
              controller.getCategoriesData(
                  type: value == "Puja" ? "pooja" : "product");
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
              // padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ));
  }

  Widget PujaNameDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<PujaProductCategoriesData>(
        isExpanded: true,
        hint: Text(
          "Select puja name",
          style: AppTextStyle.textStyle16(
              fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
        ),
        items: controller.pujaNamesList
            .map((PujaProductCategoriesData item) =>
            DropdownMenuItem<PujaProductCategoriesData>(
              value: item,
              child: Text(
                item.name ?? "",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w400,
                    fontColor: appColors.darkBlue),
                overflow: TextOverflow.ellipsis,
              ),
            ))
            .toList(),
        style: AppTextStyle.textStyle16(
            fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
        value: controller.selectedPujaName,
        onChanged: (PujaProductCategoriesData? value) {
          controller.selectedPujaName = value;
          controller.update();
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
          // padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

  Widget EComeTagTypeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<PujaProductCategoriesData>(
        isExpanded: true,
        hint: Text(
          "Category",
          style: AppTextStyle.textStyle16(
              fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
        ),
        items: controller.categoriesType
            .map((PujaProductCategoriesData item) =>
                DropdownMenuItem<PujaProductCategoriesData>(
                  value: item,
                  child: Text(
                    item.name ?? "",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        style: AppTextStyle.textStyle16(
            fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
        value: controller.selectedCategory,
        onChanged: (PujaProductCategoriesData? value) {
          controller.selectedCategory = value;
          controller.update();
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
          // padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
