import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/appbar.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import 'donation_controller.dart';

class DonationUi extends GetView<DonationController> {
  const DonationUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(
          title: "donation".tr,
          trailingWidget: GestureDetector(
            onTap: () {
              Get.toNamed(RouteName.walletScreenUI);
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              width: 47.w,
              height: 26.h,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor, width: 1), borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("₹500",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.darkBlue,
                    )),
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: GridView.builder(
            itemCount: controller.item.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 15.h, crossAxisSpacing: 15.h, crossAxisCount: 2, childAspectRatio: 0.68
                // childAspectRatio: 172.w / 260.h
                ),
            itemBuilder: (BuildContext context, int index) {
              var item = controller.item[index];
              return Card(
                color: AppColors.white,
                surfaceTintColor: AppColors.white,
                elevation: 2.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Material(
                  color: AppColors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RouteName.donationDetailPage, arguments: item);
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Assets.images.icCow.image(
                            height: 150.h,
                            width: 172.w,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.first,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              item.last.isNotEmpty
                                  ? Text(
                                      item.last,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: AppColors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : SizedBox.shrink(),
                              if (item.last.isNotEmpty) SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),

      /*Padding(
          padding: EdgeInsets.only(left: 32.w, right: 32.w),
          child: GridView.builder(
              itemCount: controller.item.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 20.0.h,
                  crossAxisSpacing: 20.0.w,
                  crossAxisCount: 2,
                  childAspectRatio:0.70 */ /*172.w / 260.h*/ /*),
              itemBuilder: (BuildContext context, int index) {
                var item = controller.item[index];
                return SizedBox(
                  height: 254.h,
                  width: 172.w,
                  child: Card(
                    color: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    elevation: 2.0,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(RouteName.donationDetailPage);
                          },
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Assets.images.icCow.image(
                                height: 150.h,
                                width: 172.w,
                              ),
                             // SizedBox(height: 8.h),
                              Text(item.first,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    color: AppColors.darkBlue,
                                  )),
                              //SizedBox(height: 4.h),
                              Text(item.last,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: AppColors.darkBlue,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )*/
    );
  }
}
