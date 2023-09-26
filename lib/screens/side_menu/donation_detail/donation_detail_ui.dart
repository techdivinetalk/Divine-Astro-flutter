import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/appbar.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../common/text_field_custom.dart';
import '../../../gen/assets.gen.dart';
import 'donation_detail_controller.dart';

class DonationDetailUi extends GetView<DonationDetailController> {
  const DonationDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
          child: MaterialButton(
              height: 50,
              minWidth: Get.width,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              onPressed: () {},
              color: AppColors.lightYellow,
              child: Text(
                "donateNow".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: AppColors.brownColour,
                ),
              )),
        ),
      ),
      appBar: commonDetailAppbar(
          title: "Donation For Cow",
          trailingWidget: GestureDetector(
            onTap: () {
              Get.toNamed(RouteName.walletScreenUI);
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              width: 47.w,
              height: 26.h,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkBlue, width: 1),
                  borderRadius: BorderRadius.circular(10)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.icDonationDetailCow.image(
                  width: double.infinity, height: 224.h, fit: BoxFit.fill),
              SizedBox(height: 20.h),
              Text("Donation For Cow",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: AppColors.darkBlue,
                  )),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                      height: 68,
                      minWidth: 108.w,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      onPressed: () {},
                      color: AppColors.white,
                      child: Text(
                        "₹100",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: AppColors.darkBlue,
                        ),
                      )),
                  MaterialButton(
                      height: 68,
                      minWidth: 108.w,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      onPressed: () {},
                      color: AppColors.white,
                      child: Text(
                        "₹200",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: AppColors.darkBlue,
                        ),
                      )),
                  MaterialButton(
                      height: 68,
                      minWidth: 108.w,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      onPressed: () {},
                      color: AppColors.white,
                      child: Text(
                        "₹500",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: AppColors.darkBlue,
                        ),
                      )),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      height: 1.h,
                      width: Get.width,
                      color: AppColors.darkBlue.withOpacity(.2),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      height: 1.h,
                      width: Get.width,
                      color: AppColors.darkBlue.withOpacity(.2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text("enterCustomAmount".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: AppColors.darkBlue,
                  )),
              SizedBox(height: 20.h),
              AppTextField(
                textInputType: TextInputType.number,
                hintText: "enterAmount".tr,
                prefixIcon: Text("₹",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: AppColors.darkBlue,
                    )),
                onTap: () {},
              ),
              SizedBox(height: 20.h),
              Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.darkBlue,
                  )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
