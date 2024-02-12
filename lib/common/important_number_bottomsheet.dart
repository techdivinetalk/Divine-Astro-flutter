import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import "package:divine_astrologer/common/permission_handler.dart";
import "package:divine_astrologer/pages/home/home_controller.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import "package:permission_handler/permission_handler.dart";

import "../model/important_numbers.dart";

Future importantNumberBottomSheet(BuildContext context,) {
  HomeController controller = Get.find<HomeController>();
  return showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(50.0)),
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Text('Important Numbers',
                style: AppTextStyle.textStyle20(fontWeight: FontWeight.w600),
                  ),
                SizedBox(height: 8.h),
                Text('Save these contact numbers for call and chat alerts to avoid confusion before starting the app.',
                style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.red),
                ),
                SizedBox(height: 36.h),
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
                                          fontColor: appColors.darkBlue),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      phoneNumber.mobileNumber ?? "",
                                      style: AppTextStyle.textStyle12(
                                          fontColor: appColors.darkBlue),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              AddContactButton(
                                  exist: exist, phoneNumber: phoneNumber)
                            ],
                          ),
                          SizedBox(height: 25.h),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
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
    return GetBuilder<HomeController>(
        builder: (controller) => GestureDetector(
          onTap: () async {
            if (await PermissionHelper()
                .askCustomPermission(Permission.contacts)) {
              if (!isButtonTap) {
                List<String> phoneNumbers =
                    widget.phoneNumber.mobileNumber?.split(",").toList() ??
                        [];
                controller.addContact(
                  contactNumbers: phoneNumbers,
                  givenName: widget.phoneNumber.title ?? "",
                );
                setState(() {
                  isButtonTap = !isButtonTap;
                });
                await controller.getContactList();
                if(controller.checkForALlContact(controller.importantNumbers)) {
                  Get.back();
                }
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isButtonTap
                    ? appColors.grey.withOpacity(0.2)
                    : appColors.lightYellow),
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Text(
                isButtonTap ? "Saved".tr : "addContact".tr,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w600,
                    fontColor: isButtonTap
                        ? appColors.grey
                        : appColors.brownColour),
              ),
            ),
          ),
        ));
  }
}
