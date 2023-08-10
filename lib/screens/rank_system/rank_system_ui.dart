import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/strings.dart';
import 'rank_system_controller.dart';

class RankSystemUI extends GetView<RankSystemController> {
  const RankSystemUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          "rankSystem".tr,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1.0,
                        offset: const Offset(0.0, 3.0)),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.h),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "totalMarksObtained".tr,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.textStyle12(
                                    fontWeight: FontWeight.w700,
                                    fontColor: AppColors.darkBlue),
                              ),
                              Text(
                                "(in % Percentage)",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.textStyle12(
                                    fontWeight: FontWeight.w400,
                                    fontColor: AppColors.darkBlue),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Astrologer\nRank",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.textStyle12(
                                    fontWeight: FontWeight.w700,
                                    fontColor: AppColors.darkBlue),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                        itemCount: controller.systemRankList.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          var item = controller.systemRankList[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      item.percentage.toString(),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textStyle12(
                                          fontWeight: FontWeight.w700,
                                          fontColor: AppColors.darkBlue),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        item.image ??
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          item.astrologerRank.toString(),
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.textStyle12(
                                              fontWeight: FontWeight.w700,
                                              fontColor: AppColors.darkBlue),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                            'Note : The data will undergo regular refresh cycles with a frequency of once every ',
                        style: AppTextStyle.textStyle12(
                            fontColor: AppColors.greyColor,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: '10 days.',
                        style: AppTextStyle.textStyle12(
                            fontColor: AppColors.darkBlue,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
