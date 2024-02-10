import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/custom_light_yellow_btn.dart';
import '../../common/text_field_custom.dart';
import 'add_message_template_controller.dart';

class AddMessageTemplateUI extends GetView<AddMessageTemplateController> {
  const AddMessageTemplateUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("Template",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Obx(
              () => WhiteTextField(
                validator: (value) {
                  if (value! == "") {
                    return "";
                  }
                  return null;
                },
                controller: controller.nameController,
                //enabled: controller.enableTextField.value,
                inputType: TextInputType.text,
                inputAction: TextInputAction.next,
                hintText: "Enter Template Name",
                errorBorder: appColors.white,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    '${controller.nameLenght}/15',
                    style: AppTextStyle.textStyle12(fontColor: appColors.darkBlue),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Obx(() => controller.nameErrorText.isNotEmpty
                ? Text(
                    controller.nameErrorText.value,
                    style: AppTextStyle.textStyle12(fontColor: appColors.red),
                  )
                : const SizedBox()),
            SizedBox(height: 20.h),
            WhiteTextField(
              validator: (value) {
                if (value! == "") {
                  return "";
                }
                return null;
              },
              controller: controller.messageController,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              hintText: "Enter Default Message",
              errorBorder: appColors.white,
              maxLines: 4,
            ),
            SizedBox(height: 2.h),
            Obx(() => controller.messageErrorText.isNotEmpty
                ? Text(
                    controller.messageErrorText.value,
                    style: AppTextStyle.textStyle12(fontColor: appColors.red),
                  )
                : const SizedBox()),
            SizedBox(height: 26.h),
            CustomLightYellowButton(
              name: controller.isUpdate ? "Update Form" : "submitForm".tr,
              onTaped: () {
                controller.isUpdate ? controller.updateForm() : controller.submit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
