import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import "package:divine_astrologer/common/permission_handler.dart";
import "package:divine_astrologer/pages/home/home_controller.dart";
import 'package:divine_astrologer/screens/splash/splash_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import "package:permission_handler/permission_handler.dart";


importantNumberBottomSheet(BuildContext context,
    {List<ImportantNumber>? importantNumbers,List? isAllDone}) {
  for(int i = 0; i<importantNumbers!.length;i++){
    if(importantNumbers[i].isSave!){
      isAllDone!.add(importantNumbers[i].isSave);
    }
  }
  return Wrap(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Text(
              'Important Numbers',
              style: AppTextStyle.textStyle20(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.h),
                  color: appColors.white,
                  border: Border.all(color: appColors.red),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.textColor.withOpacity(0.15),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ]),
              child: Text(
                'Save these contact numbers for call and chat alerts to avoid confusion before starting the app.',
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: appColors.red,
                ),
              ),
            ),
            SizedBox(height: 36.h),
            ListView.separated(
              itemCount: importantNumbers!.length,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ImportantNumber phoneNumber = importantNumbers[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phoneNumber.title ?? "",
                            style: AppTextStyle.textStyle16(
                                fontColor: appColors.darkBlue),
                          ),
                          // SizedBox(height: 5.h),
                          Text(
                            phoneNumber.mobileNumbers!.join(","),
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 38.w),
                    AddContactButton(
                      exist: phoneNumber.isSave ?? false,
                      name: phoneNumber.title,
                      phoneNumber: phoneNumber.mobileNumbers!,
                      allDone: isAllDone,
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 25.h),
            ),
          ],
        ),
      ),
    ],
  );
}

class AddContactButton extends StatefulWidget {
  bool? exist;
  final String? name;
  final List<String> phoneNumber;
  List? allDone;

  AddContactButton({this.allDone, this.exist, required this.phoneNumber, this.name});

  @override
  State<AddContactButton> createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.exist!
          ? () async {
              if (await PermissionHelper()
                  .askCustomPermission(Permission.contacts)) {
                await saveContact(
                    name: widget.name, mobileNumber: widget.phoneNumber);

                setState(() {
                  widget.exist = !widget.exist!;
                });
                widget.allDone!.add(widget.exist);
                print(widget.allDone!.length);
                print("widget.allDone!.length");
                if(widget.allDone!.length == 3){
                  Get.back(result: 3);
                }
              }
            }
          : () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.exist!
                ? appColors.grey.withOpacity(0.2)
                : appColors.guideColor),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Text(
            widget.exist! ? "Saved".tr : "addContact".tr,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w600,
                fontColor:
                    widget.exist! ? appColors.grey : appColors.brownColour),
          ),
        ),
      ),
    );
  }

  Future<void> saveContact({String? name, List<String>? mobileNumber}) async {
    Contact newContact = Contact(
      givenName: name,
      phones: List.generate(
          mobileNumber!.length,
          (index) => Item(
                label: "mobile",
                value: mobileNumber[index],
              )),
    );
    await ContactsService.addContact(newContact);
  }
}
