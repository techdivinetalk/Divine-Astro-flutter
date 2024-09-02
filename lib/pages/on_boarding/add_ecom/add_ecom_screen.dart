import 'dart:io';

import 'package:divine_astrologer/pages/on_boarding/add_ecom/add_ecom_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/SvgIconButton.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_image_view.dart';
import '../../../common/custom_widgets.dart';
import '../../../common/permission_handler.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../screens/add_puja/add_puja_controller.dart';
import '../../../screens/add_puja/model/puja_product_categories_model.dart';
import '../../../screens/add_puja/widget/category_bottom_sheet.dart';
import '../../../screens/puja/widget/remedy_text_filed.dart';

class AddEcomScreen extends GetView<AddEcomController> {
  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEcomController>(
      assignId: true,
      init: AddEcomController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: appColors.white,
              surfaceTintColor: appColors.white,
              leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              title: CustomText(
                'Add Ecommerce',
              )),
          bottomNavigationBar: Container(
            height: 120,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
                Row(
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
                        onPressed: !controller.isPujaLoading
                            ? () {
                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  print("going in inside");
                                  if (controller.validation()) {
                                    if (controller.selectedValue.value ==
                                        "Puja") {
                                      controller.addEditPoojaApi();
                                    } else {
                                      controller.addEditProduct();
                                    }
                                  }
                                }
                              }
                            : () {},
                        child: !controller.isPujaLoading
                            ? Text(
                                'Add ${controller.selectedValue}',
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w600,
                                  fontColor: appColors.white,
                                ),
                              )
                            : CircularProgressIndicator(
                                backgroundColor: appColors.whiteGuidedColor,
                              ),
                      ),
                    ),
                  ],
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
                            child: controller.selectedImage == null
                                ? CommonImageView(
                                    imagePath: Assets.images.icUploadStory.path,
                                    fit: BoxFit.cover,
                                    height: 90.h,
                                    width: 90.h,
                                    placeHolder:
                                        Assets.images.defaultProfile.path,
                                    radius: BorderRadius.circular(100.h),
                                  )
                                : SizedBox(
                                    height: 90.h,
                                    width: 90.h,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(controller.selectedImage),
                                          fit: BoxFit.cover,
                                        )),
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
                controller.selectedPujaName != null &&
                            controller.selectedPujaName!.id == 0 ||
                        controller.selectedValue.value == "Product"
                    ? PoojaRemedyTextFiled(
                        title: "${controller.selectedValue} Name",
                        maxLength: 20,
                        controller: controller.nameC,
                        keyboardType: TextInputType.text,
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
                      )
                    : SizedBox(),
                SizedBox(height: 20.h),
                PoojaRemedyTextFiled(
                  title: "${controller.selectedValue} Description",
                  maxLines: 5,
                  textInputFormatter: [CustomSpaceInputFormatter()],
                  controller: controller.detailC,
                  maxLength: 500, keyboardType: TextInputType.text,
                  onChanged: (value) {
                    controller.update();
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return '${controller.selectedValue} Description is required';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 20.h),
                PoojaRemedyTextFiled(
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(10),
                    CustomSpaceInputFormatter(),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  isSuffix: false,
                  keyboardType: TextInputType.number,
                  title: '${controller.selectedValue} Price ( In INR )',
                  controller: controller.pricC,
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
              from: "onBoarding",
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
                                horizontal: 15.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: appColors.appRedColour,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: appColors.appRedColour.withOpacity(0.2),
                              //     blurRadius: 1.0,
                              //     offset: const Offset(0.0, 3.0),
                              //   ),
                              // ],
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
        controller.selectedValue.value == "Puja"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  CustomText(
                    'Select puja name',
                    fontColor: appColors.textColor,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
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
              )
            : SizedBox(),
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
            items: controller.dropDownItems
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

//   Widget build(BuildContext context) {
//     return GetBuilder<AddEcomController>(
//       assignId: true,
//       init: AddEcomController(),
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: appColors.white,
//           appBar: AppBar(
//             backgroundColor: AppColors().white,
//             forceMaterialTransparency: true,
//             automaticallyImplyLeading: false,
//             leading: Padding(
//               padding: const EdgeInsets.only(bottom: 2.0),
//               child: IconButton(
//                 visualDensity: const VisualDensity(horizontal: -4),
//                 constraints: BoxConstraints.loose(Size.zero),
//                 icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             titleSpacing: 0,
//             title: Text(
//               "Add Ecommerce",
//               style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16.sp,
//                 color: appColors.darkBlue,
//               ),
//             ),
//             actions: [
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(
//                     RouteName.dashboard,
//                   );
//                 },
//                 child: Text(
//                   "Skip",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 16.sp,
//                     color: appColors.grey,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 16, right: 16, top: 5),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: appColors.red.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.shopping_cart_outlined,
//                             size: 25,
//                             color: appColors.red,
//                           ),
//                           SizedBox(
//                             width: 6,
//                           ),
//                           Expanded(
//                             child: Text(
//                               "You can upload products or pujas, which will be listed on your profile with a chat option for users to purchase, after approval.",
//                               textAlign: TextAlign.start,
//                               overflow: TextOverflow.clip,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12.sp,
//                                 color: appColors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Remedy Type',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                         color: appColors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 20, right: 20, top: 5, bottom: 10),
//                   child: DropdownButtonFormField<String>(
//                     isExpanded: true,
//                     menuMaxHeight: 200,
//                     borderRadius: BorderRadius.circular(14),
//                     disabledHint: Text(
//                       'Please select',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                         color: appColors.black,
//                       ),
//                     ),
//                     // underline: SizedBox(),
//                     decoration: InputDecoration(
//                       floatingLabelAlignment: FloatingLabelAlignment.start,
//                       contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//                       // labelText: widget.labelText,
//                       labelStyle: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                         color: appColors.black,
//                       ),
//                       // prefixIcon: widget.prefixIcon,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: appColors.textColor.withOpacity(0.2)),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: appColors.textColor.withOpacity(0.2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: appColors.textColor.withOpacity(0.2)),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: appColors.textColor.withOpacity(0.2)),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: appColors.textColor.withOpacity(0.2)),
//                       ),
//                     ),
//                     hint: Text(
//                       'Please select Types',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                         color: appColors.black,
//                       ),
//                     ), // Not necessary for Option 1
//                     value:
//                         controller.selected != '' ? controller.selected : null,
//                     // value: controller.selected,
//                     onChanged: (newValue) {
//                       controller.selectedDropDown(newValue);
//                     },
//                     items: controller.dropDownItems.map((data) {
//                       return DropdownMenuItem(
//                         value: data,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text(
//                             data,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12.sp,
//                               color: appColors.black,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Remedy Categories',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                         color: appColors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 20, right: 20, top: 5, bottom: 10),
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(10)),
//                       border: Border.all(
//                         color: Colors.black.withOpacity(0.2),
//                         width: 1.0, // Adjust the border width as needed
//                       ),
//                     ),
//                     child: EComeTagTypeDropdown(),
//                   ),
//                 ),
//                 controller.selected == "Puja"
//                     ? Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Remedy Tag',
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12.sp,
//                               color: appColors.black,
//                             ),
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//                 controller.selected == "Puja"
//                     ? Padding(
//                         padding: const EdgeInsets.only(
//                             left: 20, right: 20, top: 5, bottom: 10),
//                         child: InkWell(
//                           onTap: () {
//                             Get.bottomSheet(CategoryBottomSheet(
//                               categoriesType: controller.tagType,
//                               onTap: (PujaProductCategoriesData) {
//                                 if (!controller.selectedTag
//                                     .contains(PujaProductCategoriesData)) {
//                                   controller.selectedTag
//                                       .add(PujaProductCategoriesData);
//                                 } else {
//                                   controller.selectedTag
//                                       .remove(PujaProductCategoriesData);
//                                 }
//                                 controller.update();
//                               },
//                             ));
//                           },
//                           child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: appColors.textColor.withOpacity(0.2),
//                                 ),
//                               ),
//                               child: controller.selectedTag.isEmpty
//                                   ? Row(
//                                       children: [
//                                         Text(
//                                           "Select tag",
//                                           style: AppTextStyle.textStyle16(
//                                               fontWeight: FontWeight.w400,
//                                               fontColor: appColors.darkBlue),
//                                         ),
//                                         const Spacer(),
//                                         Icon(
//                                           Icons.keyboard_arrow_down_outlined,
//                                           size: 35,
//                                           color: appColors.black,
//                                         ),
//                                       ],
//                                     )
//                                   : Wrap(
//                                       direction: Axis.horizontal,
//                                       children: List.generate(
//                                           controller.selectedTag.length,
//                                           (index) {
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 4.w, vertical: 6.h),
//                                           child: Wrap(
//                                             crossAxisAlignment:
//                                                 WrapCrossAlignment.center,
//                                             children: [
//                                               Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 15.w,
//                                                     vertical: 8.h),
//                                                 decoration: BoxDecoration(
//                                                   color: appColors.appRedColour,
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: appColors.white,
//                                                       blurRadius: 1.0,
//                                                       offset: const Offset(
//                                                           0.0, 3.0),
//                                                     ),
//                                                   ],
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                           Radius.circular(20)),
//                                                 ),
//                                                 child: Text(
//                                                   controller
//                                                       .selectedTag[index].name
//                                                       .toString(),
//                                                   style:
//                                                       AppTextStyle.textStyle14(
//                                                           fontColor:
//                                                               appColors.white),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 8.w),
//                                               InkWell(
//                                                 onTap: () {
//                                                   for (int i = 0;
//                                                       i <
//                                                           controller.selectedTag
//                                                               .length;
//                                                       i++) {
//                                                     if (controller
//                                                             .selectedTag[i]
//                                                             .id ==
//                                                         controller
//                                                             .selectedTag[index]
//                                                             .id) {
//                                                       controller.selectedTag[i]
//                                                           .isSelected = false;
//                                                       controller.selectedTag
//                                                           .removeAt(i);
//                                                       break;
//                                                     }
//                                                   }
//                                                   controller.update();
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       border: Border.all()),
//                                                   child: Icon(
//                                                     Icons.close,
//                                                     size: 18.sp,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                     )),
//                         ),
//                       )
//                     : SizedBox(),
//                 InkWell(
//                   onTap: () {
//                     controller.updateProfileImage();
//                   },
//                   child: controller.selectedImage == null
//                       ? CircleAvatar(
//                           backgroundColor: appColors.grey.withOpacity(0.3),
//                           radius: 40,
//                           child: Icon(
//                             Icons.add,
//                             color: appColors.white,
//                             size: 50,
//                           ),
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CircleAvatar(
//                             radius: 40,
//                             backgroundColor: appColors.grey.withOpacity(0.1),
//                             child: Image.file(
//                               File(controller.selectedImage.toString()),
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                         ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//                   child: Text(
//                     'Upload Image',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16.sp,
//                       color: appColors.black,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//                   child: Column(
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Remedy Name*',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       CustomTextField(
//                         hint: "",
//                         maxLength: 20,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Remedy Description',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       SizedBox(
//                         height: 100,
//                         child: CustomTextField(
//                           hint: "",
//                           maxLength: 500,
//                           maxLines: 5,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Remedy Price ( In INR )*',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                             color: appColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       CustomTextField(
//                         hint: "",
//                         maxLength: 20,
//                         keyboardType: TextInputType.number,
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           '*Mandatory Field',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                             color: appColors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               height: controller.selected == null ? 60 : 110,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 14, right: 14, top: 10, bottom: 10),
//                     child: RichText(
//                       text: TextSpan(
//                         text:
//                             '* Confused? Don’t worry, We are here to help you! ',
//                         style: TextStyle(
//                           fontFamily: FontFamily.poppins,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                           color: appColors.grey,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'Click here for a tutorial video.',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontFamily: FontFamily.poppins,
//                               fontWeight: FontWeight.w400,
//                               color: appColors.red,
//                               decoration: TextDecoration.underline,
//                             ),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 // Handle tap
//                                 print('Link tapped');
//                               },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   controller.selected == null
//                       ? SizedBox()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap: () {},
//                               child: Container(
//                                 height: 50,
//                                 width: MediaQuery.of(context).size.width * 0.9,
//                                 decoration: BoxDecoration(
//                                   color: appColors.red,
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "Submit ${controller.selected.toString()}",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 20.sp,
//                                       color: AppColors().white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget EComeTagTypeDropdown() {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<PujaProductCategoriesData>(
//         isExpanded: true,
//         hint: Text(
//           "Category",
//           style: AppTextStyle.textStyle16(
//               fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
//         ),
//         items: controller.categoriesType
//             .map((PujaProductCategoriesData item) =>
//                 DropdownMenuItem<PujaProductCategoriesData>(
//                   value: item,
//                   child: Text(
//                     item.name ?? "",
//                     style: AppTextStyle.textStyle16(
//                         fontWeight: FontWeight.w400,
//                         fontColor: appColors.darkBlue),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//             .toList(),
//         style: AppTextStyle.textStyle16(
//             fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
//         value: controller.selectedCategory,
//         onChanged: (PujaProductCategoriesData? value) {
//           controller.selectedCategory = value;
//           controller.update();
//         },
//         iconStyleData: IconStyleData(
//           icon: const Icon(
//             Icons.keyboard_arrow_down_outlined,
//           ),
//           iconSize: 35,
//           iconEnabledColor: appColors.blackColor,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           width: ScreenUtil().screenWidth * 0.9,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: appColors.white,
//           ),
//           offset: const Offset(-8, -17),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(40),
//             thickness: MaterialStateProperty.all<double>(6),
//             thumbVisibility: MaterialStateProperty.all<bool>(false),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 40,
//           // padding: EdgeInsets.zero,
//         ),
//       ),
//     );
//   }
// }
