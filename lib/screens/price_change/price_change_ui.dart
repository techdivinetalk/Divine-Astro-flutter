import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/custom_light_yellow_btn.dart';
import 'price_change_req_controller.dart';

class PriceChangeReqUI extends GetView<PriceChangeReqController> {
  const PriceChangeReqUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "priceChangeRequest".tr,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${"priceChangeCondition".tr} -",
                style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10.h,
              ),
              priceChangeReqConditions(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Divider(),
              ),
              Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "customerPrice".tr,
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue),
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.darkBlue)),
                        child: Text(
                          "₹18.0",
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400,
                              fontColor: AppColors.darkBlue),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  )),
              SizedBox(height: 15.w),
              ListView.builder(
                  itemCount: controller.priceList.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    var item = controller.priceList[index];
                    return Column(
                      children: [
                        item.priceTag != null &&
                            item.priceTag!
                                .contains("Eligible for price change")
                            ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: const Divider(),
                    )
                            : SizedBox(),
                        Container(
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: AppColors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              childrenPadding: EdgeInsets.zero,
                              tilePadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${item.priceTag}",
                                      style: AppTextStyle.textStyle16(
                                          fontColor: AppColors.darkBlue),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: item.amount == "Not Eligible"
                                            ? AppColors.appRedColour
                                            : AppColors.darkGreen
                                                .withOpacity(0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${item.amount}",
                                        style: AppTextStyle.textStyle16(
                                            fontColor:
                                                item.amount == "Not Eligible"
                                                    ? AppColors.white
                                                    : AppColors.darkBlue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Text(
                                  "${item.description}",
                                  style: AppTextStyle.textStyle12(
                                      fontColor: AppColors.blackColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                      ],
                    );
                  }),
              CustomLightYellowButton(
                name: "requestPriceChangeBtn".tr,
                onTaped: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceChangeReqConditions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                "●",
                style: AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Text(
                "If customer price is < Rs 20: Customer Price can be increased by upto Rs 4 after 30 days.",
                style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                "●",
                style: AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Text(
                "If customer price >= Rs 20 and < Rs 30: Customer price can be increased by upto Rs 4, after every 3 months.",
                style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                "●",
                style: AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Text(
                "If customer price > Rs 30: Customer price can be increased by upto 10% (or Rs 4) with a maximum by Rs 10.",
                style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
