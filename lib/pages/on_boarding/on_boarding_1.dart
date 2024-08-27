import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/widgets/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/colors.dart';
import '../../common/routes.dart';
import '../../common/select_your_birth_place_sheet.dart';
import '../../utils/utils.dart';
import 'on_boarding_controller.dart';

class OnBoarding1 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      assignId: true,
      init: OnBoardingController(),
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
              "Onboarding Process",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.darkBlue,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: pageWidget("1"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Basic\nDetails",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Upload\nDocuments",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Upload\nPictures",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Signing\nAgreement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                      buildSpace(),
                      Text(
                        "Awaiting\nApproval",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          controller.photoUrlprofile = null;
                          controller.getImage("profile");
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: appColors.grey.withOpacity(0.5),
                            child: controller.selectedProfile != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(
                                      controller.selectedProfile,
                                    ),
                                  )
                                : Icon(
                                    Icons.image,
                                    color: appColors.white,
                                    size: 40,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70, left: 80),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: appColors.darkBlue,
                          child: Icon(
                            Icons.add,
                            color: appColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.nameController,
                        focusNode: controller.nameNode,
                        onFieldSubmitted: (value) {
                          controller.nameNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.skillsNode);
                        },
                        keyboardType: TextInputType.text,
                        prefix: Icon(
                          Icons.perm_identity_outlined,
                          color: appColors.black,
                        ),
                        hint: "Profile Name",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: controller.skillsController,
                        focusNode: controller.skillsNode,
                        onFieldSubmitted: (value) {
                          controller.skillsNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.experiencesNode);
                        },
                        keyboardType: TextInputType.text,
                        prefix: Icon(
                          Icons.emoji_objects_outlined,
                          color: appColors.black,
                        ),
                        hint: "Select Skills",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: controller.experiencesController,
                        focusNode: controller.experiencesNode,
                        onFieldSubmitted: (value) {
                          controller.experiencesNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.birthNode);
                        },
                        keyboardType: TextInputType.text,
                        prefix: Icon(
                          Icons.business_center_outlined,
                          color: appColors.black,
                        ),
                        hint: "Experience",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: controller.birthController,
                        focusNode: controller.birthNode,
                        readOnly: true,
                        onFieldSubmitted: (value) {
                          controller.birthNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.locationNode);
                        },
                        onTap: () {
                          Utils.selectDateOrTime(
                            initialDate:
                                controller.birthController.text.isNotEmpty
                                    ? DateFormat("dd/MM/yyyy")
                                        .parse(controller.birthController.text)
                                    : DateTime.now(),
                            title: "Select Date Of Birth".tr,
                            btnTitle: "confirmDateBirth".tr,
                            pickerStyle: "DateCalendar",
                            looping: true,
                            onConfirm: (value) {
                              if (value != "") {
                                DateTime data =
                                    DateFormat("dd MMMM yyyy").parse(value);
                                controller.birthController.text =
                                    "${data.day.toString().padLeft(2, '0')}-${data.month.toString().padLeft(2, '0')}-${data.year.toString()}";
                              }
                            },
                            onChange: (String datetime) {},
                          );
                        },
                        keyboardType: TextInputType.text,
                        prefix: Icon(
                          Icons.calendar_month_outlined,
                          color: appColors.black,
                        ),
                        hint: "Birth Date",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: controller.locationController,
                        focusNode: controller.locationNode,
                        nextNode: controller.alterNoNode,
                        readOnly: true,
                        onTap: () {
                          Get.bottomSheet(Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AllCityListSheet(
                              onSelect: (value) {
                                controller.locationController.text =
                                    value.cityName ?? "";
                                controller.update();
                                Get.back();
                              },
                              country: "India",
                              cityData: [],
                            ),
                          ));
                        },
                        onFieldSubmitted: (value) {
                          controller.locationNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.alterNoNode);
                        },
                        keyboardType: TextInputType.text,
                        prefix: Icon(
                          Icons.location_on_outlined,
                          color: appColors.black,
                        ),
                        hint: "Location",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: controller.alterNoController,
                        focusNode: controller.alterNoNode,
                        nextNode: controller.alterNoNode,
                        onFieldSubmitted: (value) {
                          controller.alterNoNode.unfocus();
                        },
                        keyboardType: TextInputType.number,
                        prefix: Icon(
                          Icons.phone_outlined,
                          color: appColors.black,
                        ),
                        hint: "Alternative Number",
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
              height: 110,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.selectedProfile == null ||
                              controller.nameController.text.isEmpty ||
                              controller.skills.isEmpty ||
                              controller.experiencesController.text.isEmpty ||
                              controller.locationController.text.isEmpty ||
                              controller.birthController.text.isEmpty ||
                              controller.alterNoController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Some fields are empty");
                          } else {
                            if (controller.photoUrlprofile == null) {
                              controller
                                  .uploadImage(
                                      controller.selectedProfile, "Profile")
                                  .then((val) {
                                Get.toNamed(
                                  RouteName.onBoardingScreen2,
                                );
                              });
                            } else {
                              print(
                                  "-------------------------------${controller.photoUrlprofile}");
                              Get.toNamed(
                                RouteName.onBoardingScreen2,
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: controller.selectedProfile == null ||
                                    controller.nameController.text.isEmpty ||
                                    controller.skills.isEmpty ||
                                    controller
                                        .experiencesController.text.isEmpty ||
                                    controller
                                        .locationController.text.isEmpty ||
                                    controller.birthController.text.isEmpty ||
                                    controller.alterNoController.text.isEmpty
                                ? appColors.grey.withOpacity(0.4)
                                : appColors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: controller.loadingProfile == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Next",
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
}

Widget pageWidget(page) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
            color: AppColors().red,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors().red,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "1",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.white,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "2",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "3",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey,
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey,
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "5",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey,
          ),
        ),
      ),
    ],
  );
}

Widget buildLine({required bool isActive}) {
  return Expanded(
    child: Container(
      height: 2,
      color: isActive ? Colors.red : Colors.grey,
    ),
  );
}

Widget buildSpace() {
  return Expanded(
    child: Container(
      height: 2,
    ),
  );
}
