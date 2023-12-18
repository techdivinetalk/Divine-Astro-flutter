import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../common/custom_light_yellow_btn.dart';
import '../../../utils/load_image.dart';

class CategoryDetailUi extends GetView<CategoryDetailController> {
  const CategoryDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(
        title: "suggestRemedy".tr,
        trailingWidget: Container(
          margin: EdgeInsets.only(right: 16.w),
          width: 47.w,
          height: 26.h,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.darkBlue, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text("₹500",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.darkBlue,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx( () => controller.shopDataSync.value ?
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: LoadImage(
                      boxFit: BoxFit.fill,
                      imageModel: ImageModel(
                          imagePath:
                          '${controller.preferenceService.getBaseImageURL()}/${controller.productDetail?.products?[0].prodImage}',
                          loadingIndicator: const SizedBox(
                              child:
                              CircularProgressIndicator(color: Color(0XFFFDD48E), strokeWidth: 2))),
                    )),
                // Assets.images.icKalashDetail.image(
                //     width: double.infinity, height: 224.h, fit: BoxFit.fill),
                SizedBox(height: 20.h),
                Text("${controller.productDetail?.products?[0].prodName}",
                    style: AppTextStyle.textStyle20(fontWeight: FontWeight.w400)),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    // Text("₹15000", style: AppTextStyle.textStyle20lineThrough()),
                    // const SizedBox(width: 15),
                    Text(
                      "₹ ${controller.productDetail?.products?[0].productPriceInr}",
                      style: AppTextStyle.textStyle20(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Product",
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.appYellowColour),
                      ),
                      const SizedBox(height: 10),
                      ReadMoreText(
                        "${controller.productDetail?.products?[0].prodDesc}",
                        trimLines: 4,
                        colorClickableText: AppColors.blackColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: "readMore".tr,
                        trimExpandedText: "showLess".tr,
                        moreStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appYellowColour,
                        ),
                        lessStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appYellowColour,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ) : const SizedBox(),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
          child: MaterialButton(
              height: 50,
              minWidth: Get.width,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              onPressed: () {
                openBottomSheet(
                  context,
                  functionalityWidget: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        Text(
                          "Are You Sure You Want To Suggest ${controller.productDetail?.products?[0].prodName} To User?",
                          style: AppTextStyle.textStyle20(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "On purchase 30% referral bonus will be added in your wallet",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.darkBlue.withOpacity(0.5)),
                        ),
                        CustomLightYellowCurveButton(
                          name: "suggestNow".tr,
                          onTaped: () {
                            controller.suggestRemedy();
                            // Get.offNamedUntil(RouteName.orderHistory,
                            //     ModalRoute.withName(RouteName.dashboard));
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              color: AppColors.lightYellow,
              child: Text(
                "suggestNow".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: AppColors.brownColour,
                ),
              )),
        ),
      ),
    );
  }
}
