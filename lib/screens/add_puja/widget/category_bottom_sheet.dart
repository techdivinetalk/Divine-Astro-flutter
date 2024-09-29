import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/add_puja/model/puja_product_categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryBottomSheet extends StatefulWidget {
  final List<PujaProductCategoriesData>? categoriesType;
  final from;
  final Function(PujaProductCategoriesData)? onTap;

  const CategoryBottomSheet(
      {this.categoriesType, this.from = "", required this.onTap});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appColors.white,
              ),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.h)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Tag",
                style: AppTextStyle.textStyle20(
                  fontWeight: FontWeight.bold,
                  fontColor: appColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: List.generate(
                  widget.categoriesType!.length,
                  (index) {
                    PujaProductCategoriesData data =
                        widget.categoriesType![index];
                    return GestureDetector(
                      onTap: () {
                        data.isSelected = !data.isSelected!;
                        widget.onTap!(data);
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: data.isSelected!
                                ? widget.from == "onBoarding"
                                    ? appColors.appRedColour
                                    : appColors.textColor
                                : appColors.transparent,
                            border: Border.all(
                              color: data.isSelected!
                                  ? widget.from == "onBoarding"
                                      ? appColors.appRedColour
                                      : appColors.transparent
                                  : appColors.textColor,
                            )),
                        child: Text(
                          data.name ?? "",
                          style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w500,
                            fontColor: data.isSelected!
                                ? appColors.white
                                : appColors.textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
