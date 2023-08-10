import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'wait_list_controller.dart';

class WaitListUI extends GetView<WaitListUIController> {
  const WaitListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        title: Text("waitlist".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "nextInLine".tr,
                style: AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Assets.images.icBoyKundli
                      .svg(height: 50.h, width: 50.h, fit: BoxFit.cover),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                      "Rahul",
                      style: AppTextStyle.textStyle16(
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: AppColors.darkBlue,
                        size: 22.sp,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "9 Mins 38 Secs",
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Divider(),
              ),
              Text(
                "waitingQueue".tr,
                style: AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 15.h,
              ),
              ListView.builder(
                itemCount: 2,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Assets.images.icBoyKundli.svg(
                                height: 50.h, width: 50.h, fit: BoxFit.cover),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                "Rahul",
                                style: AppTextStyle.textStyle16(
                                    fontColor: AppColors.darkBlue),
                              ),
                            ),
                            Row(
                              children: [
                                Assets.images.icChating.svg(),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  "9 Mins 38 Secs",
                                  style: AppTextStyle.textStyle16(
                                      fontWeight: FontWeight.w400,
                                      fontColor: AppColors.darkBlue),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
