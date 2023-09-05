import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/custom_light_yellow_btn.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/text_field_custom.dart';
import '../../../common/app_textstyle.dart';

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
            SizedBox(height: 15.h),
            Obx(() => controller.blockedUserDataSync.value
                ? Expanded(
                    child: ListView.builder(
                      itemCount: controller.blockedUserData?.data?.first
                              .astroBlockCustomer?.length ??
                          0,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                        "${controller.preferenceService.getBaseImageURL()}/${controller.blockedUserData?.data?[index].image}",
                                        height: 50.h,
                                        width: 50.h,
                                        fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: 15.h),
                                  Text(
                                    "${controller.blockedUserData?.data?.first.astroBlockCustomer?[index].customerId}",
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
                                                Assets.images.icUnlock.svg(
                                                    height: 64.h, width: 64.h),
                                                SizedBox(height: 15.h),
                                                Text(
                                                  "Unblock ${controller.blockedUserData?.data?[index].name}?",
                                                  style:
                                                      AppTextStyle.textStyle20(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontColor: AppColors
                                                              .darkBlue),
                                                ),
                                                SizedBox(height: 10.h),
                                                Center(
                                                  child: Text(
                                                    "unBlockMsg".tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppTextStyle
                                                        .textStyle16(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontColor: AppColors
                                                                .blackColor),
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                CustomLightYellowButton(
                                                  name: "unblock".tr,
                                                  onTaped: () {
                                                    controller.unblockUser(
                                                        customerId: controller
                                                                .blockedUserData
                                                                ?.data
                                                                ?.first
                                                                .astroBlockCustomer![
                                                                    index]
                                                                .customerId ??
                                                            0);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(width: 1)),
                                        child: Text(
                                          "unblock".tr,
                                          style: AppTextStyle.textStyle12(),
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 12.h),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
