// ignore_for_file: deprecated_member_use_from_same_package

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/appbar.dart';
import '../../../common/colors.dart';

import '../../../gen/assets.gen.dart';
import 'suggest_remedies_sub_controller.dart';

class SuggestRemediesSubUI extends GetView<SuggestRemediesSubController> {
  const SuggestRemediesSubUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: commonAppbar(
            title: "suggestRemedy".tr,
            trailingWidget: InkWell(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Assets.images.icSearch.svg(color: AppColors.darkBlue)),
            )),
        body: Column(
          children: [
            Obx(() => controller.productListSync.value == true
                ? controller.productList?.products?.isEmpty ?? true
                    ? const Center(child: Text("No data available"))
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: GridView.builder(
                              itemCount:
                                  controller.productList?.products?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 25.h,
                                      childAspectRatio: 0.68,
                                      mainAxisSpacing: 30.h),
                              itemBuilder: (BuildContext context, int index) {
                                var item =
                                    controller.productList?.products?[index];
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(RouteName.finalRemediesSubUI);
                                  },
                                  child: Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    "${controller.preferenceService.getBaseImageURL()}/${item?.prodImage}")),
                                        SizedBox(height: 12.h),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(item?.prodName ?? "",
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: AppColors.blackColor,
                                              )),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text("₹ ${item?.productPriceInr}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: AppColors.lightGrey,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                : const SizedBox())
          ],
        ));
  }
}
