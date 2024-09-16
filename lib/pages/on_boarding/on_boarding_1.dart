import 'package:chips_choice/chips_choice.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/widgets/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/select_your_birth_place_sheet.dart';
import '../../screens/live_page/constant.dart';
import '../../screens/number_change/sub_screen/otp_screen_for_update_mobile_number.dart';
import '../../utils/utils.dart';
import 'on_boarding_controller.dart';

class OnBoarding1 extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      assignId: true,
      autoRemove: false,
      init: OnBoardingController(),
      builder: (controller) {
        final defaultPinTheme = PinTheme(
          width: 50.w,
          height: 52.w,
          textStyle: TextStyle(
            color: controller.isWrongOtp.isTrue
                ? appColors.red
                : appColors.darkBlue,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: controller.isWrongOtp.isTrue
                    ? appColors.red.withOpacity(0.5)
                    : appColors.guideColor.withOpacity(0.3),
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyDecorationWith(
            border: Border.all(
                color: controller.isWrongOtp.isTrue
                    ? appColors.red
                    : appColors.guideColor,
                width: 2),
            borderRadius: BorderRadius.circular(10));

        final submittedPinTheme = defaultPinTheme.copyDecorationWith(
            border: Border.all(
                color: controller.isWrongOtp.isTrue
                    ? appColors.red
                    : appColors.guideColor,
                width: 2),
            borderRadius: BorderRadius.circular(10));
        return PopScope(
          canPop: false,
          onPopInvoked: (bool) async {
            controller.showExitAppDialog();
          },
          child: Scaffold(
            backgroundColor: appColors.white,
            appBar: AppBar(
              backgroundColor: AppColors().white,
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              // leading: Padding(
              // padding: const EdgeInsets.only(bottom: 2.0),
              // child: IconButton(
              //   visualDensity: const VisualDensity(horizontal: -4),
              //   constraints: BoxConstraints.loose(Size.zero),
              //   icon:
              //       Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
              //   onPressed: () {
              //     Get.until(
              //       (route) {
              //         return Get.currentRoute == RouteName.dashboard;
              //       },
              //     );
              //   },
              // ),
              // ),
              titleSpacing: 20,
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
                  // Stack(
                  //   children: [
                  //     Center(
                  //       child: InkWell(
                  //         onTap: () {
                  //           controller.photoUrlprofile = null;
                  //           controller.getImage("profile");
                  //         },
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(100),
                  //           child: CircleAvatar(
                  //             radius: 50,
                  //             backgroundColor: appColors.grey.withOpacity(0.5),
                  //             child: controller.photoUrlprofile != null
                  //                 ? CommonImageView(
                  //                     imagePath: controller.photoUrlprofile,
                  //                     fit: BoxFit.cover,
                  //                     width: 100,
                  //                     placeHolder:
                  //                         Assets.images.defaultProfile.path,
                  //                     radius: BorderRadius.circular(80.h),
                  //                   )
                  //                 : controller.selectedProfile != null
                  //                     ? CircleAvatar(
                  //                         radius: 50,
                  //                         backgroundImage: FileImage(
                  //                           controller.selectedProfile,
                  //                         ),
                  //                       )
                  //                     : Icon(
                  //                         Icons.image,
                  //                         color: appColors.white,
                  //                         size: 40,
                  //                       ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 70, left: 80),
                  //       child: Align(
                  //         alignment: Alignment.center,
                  //         child: CircleAvatar(
                  //           radius: 15,
                  //           backgroundColor: appColors.darkBlue,
                  //           child: Icon(
                  //             Icons.add,
                  //             color: appColors.white,
                  //             size: 20,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.realController,
                          focusNode: controller.realNode,
                          onFieldSubmitted: (value) {
                            controller.realNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(controller.nameNode);
                          },
                          keyboardType: TextInputType.text,
                          prefix: Icon(
                            Icons.perm_identity_outlined,
                            color: appColors.black.withOpacity(0.5),
                          ),
                          label: "Real Name",
                          readOnly: true,
                          hint: "Real Name",
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                            color: appColors.black.withOpacity(0.5),
                          ),
                          label: "Profile Name",
                          readOnly: true,
                          hint: "Profile Name",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // Obx(
                        //   () => Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     padding: const EdgeInsets.all(10),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(
                        //         color: Colors.grey.withOpacity(0.5),
                        //       ),
                        //     ),
                        //     child: Wrap(
                        //       direction: Axis.horizontal,
                        //       children: controller.tags
                        //           .map<Widget>((element) => Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                     horizontal: 0, vertical: 6.h),
                        //                 child: Wrap(
                        //                   crossAxisAlignment:
                        //                       WrapCrossAlignment.center,
                        //                   children: [
                        //                     Container(
                        //                       padding: EdgeInsets.symmetric(
                        //                           horizontal: 15.w,
                        //                           vertical: 8.h),
                        //                       decoration: BoxDecoration(
                        //                         color: appColors.guideColor,
                        //                         borderRadius:
                        //                             const BorderRadius.all(
                        //                                 Radius.circular(20)),
                        //                       ),
                        //                       child: Text(
                        //                         element.name.toString(),
                        //                         style: AppTextStyle.textStyle14(
                        //                             fontColor: appColors.white),
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 8.w),
                        //                     InkWell(
                        //                       onTap: () {
                        //                         controller.tagIndexes.removeWhere(
                        //                             (index) =>
                        //                                 controller
                        //                                     .options[index].id ==
                        //                                 element.id);
                        //                         controller.tags.remove(element);
                        //                         controller.skills
                        //                             .remove(element.name);
                        //                         controller.update();
                        //                       },
                        //                       child: Container(
                        //                         decoration: BoxDecoration(
                        //                             shape: BoxShape.circle,
                        //                             border: Border.all()),
                        //                         child: Padding(
                        //                           padding:
                        //                               const EdgeInsets.all(4.0),
                        //                           child: Icon(
                        //                             Icons.clear,
                        //                             size: 15.sp,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ))
                        //           .toList()
                        //         ..add(InkWell(
                        //           onTap: () {
                        //             openBottomSheet(
                        //               context,
                        //               functionalityWidget: StatefulBuilder(
                        //                 builder: (context, setState) {
                        //                   return Padding(
                        //                     padding: const EdgeInsets.all(8),
                        //                     child: Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         ChipsChoice<int>.multiple(
                        //                           spacing: 10,
                        //                           value: controller.tagIndexes,
                        //                           onChanged: (val) {
                        //                             setState(() {
                        //                               controller.tagIndexes
                        //                                   .clear();
                        //                               controller.tags.clear();
                        //                               controller.skills.clear();
                        //                               for (int element in val) {
                        //                                 controller.tagIndexes
                        //                                     .add(element);
                        //                                 controller.tags.add(
                        //                                     controller.options[
                        //                                         element]);
                        //                                 controller.skills.add(
                        //                                     controller
                        //                                         .options[element]
                        //                                         .name!);
                        //                               }
                        //                             });
                        //                           },
                        //                           choiceItems: C2Choice.listFrom<
                        //                               int, String>(
                        //                             source: controller.options
                        //                                 .map((e) =>
                        //                                     e.name.toString())
                        //                                 .toList(),
                        //                             value: (i, v) => i,
                        //                             label: (i, v) => v,
                        //                           ),
                        //                           choiceStyle: C2ChipStyle.toned(
                        //                             iconSize: 0,
                        //                             backgroundColor: Colors.white,
                        //                             selectedStyle:
                        //                                 C2ChipStyle.filled(
                        //                               selectedStyle: C2ChipStyle(
                        //                                 foregroundStyle:
                        //                                     AppTextStyle
                        //                                         .textStyle16(
                        //                                             fontColor:
                        //                                                 appColors
                        //                                                     .white),
                        //                                 borderWidth: 1,
                        //                                 backgroundColor:
                        //                                     appColors.darkBlue,
                        //                                 borderStyle:
                        //                                     BorderStyle.solid,
                        //                                 borderRadius:
                        //                                     const BorderRadius
                        //                                         .all(
                        //                                         Radius.circular(
                        //                                             25)),
                        //                               ),
                        //                             ),
                        //                             borderWidth: 1,
                        //                             borderStyle:
                        //                                 BorderStyle.solid,
                        //                             borderColor:
                        //                                 appColors.darkBlue,
                        //                             borderRadius:
                        //                                 const BorderRadius.all(
                        //                               Radius.circular(20),
                        //                             ),
                        //                           ),
                        //                           wrapped: true,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             );
                        //           },
                        //           child: Padding(
                        //             padding: EdgeInsets.only(left: 8.h, top: 4.h),
                        //             child: Container(
                        //               width: ScreenUtil().screenWidth / 3.2,
                        //               decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(20),
                        //                   border: Border.all(
                        //                       width: 1,
                        //                       color: appColors.darkBlue)),
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     top: 9.h, bottom: 9.h),
                        //                 child: Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.center,
                        //                   children: [
                        //                     Icon(
                        //                       Icons.add,
                        //                       color: appColors.darkBlue,
                        //                       size: 19.sp,
                        //                     ),
                        //                     SizedBox(width: 5.w),
                        //                     Text(
                        //                       "Add Skills".tr,
                        //                       style: AppTextStyle.textStyle12(
                        //                           fontColor: appColors.darkBlue,
                        //                           fontWeight: FontWeight.w400),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         )),
                        //     ),
                        //   ),
                        // ),
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
                            color: appColors.black.withOpacity(0.5),
                          ),
                          readOnly: true,
                          label: "Select Skills",
                          hint: "Select Skills",
                          onTap: () {
                            openBottomSheet(
                              context,
                              functionalityWidget: StatefulBuilder(
                                builder: (context, setState) {
                                  // if (controller.options.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ChipsChoice<int>.multiple(
                                          spacing: 10,
                                          value: controller.tagIndexes,
                                          onChanged: (val) {
                                            setState(() {
                                              controller.tagIndexes.clear();
                                              controller.tags.clear();
                                              controller.skills.clear();
                                              for (int element in val) {
                                                controller.tagIndexes
                                                    .add(element);
                                                controller.tags.add(controller
                                                    .options[element]);
                                                controller.skills.add(controller
                                                    .options[element].id!);
                                                // Join the 'name' fields of the Skill objects into a single string separated by commas
                                                String skills = controller.tags
                                                    .map((skill) => skill.name)
                                                    .join(', ');
                                                // Set the text in the skillsController
                                                controller.skillsController
                                                    .text = skills;
                                                controller.update();
                                              }
                                            });
                                          },
                                          choiceItems:
                                              C2Choice.listFrom<int, String>(
                                            source: controller.options
                                                .map((e) => e.name.toString())
                                                .toList(),
                                            value: (i, v) => i,
                                            label: (i, v) => v,
                                          ),
                                          choiceStyle: C2ChipStyle.toned(
                                            iconSize: 0,
                                            backgroundColor: Colors.white,
                                            selectedStyle: C2ChipStyle.filled(
                                              selectedStyle: C2ChipStyle(
                                                foregroundStyle:
                                                    AppTextStyle.textStyle16(
                                                        fontColor:
                                                            appColors.white),
                                                borderWidth: 1,
                                                backgroundColor:
                                                    appColors.darkBlue,
                                                borderStyle: BorderStyle.solid,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25)),
                                              ),
                                            ),
                                            borderWidth: 1,
                                            borderStyle: BorderStyle.solid,
                                            borderColor: appColors.darkBlue,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          wrapped: true,
                                        ),
                                      ],
                                    ),
                                  );
                                  // } else {
                                  //   return Center(
                                  //       child: CircularProgressIndicator());
                                  // }
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 15,
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
                            color: appColors.black.withOpacity(0.5),
                          ),
                          readOnly: controller.userData!.experiance == null
                              ? false
                              : true,
                          label: "Experience",
                          hint: "Experience",
                        ),
                        SizedBox(
                          height: 15,
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
                              initialDate: controller
                                      .birthController.text.isNotEmpty
                                  ? DateFormat("dd-MM-yyyy")
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
                            color: appColors.black.withOpacity(0.5),
                          ),
                          label: "Birth Date",
                          hint: "Birth Date",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.locationController,
                          focusNode: controller.locationNode,
                          nextNode: controller.alterNoNode,
                          readOnly: true,
                          onTap: () {
                            Get.bottomSheet(Padding(
                              padding: EdgeInsets.only(
                                  //  bottom:
                                  //        MediaQuery.of(context).viewInsets.bottom
                                  ),
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
                            controller.alterNoNode.unfocus();
                          },
                          keyboardType: TextInputType.text,
                          prefix: Icon(
                            Icons.location_on_outlined,
                            color: appColors.black.withOpacity(0.5),
                          ),
                          label: "Location",
                          hint: "Location",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.alterNoController,
                          focusNode: controller.alterNoNode,
                          nextNode: controller.alterNoNode,
                          onFieldSubmitted: (value) {
                            controller.alterNoNode.unfocus();
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                          // readOnly:
                          // controller.sentOtp.value == false
                          //     ? false
                          //     : true,
                          prefix: Icon(
                            Icons.phone_outlined,
                            color: appColors.black.withOpacity(0.5),
                          ),
                          // sufix: controller.sending.value == true
                          //     ? Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: SizedBox(
                          //           height: 30,
                          //           width: 30,
                          //           child: Center(
                          //             child: CircularProgressIndicator(
                          //               strokeWidth: 1,
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : IconButton(
                          //         onPressed: () {
                          //           controller.alterNoNode.unfocus();
                          //           if (controller.OtpVerified.value ==
                          //               true) {
                          //             Fluttertoast.showToast(msg: "Verified");
                          //           } else {
                          //             if (controller
                          //                         .alterNoController.text ==
                          //                     "" ||
                          //                 controller.alterNoController.text
                          //                     .isEmpty ||
                          //                 controller.alterNoController.text
                          //                         .length !=
                          //                     10) {
                          //               Fluttertoast.showToast(
                          //                   msg:
                          //                       "Please Submit Valid number");
                          //             } else {
                          //               controller.sendOtpForNumberChange();
                          //             }
                          //           }
                          //         },
                          //         icon: Icon(
                          //           Icons.send,
                          //           color: controller.alterNoController.text
                          //                       .length !=
                          //                   10
                          //               ? appColors.grey.withOpacity(0.5)
                          //               : appColors.appRedColour,
                          //         ),
                          //       ),
                          label: "Alternative Number",

                          hint: "Alternative Number",
                          textInputFormatter: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only numbers
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // controller.show.value == true
                        //     ? Padding(
                        //         padding:
                        //             const EdgeInsets.only(left: 0, right: 0),
                        //         child: Pinput(
                        //           controller: controller.otpController,
                        //           length: 6,
                        //           androidSmsAutofillMethod:
                        //               AndroidSmsAutofillMethod.smsRetrieverApi,
                        //           readOnly: controller.OtpVerified.value == true
                        //               ? true
                        //               : false,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           keyboardType: TextInputType.number,
                        //           inputFormatters: <TextInputFormatter>[
                        //             FilteringTextInputFormatter.digitsOnly
                        //           ],
                        //           defaultPinTheme: defaultPinTheme,
                        //           focusedPinTheme: focusedPinTheme,
                        //           submittedPinTheme: submittedPinTheme,
                        //           pinputAutovalidateMode:
                        //               PinputAutovalidateMode.onSubmit,
                        //           showCursor: true,
                        //           onSubmitted: (value) {
                        //             controller.verifyOtpForNumberChange();
                        //           },
                        //           onCompleted: (value) {
                        //             controller.verifyOtpForNumberChange();
                        //           },
                        //         ),
                        //       )
                        //     : SizedBox(),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // controller.show.value == true
                        //     ? controller.errorMessage == null
                        //         ? SizedBox()
                        //         : Align(
                        //             alignment: Alignment.topLeft,
                        //             child: Text(
                        //               controller.errorMessage ?? "",
                        //               style: TextStyle(
                        //                 fontWeight: FontWeight.w600,
                        //                 fontSize: 12.sp,
                        //                 color: AppColors().red,
                        //               ),
                        //             ),
                        //           )
                        //     : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: onboarding_training_videoData == "" ||
                        onboarding_training_videoData == null ||
                        onboarding_training_videoData.contains("null")
                    ? 60
                    : 110,
                child: Column(
                  children: [
                    onboarding_training_videoData == "" ||
                            onboarding_training_videoData == null ||
                            onboarding_training_videoData.contains("null")
                        ? SizedBox()
                        : Padding(
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
                            if (controller.skills.isEmpty ||
                                    controller.nameController.text.isEmpty ||
                                    controller.skillsController.text.isEmpty ||
                                    controller
                                        .experiencesController.text.isEmpty ||
                                    controller
                                        .locationController.text.isEmpty ||
                                    controller.birthController.text.isEmpty ||
                                    controller
                                        .alterNoController.text.isEmpty //||
                                ) {
                              Fluttertoast.showToast(
                                  msg: "Some fields are empty");
                            } else if (controller
                                    .alterNoController.text.length !=
                                10) {
                              Fluttertoast.showToast(
                                  msg: "Please enter valid alternate number");
                            } else {
                              alternateMobile.value =
                                  controller.alterNoController.text;

                              onBoardingData1.value = {
                                "real_name": controller.realController.text,
                                "name": controller.nameController.text,
                                "skills": controller.skills,
                                "skills_name": controller.skillsController.text,
                                "experience":
                                    controller.experiencesController.text,
                                "dob": controller.birthController.text,
                                "location": controller.locationController.text,
                                "alternate_no": alternateMobile.value,
                                "page": 1,
                              };

                              controller.update();

                              Get.put(OnBoardingController());

                              controller.sendOtpForNumberChange();
                            }
                          },
                          child:
                              // controller.stage1Submitting.value == true
                              //     ? Center(
                              //         child: CircularProgressIndicator(),
                              //       )
                              //     :
                              Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: controller.skills.isEmpty ||
                                      controller.nameController.text.isEmpty ||
                                      controller
                                          .skillsController.text.isEmpty ||
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
                            child:
                                // controller.loadingProfile == true
                                //     ? Center(
                                //         child: CircularProgressIndicator(
                                //           color: appColors.white,
                                //           strokeWidth: 1,
                                //         ),
                                //       )
                                //     :
                                Align(
                              alignment: Alignment.center,
                              child: Text(
                                controller.nameController.text.isEmpty ||
                                        controller
                                            .skillsController.text.isEmpty ||
                                        controller.experiencesController.text
                                            .isEmpty ||
                                        controller
                                            .locationController.text.isEmpty ||
                                        controller
                                            .birthController.text.isEmpty ||
                                        controller
                                            .alterNoController.text.isEmpty
                                    ? "Next"
                                    : "Verify",
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
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "2",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "3",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "4",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
          ),
        ),
      ),
      buildLine(isActive: false),
      Container(
        decoration: BoxDecoration(
            color: appColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.grey.withOpacity(0.7),
              width: 1,
            )),
        padding: EdgeInsets.all(12),
        child: Text(
          "5",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: appColors.grey.withOpacity(0.7),
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
      color: isActive ? Colors.red : appColors.grey.withOpacity(0.5),
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

class VerifyOtpSheet extends StatefulWidget {
  VerifyOtpSheet({
    this.onBoardingData,
  });
  final onBoardingData;
  @override
  State<VerifyOtpSheet> createState() => _VerifyOtpSheetState();
}

class _VerifyOtpSheetState extends State<VerifyOtpSheet> {
  // final controller = Get.find<OnBoardingController>();
  // // final controller = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (bool) async {
          Get.find<OnBoardingController>().timer.cancel();
          Get.back();
        },
        child: GetBuilder<OnBoardingController>(
            // assignId: true,
            // init: OnBoardingController(),
            initState: (cont) {
          Get.find<OnBoardingController>().attempts.value = 3;
          Get.find<OnBoardingController>().otpController.clear();
          Get.find<OnBoardingController>().start = 120.obs;
          Get.find<OnBoardingController>().startTimer();

          // consto.startTimer();
        }, builder: (controller) {
          String minutes =
              (controller.start.value ~/ 60).toString().padLeft(2, '0');
          String seconds =
              (controller.start.value % 60).toString().padLeft(2, '0');

          final defaultPinTheme = PinTheme(
            width: 50.w,
            height: 52.w,
            textStyle: TextStyle(
              color: controller.isWrongOtp.isTrue
                  ? appColors.red
                  : appColors.darkBlue,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: controller.isWrongOtp.isTrue
                      ? appColors.red.withOpacity(0.5)
                      : appColors.guideColor.withOpacity(0.3),
                  width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          );

          final focusedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(
                  color: controller.isWrongOtp.isTrue
                      ? appColors.red
                      : appColors.guideColor,
                  width: 2),
              borderRadius: BorderRadius.circular(10));

          final submittedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(
                  color: controller.isWrongOtp.isTrue
                      ? appColors.red
                      : appColors.guideColor,
                  width: 2),
              borderRadius: BorderRadius.circular(10));

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.find<OnBoardingController>().timer.cancel();
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      color: appColors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: context.width,
                  height: context.height / 2.6,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: appColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 32.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 16.w),
                          Text(
                            "Verify Alternative number",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: appColors.appRedColour,
                              fontSize: 20.0.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.sp),
                      Text(
                        "OTP will be sent to your alternate number",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: appColors.darkBlue,
                          fontSize: 16.0.sp,
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Pinput(
                          controller: controller.otpController,
                          length: 6,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          // readOnly: controller.OtpVerified.value == true
                          //     ? true
                          //     : false,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          // onSubmitted: (value) {
                          //   controller.verifyOtpForNumberChange();
                          // },
                          // onCompleted: (value) {
                          //   controller.verifyOtpForNumberChange();
                          // },
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      Obx(
                        () => Column(
                          children: [
                            controller.start.value != 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Resend OTP in - ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: appColors.black,
                                          fontSize: 16.0.sp,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Text(
                                        "$minutes:$seconds",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: appColors.black,
                                          fontSize: 16.0.sp,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  )
                                : controller.isResendOtp.value
                                    ? SizedBox(
                                        height: 30.h,
                                        width: 30.h,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: appColors.brown),
                                      )
                                    : NotReceiveOtpText(
                                        onResend: () => controller.resendOtp(),
                                      ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      InkWell(
                        onTap: () {
                          if (controller.attempts.value == 0) {
                            Fluttertoast.showToast(msg: "noAttemptsLeft".tr);
                          } else {
                            print("${widget.onBoardingData}");
                            Get.put(OnBoardingController());
                            controller.verifyOtpForNumberChange(
                                widget.onBoardingData);
                            // controller.enableSubmit.value = false;
                          }
                        },
                        child: controller.stage1Submitting.value == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: appColors.red,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: controller.stage2Submitting == true
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: appColors.white,
                                          strokeWidth: 1,
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Submit",
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
        }));
  }

/* Future<void> getState() async {
    stateList.clear();
    cityList.clear();
    List<CityStateModel> subStateList = [];
    var jsonString = await rootBundle
        .loadString('assets/jsons/state.json');
    List<dynamic> body = json.decode(jsonString);

    subStateList =
        body.map((dynamic item) => CityStateModel.fromJson(item)).toList();
    for (var element in subStateList) {
      if (element.countryId == "101") {

          stateList.add(element);
        update();
      }
    }
    stateSubList = stateList;
  }*/
}
