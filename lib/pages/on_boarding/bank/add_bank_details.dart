import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/common_image_view.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../screens/bank_details/widgets.dart';
import '../../../screens/live_page/constant.dart';
import 'bank_controller.dart';

class AddBankDetails extends GetView<BankController> {
  Widget get sizedBox25 => SizedBox(height: 10.w);

  Widget get sizedBox5 => SizedBox(height: 8.w);

  Widget title(String data, {Color? color}) => Text(
        data,
        style: AppTextStyle.textStyle16(
          fontWeight: FontWeight.w400,
          fontColor: color ?? appColors.darkBlue,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(
      assignId: true,
      init: BankController(),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool) async {
            controller.showExitAppDialog();
          },
          child: Theme(
            data: ThemeData(useMaterial3: false),
            child: Scaffold(
              backgroundColor: appColors.white,
              appBar: AppBar(
                backgroundColor: AppColors().white,
                forceMaterialTransparency: true,
                automaticallyImplyLeading: false,
                titleSpacing: 20,
                title: Text(
                  "Bank Details".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: appColors.darkBlue,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 15, 20),
                    child: InkWell(
                      onTap: () {
                        controller.submitStage52();
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: appColors.grey,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
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

                      controller.status == "" || controller.status == "Approved"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GetBuilder<BankController>(
                                    builder: (controller) {
                                  return InkWell(
                                    onTap: () {
                                      if (controller.cancelledCheque == null ||
                                          controller.passBook == null) {
                                        divineSnackBar(
                                            data: "Please Fill All Data",
                                            color: appColors.redColor);
                                      } else {
                                        controller.submit();
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: appColors.red,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Align(
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
                                  );
                                }),
                              ],
                            )
                          : SizedBox(),

                      // controller.status == "" || controller.status == "Approved"
                      //     ? Container(
                      //         height: 50,
                      //         width: MediaQuery.of(context).size.width * 0.9,
                      //         // decoration: BoxDecoration(
                      //         //   color: appColors.red,
                      //         //   borderRadius: BorderRadius.circular(14),
                      //         // ),
                      //         child: CustomMaterialButton(
                      //           height: 50,
                      //           buttonName: "submit".tr,
                      //           onPressed: () => controller.submit(),
                      //         ),
                      //       )
                      //     : const SizedBox(),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // BackNavigationWidget(
                    //   title: "       yourBankDetails".tr,
                    //   // onPressedBack: () => Get.back(),
                    //   trailingIcon: InkWell(
                    //     onTap: () {
                    //       Get.offNamed(
                    //         RouteName.addEcomAutomation,
                    //       );
                    //     },
                    //     child: Text(
                    //       "Skip",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 16.sp,
                    //         color: appColors.grey,
                    //         decoration: TextDecoration.underline,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                  key: controller.formState,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // title("bankName".tr),
                                      // sizedBox5,
                                      WrapperContainer(
                                        child: BankDetailsField(
                                            validator: bankDetailValidator,
                                            controller: controller.bankName,
                                            hintText: "Enter Bank Name".tr,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.text,
                                            from: "onBoarding"),
                                      ),
                                      sizedBox25,
                                      // title("accountHolderName".tr),
                                      // sizedBox5,
                                      WrapperContainer(
                                        child: BankDetailsField(
                                            validator: bankDetailValidator,
                                            controller: controller.holderName,
                                            hintText: "Account Holder Name".tr,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.text,
                                            from: "onBoarding"),
                                      ),
                                      sizedBox25,
                                      // title("bankAccountNumber".tr),
                                      // sizedBox5,
                                      WrapperContainer(
                                        child: BankDetailsField(
                                            validator: bankDetailValidator,
                                            controller:
                                                controller.accountNumber,
                                            hintText: "Bank Account Number".tr,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.number,
                                            from: "onBoarding"),
                                      ),
                                      sizedBox25,
                                      // title("iFSCCode".tr),
                                      // sizedBox5,
                                      WrapperContainer(
                                        child: BankDetailsField(
                                            validator: bankDetailValidator,
                                            controller: controller.ifscCode,
                                            hintText: "IFSC Code".tr,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.text,
                                            from: "onBoarding"),
                                      ),
                                      sizedBox25,
                                      Row(
                                        children: [
                                          title("attachments".tr),
                                          const Spacer(),
                                          controller.status.isNotEmpty
                                              ? title(
                                                  "status".tr +
                                                      " : " +
                                                      controller.status,
                                                  color: controller.status ==
                                                          "Approved"
                                                      ? appColors.lightGreen
                                                      : appColors.textColor)
                                              : SizedBox()
                                        ],
                                      ),
                                      sizedBox5,
                                    ],
                                  )),
                              GetBuilder<BankController>(
                                builder: (controller) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          controller.passBook == null &&
                                                  controller.passBookUrl.isEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .pickFile()
                                                        .then((value) {
                                                      print(value);
                                                      print(
                                                          "valuevaluevaluevaluevalue");
                                                      if (value != null) {
                                                        controller
                                                            .addPassBook(value);
                                                        controller.passBookUrl =
                                                            "";
                                                        print(controller
                                                                .passBookUrl
                                                                .isEmpty
                                                            ? controller
                                                                .passBook!.path
                                                            : controller
                                                                .passBookUrl);

                                                        controller.update();
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: appColors.grey
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.h),
                                                    ),
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    child:
                                                        Assets.svg.icAdd.svg(),
                                                  ),
                                                )
                                              : CommonImageView(
                                                  imagePath: controller
                                                          .passBookUrl.isEmpty
                                                      ? ("file://" +
                                                          controller
                                                              .passBook!.path)
                                                      : controller.passBookUrl,
                                                  height: 120,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  onTap: () {
                                                    controller
                                                        .pickFile()
                                                        .then((value) {
                                                      if (value != null) {
                                                        controller
                                                            .addPassBook(value);
                                                      }
                                                    });
                                                  },
                                                  radius: BorderRadius.circular(
                                                      10.h),
                                                ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            "Upload Passbook".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.poppins,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: appColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: controller.cancelledCheque ==
                                                  null &&
                                              controller
                                                  .cancelledChequeUrl.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .pickFile()
                                                        .then((value) {
                                                      if (value != null) {
                                                        controller
                                                            .addCancelledCheque(
                                                                value);
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: appColors.grey
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.h),
                                                    ),
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    child:
                                                        Assets.svg.icAdd.svg(),
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  "Upload Cancelled Cheque".tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.poppins,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: appColors.grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonImageView(
                                                    imagePath: controller
                                                            .cancelledChequeUrl
                                                            .isEmpty
                                                        ? ("file://" +
                                                            controller
                                                                .cancelledCheque!
                                                                .path)
                                                        : controller
                                                            .cancelledChequeUrl,
                                                    radius:
                                                        BorderRadius.circular(
                                                            10.h),
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    onTap: () {
                                                      controller
                                                          .pickFile()
                                                          .then((value) {
                                                        if (value != null) {
                                                          controller
                                                              .addCancelledCheque(
                                                                  value);
                                                        }
                                                      });
                                                    }),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  "Upload Cancelled Cheque".tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.poppins,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: appColors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
  //   return GetBuilder<BankController>(
  //     assignId: true,
  //     init: BankController(),
  //     builder: (controller) {
  //       return Scaffold(
  //         backgroundColor: appColors.white,
  //         appBar: AppBar(
  //           backgroundColor: AppColors().white,
  //           forceMaterialTransparency: true,
  //           automaticallyImplyLeading: false,
  //           leading: Padding(
  //             padding: const EdgeInsets.only(bottom: 2.0),
  //             child: IconButton(
  //               visualDensity: const VisualDensity(horizontal: -4),
  //               constraints: BoxConstraints.loose(Size.zero),
  //               icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ),
  //           titleSpacing: 0,
  //           title: Text(
  //             "Bank Details",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w400,
  //               fontSize: 16.sp,
  //               color: appColors.darkBlue,
  //             ),
  //           ),
  //           actions: [
  //             InkWell(
  //               onTap: () {
  //                 Get.toNamed(
  //                   RouteName.addEcomAutomation,
  //                 );
  //               },
  //               child: Text(
  //                 "Skip",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w400,
  //                   fontSize: 16.sp,
  //                   color: appColors.grey,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //           ],
  //         ),
  //         body: SingleChildScrollView(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 14, right: 14),
  //                 child: Column(
  //                   children: [
  //                     CustomTextField(
  //                       hint: "Enter Bank Name",
  //                       controller: controller.bankNameController,
  //                       focusNode: controller.bankNameNode,
  //                       onFieldSubmitted: (value) {
  //                         controller.bankNameNode.unfocus();
  //                         FocusScope.of(context)
  //                             .requestFocus(controller.bankHolderNode);
  //                       },
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     CustomTextField(
  //                       hint: "Account Holder Name",
  //                       controller: controller.bankHolderController,
  //                       focusNode: controller.bankHolderNode,
  //                       onFieldSubmitted: (value) {
  //                         controller.bankHolderNode.unfocus();
  //                         FocusScope.of(context)
  //                             .requestFocus(controller.bankAccountNode);
  //                       },
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     CustomTextField(
  //                       hint: "Bank Account Number",
  //                       controller: controller.bankAccountController,
  //                       keyboardType: TextInputType.number,
  //                       focusNode: controller.bankAccountNode,
  //                       onFieldSubmitted: (value) {
  //                         controller.bankAccountNode.unfocus();
  //                         FocusScope.of(context)
  //                             .requestFocus(controller.bankIFSCNode);
  //                       },
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     CustomTextField(
  //                       hint: "IFSC Code",
  //                       controller: controller.bankIFSCController,
  //                       focusNode: controller.bankIFSCNode,
  //                       onFieldSubmitted: (value) {
  //                         controller.bankIFSCNode.unfocus();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     "attachments".tr,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 16.sp,
  //                       color: appColors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               GetBuilder<BankController>(builder: (controller) {
  //                 return Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           InkWell(
  //                             onTap: () {
  //                               controller.updateProfileImage("passBook");
  //                             },
  //                             child: Container(
  //                               height: 120,
  //                               width: MediaQuery.of(context).size.width * 0.4,
  //                               decoration: BoxDecoration(
  //                                 color: appColors.grey.withOpacity(0.4),
  //                                 borderRadius: BorderRadius.circular(14),
  //                               ),
  //                               child: controller.uploadImagePan != null
  //                                   ? CommonImageView(
  //                                       imagePath: controller.uploadImagePan
  //                                           .toString(),
  //                                       fit: BoxFit.cover,
  //                                       placeHolder:
  //                                           Assets.images.defaultProfile.path,
  //                                     )
  //                                   : controller.passBookImage != null
  //                                       ? Image.file(
  //                                           File(controller.passBookImage
  //                                               .toString()),
  //                                           fit: BoxFit.cover,
  //                                         )
  //                                       : Icon(
  //                                           Icons.add,
  //                                           color: appColors.white,
  //                                           size: 80,
  //                                         ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 5.h),
  //                           Text(
  //                             "Upload Passbook".tr,
  //                             style: TextStyle(
  //                               fontFamily: FontFamily.poppins,
  //                               fontSize: 12.sp,
  //                               fontWeight: FontWeight.w400,
  //                               color: appColors.grey,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(width: 12.w),
  //                     Expanded(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           InkWell(
  //                             onTap: () {
  //                               controller.updateProfileImage("cheque");
  //                             },
  //                             child: Container(
  //                               height: 120,
  //                               width: MediaQuery.of(context).size.width * 0.4,
  //                               decoration: BoxDecoration(
  //                                 color: appColors.grey.withOpacity(0.4),
  //                                 borderRadius: BorderRadius.circular(14),
  //                               ),
  //                               child: controller.uploadImageCheque != null
  //                                   ? CommonImageView(
  //                                       imagePath: controller.uploadImageCheque
  //                                           .toString(),
  //                                       fit: BoxFit.cover,
  //                                       placeHolder:
  //                                           Assets.images.defaultProfile.path,
  //                                     )
  //                                   : controller.blankChequeImage != null
  //                                       ? Image.file(
  //                                           File(controller.blankChequeImage
  //                                               .toString()),
  //                                           fit: BoxFit.cover,
  //                                         )
  //                                       : Icon(
  //                                           Icons.add,
  //                                           color: appColors.white,
  //                                           size: 80,
  //                                         ),
  //                             ),
  //                           ),
  //
  //                           // CommonImageView(
  //                           //     imagePath: Assets.images.defaultProfile.path,
  //                           //     radius: BorderRadius.circular(10.h),
  //                           //     height: 120,
  //                           //     width: MediaQuery.of(context).size.width * 0.4,
  //                           //     onTap: () {}),
  //                           SizedBox(height: 5.h),
  //                           Text(
  //                             "Upload Cancelled Cheque".tr,
  //                             style: TextStyle(
  //                               fontFamily: FontFamily.poppins,
  //                               fontSize: 12.sp,
  //                               fontWeight: FontWeight.w400,
  //                               color: appColors.grey,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //         bottomNavigationBar: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SizedBox(
  //             height: 110,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                       left: 14, right: 14, top: 10, bottom: 10),
  //                   child: RichText(
  //                     text: TextSpan(
  //                       text:
  //                           '* Confused? Don’t worry, We are here to help you! ',
  //                       style: TextStyle(
  //                         fontFamily: FontFamily.poppins,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w400,
  //                         color: appColors.grey,
  //                       ),
  //                       children: [
  //                         TextSpan(
  //                           text: 'Click here for a tutorial video.',
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             fontFamily: FontFamily.poppins,
  //                             fontWeight: FontWeight.w400,
  //                             color: appColors.red,
  //                             decoration: TextDecoration.underline,
  //                           ),
  //                           recognizer: TapGestureRecognizer()
  //                             ..onTap = () {
  //                               // Handle tap
  //                               print('Link tapped');
  //                             },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 controller.status == "" || controller.status == "Approved"
  //                     ? Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           GetBuilder<BankController>(builder: (controller) {
  //                             return InkWell(
  //                               onTap: () {
  //                                 if (controller
  //                                     .bankNameController.text.isEmpty) {
  //                                   Fluttertoast.showToast(
  //                                       msg: "Bank Name is Empty");
  //                                 } else if (controller
  //                                     .bankHolderController.text.isEmpty) {
  //                                   Fluttertoast.showToast(
  //                                       msg: "Bank Holder is Empty");
  //                                 } else if (controller
  //                                     .bankAccountController.text.isEmpty) {
  //                                   Fluttertoast.showToast(
  //                                       msg: "Bank Account is Empty");
  //                                 } else if (controller
  //                                     .bankIFSCController.text.isEmpty) {
  //                                   Fluttertoast.showToast(
  //                                       msg: "Bank IFSC is Empty");
  //                                 } else if (controller.passBookImage == null ||
  //                                     controller.blankChequeImage == null) {
  //                                   Fluttertoast.showToast(
  //                                       msg: "Image is Empty");
  //                                 } else {
  //                                   controller.submitBankDetails();
  //                                 }
  //                                 // Get.toNamed(
  //                                 //   RouteName.addEcomAutomation,
  //                                 // );
  //                               },
  //                               child: Container(
  //                                 height: 50,
  //                                 width:
  //                                     MediaQuery.of(context).size.width * 0.9,
  //                                 decoration: BoxDecoration(
  //                                   color: appColors.red,
  //                                   borderRadius: BorderRadius.circular(14),
  //                                 ),
  //                                 child: controller.submittingBankDetails.value
  //                                     ? Center(
  //                                         child: CircularProgressIndicator(),
  //                                       )
  //                                     : Align(
  //                                         alignment: Alignment.center,
  //                                         child: Text(
  //                                           "Submit",
  //                                           style: TextStyle(
  //                                             fontWeight: FontWeight.w600,
  //                                             fontSize: 20.sp,
  //                                             color: AppColors().white,
  //                                           ),
  //                                         ),
  //                                       ),
  //                               ),
  //                             );
  //                           }),
  //                         ],
  //                       )
  //                     : SizedBox(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
