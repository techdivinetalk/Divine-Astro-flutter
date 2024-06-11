import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/repository/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/appbar.dart';
import '../../../common/colors.dart';

import '../../../gen/assets.gen.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'suggest_remedies_controller.dart';

class SuggestRemediesUI extends GetView<SuggestRemediesController> {
  const SuggestRemediesUI({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SuggestRemediesController(ShopRepository()));

    return Scaffold(
        drawer: const SideMenuDrawer(),
        backgroundColor: appColors.white,
        appBar: Get.currentRoute == RouteName.dashboard
            ? commonAppbar(
                title: "suggestRemedy".tr,
                trailingWidget: InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Assets.images.icSearch.svg(
                          colorFilter:  ColorFilter.mode(
                              appColors.darkBlue, BlendMode.srcIn))),
                ))
            : commonDetailAppbar(
                title: "suggestRemedy".tr,
                trailingWidget: InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Assets.images.icSearch.svg(
                            colorFilter:  ColorFilter.mode(
                                appColors.darkBlue, BlendMode.srcIn))))),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Column(
            children: [
              // InkWell(
              //   onTap: () {
              //     controller.remediesLeftPopup(Get.context!);
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.all(12.h),
              //     decoration: BoxDecoration(
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.black.withOpacity(0.2),
              //             blurRadius: 3.0,
              //             offset: const Offset(0.0, 3.0)),
              //       ],
              //       color: Colors.white,
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(10),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text.rich(
              //           TextSpan(
              //             children: [
              //               TextSpan(
              //                   text: '10  ',
              //                   style: AppTextStyle.textStyle16(
              //                       fontColor: appColors.redColor,
              //                       fontWeight: FontWeight.w400)),
              //               TextSpan(
              //                   text: "remediesLeft".tr,
              //                   style: AppTextStyle.textStyle16(
              //                       fontColor: appColors.darkBlue,
              //                       fontWeight: FontWeight.w400)),
              //             ],
              //           ),
              //         ),
              //         Icon(
              //           Icons.help_outline,
              //           size: 20.sp,
              //           color: appColors.greyColor,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 25.h),
              Obx(() =>controller.shopDataSync.value == true
                  ? Expanded(
                  child: controller.shopData?.shops?.isNotEmpty == true
                      ? GridView.builder(
                    itemCount: controller.shopData?.shops?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 25.h,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 30.h,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var item = controller.shopData?.shops?[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.suggestRemediesSubUI,
                              arguments: {"shodId": item?.id, "orderId": controller.orderId});
                        },
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 3.0),
                              ),
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
                                child: CachedNetworkImage(
                                  imageUrl: "${controller.preferenceService.getBaseImageURL()}/${item?.shopImage}",
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) => Assets.images.defaultProfile.image(),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item?.shopName ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: appColors.darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text("No data found"),
                  )
              )
                  : SizedBox())
            ],
          ),
        ));
  }
}
