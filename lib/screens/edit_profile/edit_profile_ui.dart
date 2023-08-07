import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_light_yellow_btn.dart';
import '../../../common/text_field_custom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'edit_profile_controller.dart';

class EditProfileUI extends GetView<EditProfileController> {
  const EditProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLightYellowButton(
            name: AppString.saveChanges,
            onTaped: () {},
          ),
        ],
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.editProfile,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.name,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.hintTextName,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 20.h,
              ),
              Text(
                AppString.speciality,
                style: AppTextStyle.textStyle14(),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.hintSpeciality,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.experience,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.hintExperience,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.descriptions,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 70.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3.0,
                          offset: const Offset(0.3, 3.0)),
                    ]),
                child: TextFormField(
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: AppString.hintDescriptions,
                    helperStyle: AppTextStyle.textStyle16(),
                    fillColor: Colors.white,
                    hoverColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: AppColors.darkYellow,
                          width: 1.0,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
