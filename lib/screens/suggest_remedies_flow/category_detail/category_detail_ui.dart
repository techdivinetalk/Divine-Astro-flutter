import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/res_product_detail.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/colors.dart';
import '../../../common/custom_light_yellow_btn.dart';

class CategoryDetailUi extends GetView<CategoryDetailController> {
  const CategoryDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDetailController>(
      assignId: true,
      builder: (controller) {
        return Scaffold(
          appBar: commonDetailAppbar(
            title: "suggestRemedy".tr,
            trailingWidget: Container(
              margin: EdgeInsets.only(right: 16.w),
              width: 47.w,
              height: 26.h,
              decoration:
                  BoxDecoration(border: Border.all(color: appColors.darkBlue, width: 1), borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("₹500",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: appColors.darkBlue,
                    )),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => controller.shopDataSync.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonImageView(
                            imagePath:
                                "${Get.find<SharedPreferenceService>().getBaseImageURL()}${controller.productDetail?.prodImage}",
                            radius: BorderRadius.circular(20.h),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "${controller.productDetail?.prodName}",
                            style: AppTextStyle.textStyle20(fontWeight: FontWeight.w400),
                          ),
                          // SizedBox(height: 10.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 11.w),
                                child: Text(
                                  "Select Quantity",
                                  style: AppTextStyle.textStyle10(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Text(
                                    "₹${controller.productDetail?.productPriceInr}",
                                    style: AppTextStyle.textStyle20(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.h,
                                      vertical: 4.h,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: appColors.darkBlue), borderRadius: BorderRadius.circular(10.h)),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: controller.decrementQuantity,
                                            child: Icon(Icons.remove_rounded, color: appColors.darkBlue)),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "${controller.selectedQuantity}",
                                          style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        GestureDetector(
                                            onTap: controller.incrementQuantity,
                                            child: Icon(Icons.add_rounded, color: appColors.darkBlue)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Html(
                            data:controller.productDetail!.productLongDesc ?? "",
                            onLinkTap: (url, attributes, element) {
                              launchUrl(Uri.parse(url ?? ''));
                            }, 
                          ),
                          SizedBox(height: 10.h),
                          ...List.generate(
                            controller.productDetail!.productFaq!.length,
                            (index) {
                              ProductFaq data = controller.productDetail!.productFaq![index];
                              return GestureDetector(
                                onTap: () {
                                  data.isExpand = !data.isExpand!;
                                  controller.update();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.title ?? "",
                                            style: AppTextStyle.textStyle12(
                                              fontWeight: FontWeight.w400,
                                              fontColor: appColors.darkBlue,
                                            ),
                                          ),
                                          Icon(
                                            data.isExpand! ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                            size: 30.h,
                                            color: appColors.darkBlue,
                                          ),
                                        ],
                                      ),
                                      data.isExpand!
                                          ? Text(
                                              data.description ?? "",
                                              style: AppTextStyle.textStyle12(
                                                fontWeight: FontWeight.w400,
                                                fontColor: appColors.lightGrey,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
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
                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          children: [
                            Text(
                              "Are You Sure You Want To Suggest ${controller.productDetail?.prodName} To User?",
                              style: AppTextStyle.textStyle20(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "On purchase 30% referral bonus will be added in your wallet",
                              style: AppTextStyle.textStyle12(
                                  fontWeight: FontWeight.w600, fontColor: appColors.darkBlue.withOpacity(0.5)),
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
                  color: appColors.guideColor,
                  child: Text(
                    "suggestNow".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: appColors.brownColour,
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}
