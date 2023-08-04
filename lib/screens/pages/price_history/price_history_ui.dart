import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'price_history_controller.dart';

class PriceHistoryUI extends GetView<PriceHistoryController> {
  const PriceHistoryUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.priceChangeRequest,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Get.toNamed(RouteName.priceChangeReqUI);

              },
              child: Container(
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.icPriceChange
                          .svg(height: 20.h, width: 20.w),
                      SizedBox(width: 10.w),
                      Text(
                        AppString.priceChangeBtn,
                        style: AppTextStyle.textStyle20(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${AppString.serviceType} : ",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          Text(
                            AppString.call,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w700,
                                fontColor: AppColors.darkBlue),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppString.priceRequested} : ",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          Text(
                            "₹35/Min",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppString.requestRaised} : ",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          Text(
                            "24 Aug 22, 12:20 PM",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppString.status} : ",
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          Text(
                            AppString.approved,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w700,
                                fontColor: AppColors.darkGreen),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: const Divider(),
                      )
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
