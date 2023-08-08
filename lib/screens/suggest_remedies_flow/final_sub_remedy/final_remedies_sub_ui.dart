// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/appbar.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'final_remedies_sub_controller.dart';

class FinalRemediesSubUI extends GetView<FinalRemediesSubController> {
  const FinalRemediesSubUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: commonAppbar(
            title: AppString.suggestRemedy,
            trailingWidget: InkWell(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Assets.images.icSearch.svg(color: AppColors.darkBlue)),
            )),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: GridView.builder(
                    itemCount: controller.item.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25.h,
                        childAspectRatio: 0.59,
                        mainAxisSpacing: 30.h),
                    itemBuilder: (BuildContext context, int index) {
                      var item = controller.item[index];
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Assets.images.bgSuggestedRemedy
                                    .image(fit: BoxFit.fill),
                              ),
                              SizedBox(height: 12.h),
                              Text(item.first,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: AppColors.blackColor,
                                  )),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.last,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                        color: AppColors.darkBlue,
                                      )),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(item.last,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: AppColors.darkBlue,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(RouteName.categoryDetail);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.lightYellow),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Text(AppString.suggest,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              color: AppColors.brownColour,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
