import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../model/important_numbers.dart';
import '../../../utils/enum.dart';
import 'important_numbers_controller.dart';

class ImportantNumbersUI extends GetView<ImportantNumbersController> {
  const ImportantNumbersUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        title: Text("importantNumbers".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
      ),
      body: GetBuilder<ImportantNumbersController>(builder: (context) {
        return GetBuilder<ImportantNumbersController>(builder: (controller) {
          if (controller.loading == Loading.loading ||
              controller.importantNumbers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.yellow),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 1.0,
                                offset: const Offset(0.0, 3.0)),
                          ],
                          border:
                              Border.all(width: 1, color: AppColors.redColor),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("importNumText".tr,
                            style: TextStyle(
                              color: AppColors.redColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ListView.builder(
                      itemCount: controller.importantNumbers.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        MobileNumber phoneNumber =
                            controller.importantNumbers[index];
                        var exist =
                            controller.checkForContactExist(phoneNumber);

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          phoneNumber.title ?? "",
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.darkBlue),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          phoneNumber.mobileNumber ?? "",
                                          style: AppTextStyle.textStyle12(
                                              fontColor: AppColors.darkBlue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  AddContactButton(
                                      exist: exist, phoneNumber: phoneNumber)
                                  /* GestureDetector(
                                      onTap: () {
                                        if (!exist) {
                                          List<String> phoneNumbers = phoneNumber
                                              .mobileNumber!
                                              .split(",")
                                              .toList();
                                          controller.addContact(
                                            contactNumbers: phoneNumbers,
                                            givenName: phoneNumber.title ?? "",
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: exist
                                                ? AppColors.grey
                                                : AppColors.lightYellow),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 10.h),
                                          child: Text(
                                            exist ? "Added" : "addContact".tr,
                                            style: AppTextStyle.textStyle16(
                                                fontWeight: FontWeight.w600,
                                                fontColor: AppColors.brownColour),
                                          ),
                                        ),
                                      ),
                                    )*/
                                ],
                              ),
                              SizedBox(height: 25.h),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
        });
      }),
    );
  }
}

class AddContactButton extends StatefulWidget {
  final bool exist;
  final MobileNumber phoneNumber;

  const AddContactButton(
      {Key? key, required this.exist, required this.phoneNumber})
      : super(key: key);

  @override
  State<AddContactButton> createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  late bool isButtonTap;

  @override
  void initState() {
    isButtonTap = widget.exist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImportantNumbersController>(
        builder: (controller) => GestureDetector(
              onTap: () {
                if (!isButtonTap) {
                  List<String> phoneNumbers =
                      widget.phoneNumber.mobileNumber?.split(",").toList() ??
                          [];
                  controller.addContact(
                    contactNumbers: phoneNumbers,
                    givenName: widget.phoneNumber.title ?? "",
                  );
                  /*Map<String, bool> value = {
                    widget.phoneNumber.mobileNumber ?? "": isButtonTap
                  };
                  if (controller.allAdded.contains(value)) {
                    controller.allAdded.remove(value);
                    controller.allAdded.add(value);
                  }else{
                    controller.allAdded.add(value);
                  }*/
                  setState(() {
                    isButtonTap = !isButtonTap;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isButtonTap
                        ? AppColors.grey.withOpacity(0.2)
                        : AppColors.lightYellow),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Text(
                    isButtonTap ? "Saved".tr : "addContact".tr,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: isButtonTap
                            ? AppColors.grey
                            : AppColors.brownColour),
                  ),
                ),
              ),
            ));
  }
}
