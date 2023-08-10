import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/custom_light_yellow_btn.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/text_field_custom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../common/appbar.dart';
import 'block_user_controller.dart';

class BlockedUserUI extends GetView<BlockUserController> {
  const BlockedUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(
        title: "blockedUsers".tr,
      ),
      body: Padding(
        padding: EdgeInsets.all(14.h),
        child: Column(
          children: [
            WhiteTextField(
                hintText: "searchBlockUserHint".tr,
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                icon: const Icon(Icons.search)),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 45.h,
                              width: 45.h,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              "Deep Pratap",
                              style: AppTextStyle.textStyle16(),
                            ),
                            const Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                openBottomSheet(context,
                                    functionalityWidget: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: Column(
                                        children: [
                                          Assets.images.icUnlock
                                              .svg(height: 64.h, width: 64.h),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Text(
                                            "Unblock Deep Pratap?",
                                            style: AppTextStyle.textStyle20(
                                                fontWeight: FontWeight.w700,
                                                fontColor: AppColors.darkBlue),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Center(
                                            child: Text(
                                              "unBlockMsg".tr,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.textStyle16(
                                                  fontWeight: FontWeight.w400,
                                                  fontColor:
                                                      AppColors.blackColor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          CustomLightYellowButton(
                                            name: "unblock".tr,
                                            onTaped: () {},
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(width: 1)),
                                  child: Text(
                                    "unblock".tr,
                                    style: AppTextStyle.textStyle12(),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
