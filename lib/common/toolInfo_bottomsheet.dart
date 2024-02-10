import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_textstyle.dart';
import 'colors.dart';

Future toolInfoBottomSheet(BuildContext context,
    {String? title, String? subTitle, String? btnTitle,  Widget? functionalityWidget, VoidCallback? onTap}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: appColors.white),
                color: appColors.transparent),
            child:  Icon(
              Icons.close_rounded,
              color: appColors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(50.0)),
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.white,
          ),
          child: Column(
            children: [
              if (title != null) SizedBox(height: 30.h),
              if (title != null)
                Text(
                  title,
                  style: AppTextStyle.textStyle20(
                      fontWeight: FontWeight.w600, fontColor: appColors.black),
                ),
              SizedBox(height: 16.h),
              if(subTitle != null) Text(
                subTitle,
                style: AppTextStyle.textStyle13(fontColor: appColors.black),
                textAlign: TextAlign.center,
              ),
              if(functionalityWidget != null) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: functionalityWidget,
              ),
              const SizedBox(height: 20),
              if (btnTitle != null)
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding:  EdgeInsets.symmetric(vertical: 12.5.h),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: appColors.lightYellow,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: Text(
                        btnTitle,
                        style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              // MaterialButton(
              //     height: 60,
              //     minWidth: MediaQuery.sizeOf(context).width * 0.75,
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(30)),
              //     ),
              //     onPressed: () {
              //       Navigator.pop(context);
              //       // Get.back();
              //     },
              //     //color: appColors.lightYellow,
              //     child: Text(
              //       'submit'.tr,
              //       style: AppTextStyle.textStyle20(
              //         fontWeight: FontWeight.w600,
              //         fontColor: appColors.red,
              //       ),
              //     )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ),
  );
}