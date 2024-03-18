import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class PoojaDeleteBottomSheet extends StatelessWidget {
  final PujaListingData? pujaData;
  final Function()? onTap;
  final String? baseImageUrl;

  const PoojaDeleteBottomSheet({super.key, this.pujaData, this.onTap, this.baseImageUrl});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.h)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CustomImageView(
                    imagePath: baseImageUrl! +pujaData!.poojaImg!,
                    height: 65.h,
                    width: 65.h,
                    placeHolder: "assets/images/default_profiles.svg",
                    radius: BorderRadius.circular(100),
                  ),
                  Assets.svg.deleteAccout.svg()
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Delete “${pujaData!.poojaName}” ?",
                style: AppTextStyle.textStyle20(
                  fontColor: appColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Deleting the remedy removes it from your profile. It can’t be undo.",
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14(
                  fontColor: appColors.textColor.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appColors.guideColor,
                        ),
                        child: Text(
                          "Yes",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle20(
                            fontColor: appColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                    Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(result: 1);
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:Border.all(color: appColors.guideColor,)
                        ),
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle20(
                            fontColor: appColors.guideColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
