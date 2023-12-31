import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
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
        child: StatefulBuilder(
          builder: (context, changeState) => Column(
            children: [
              SizedBox(
                height: 40.h,
                child: WhiteTextField(
                  controller: controller.controller,
                  contentPadding: EdgeInsets.zero,
                  hintText: "searchBlockUserHint".tr,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text,
                  icon: const Icon(Icons.search),
                  onChanged: (value) => changeState(() {}),
                ),
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: GetBuilder<BlockUserController>(
                  builder: (controller) => ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    children: controller.astroBlockCustomer
                            .search(controller.controller.text)
                            .isEmpty
                        ? [
                            Center(
                              child: Container(
                                height: 200.h,
                                alignment: Alignment.center,
                                child: CustomText(
                                  "No Result Found".tr,
                                  fontWeight: FontWeight.w500,
                                  fontColor: AppColors.blackColor,
                                ),
                              ),
                            )
                          ]
                        : controller.astroBlockCustomer
                            .search(controller.controller.text)
                            .map((e) => ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4.h,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 25.sp,
                                    backgroundColor: AppColors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: LoadImage(
                                        boxFit: BoxFit.cover,
                                        imageModel: ImageModel(
                                          placeHolderPath:
                                              Assets.images.defaultProfile.path,
                                          imagePath: e.image.toString(),
                                          loadingIndicator: const SizedBox(
                                            child: CircularProgressIndicator(
                                              color: Color(0XFFFFFFFF),
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: CustomText(
                                    e.name.toString(),
                                    fontSize: 16.sp,
                                  ),
                                  trailing: CustomButton(
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
                                                  "Unblock ${e.name}?",
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
                                                    // controller.unblockUser(
                                                    //     customerId: controller
                                                    //             .blockedUserData
                                                    //             ?.data
                                                    //             ?.first
                                                    //             .astroBlockCustomer![
                                                    //                 index]
                                                    //             .customerId ??
                                                    //         0);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                    radius: 20.r,
                                    border:
                                        Border.all(color: AppColors.darkBlue),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 8.h,
                                    ),
                                    child: CustomText('unblock'.tr,
                                        fontSize: 12.sp),
                                  ),
                                ))
                            .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
