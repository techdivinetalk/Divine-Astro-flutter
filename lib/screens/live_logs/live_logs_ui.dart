import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import 'live_logs_controller.dart';

class LiveLogsUI extends GetView<LiveLogsController> {
  const LiveLogsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("liveLogs".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 50.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: appColors.greyColor3,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: appColors.greyColor2,
                    width: 2.h,
                  ),
                ),
                child: Text(
                  "liveDate".tr,
                  maxLines: 2,
                  style: AppTextStyle.textStyle16(
                    fontColor: appColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: appColors.greyColor3,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: appColors.greyColor2,
                    width: 2.h,
                  ),
                ),
                child: Text(
                  "liveDate".tr,
                  maxLines: 2,
                  style: AppTextStyle.textStyle16(
                    fontColor: appColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
