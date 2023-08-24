import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EndSession extends StatelessWidget {
  final VoidCallback? onYes,onNo;
  const EndSession({Key? key,this.onYes,this.onNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.appColorDark),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text.rich(TextSpan(children: <InlineSpan>[
        TextSpan(text: "Are you sure you want to end the ",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor)),
        TextSpan(text: "Live Session?",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor,fontWeight: FontWeight.bold))
      ])),
      actions: [
        TextButton(
          child: Text("Yes",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor,fontWeight: FontWeight.bold)),
          onPressed: () async {
            onYes!();
            Get.back();
          },
        ),
        TextButton(
          child: Text("No",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor,fontWeight: FontWeight.bold)),
          onPressed: () async {
            onNo!();
            Get.back();
          },
        ),
      ],
    );
  }
}
