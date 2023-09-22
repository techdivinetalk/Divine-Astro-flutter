import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';

import '../../common/appbar.dart';
import '../../model/performance_model_class.dart';
import 'rank_system_controller.dart';

class RankSystemUI extends GetView<RankSystemController> {
  const RankSystemUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: "rankSystem".tr),
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
                                "astrologerRank".tr,
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
                        itemCount: controller.rankSystemList?.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          RankSystem? item = controller.rankSystemList?[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      item?.percentageRange ?? "",
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        setImage(item?.rank ?? "") ??
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          item?.rank ??'',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.textStyle12(
                                              fontWeight: FontWeight.w400,
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
                        text: 'noteText'.tr,
                        style: AppTextStyle.textStyle12(
                            fontColor: AppColors.greyColor,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: ' 10 ${'day'.tr}.',
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
  setImage(String rank){
    if(rank == "Diamond"){
      return Assets.images.icDiamond.image(height: 21.h, width: 21.h);
    }else if(rank == "Platinum"){
      return Assets.images.icPlatinum.image(height: 21.h, width: 21.h);
    }else if(rank == "Gold"){
      return Assets.images.icGold.image(height: 21.h, width: 21.h);
    }else if(rank == "Silver"){
      return Assets.images.icSilver.image(height: 21.h, width: 21.h);
    }else if(rank == "Bronze"){
      return Assets.images.icBronze.image(height: 21.h, width: 21.h);
    }
    else{
      return SizedBox(  width: 10.w,);
    }
  }
}
