import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EndCoHost extends StatelessWidget {
  final VoidCallback? onYes, onNo;
  final String? name;
  const EndCoHost({Key? key, this.onYes, this.onNo, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appColors.white,
      surfaceTintColor: appColors.white,
      shape: OutlineInputBorder(
        borderSide:  BorderSide(color: appColors.appYellowColour),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text.rich(TextSpan(children: <InlineSpan>[
        TextSpan(
            text: "Are you sure you want to Disconnect the call with ",
            style: TextStyle(fontSize: 16.sp, color: appColors.darkBlue)),
        TextSpan(
            text: name ?? "",
            style: TextStyle(
                fontSize: 16.sp,
                color: appColors.darkBlue,
                fontWeight: FontWeight.bold))
      ])),
      actions: [
        TextButton(
          child: Text("Yes",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                  fontWeight: FontWeight.bold)),
          onPressed: () async {
            onYes!();
            Get.back();
          },
        ),
        TextButton(
          child: Text("No",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                  fontWeight: FontWeight.bold)),
          onPressed: () async {
            onNo!();
            Get.back();
          },
        ),
      ],
    );
  }
}
