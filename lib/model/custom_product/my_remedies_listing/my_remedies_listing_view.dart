import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/model/custom_product/my_remedies_listing/my_remedies_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyRemediesListingView extends GetView<MyRemediesListingController> {
  const MyRemediesListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        backgroundColor: appColors.white,
        surfaceTintColor: appColors.white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const CustomText("My Remedies Listing"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(() => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isRequested.value = true,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: controller.isRequested.value ? appColors.darkBlue : appColors.darkBlue.withOpacity(0.5),
                              width: controller.isRequested.value ? 2.0 : 1.0,
                            ),
                          )
                      ),
                      child: CustomText(
                        "Requested",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        fontColor: controller.isRequested.value ? appColors.darkBlue : appColors.darkBlue.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.isRequested.value = false,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: !controller.isRequested.value ? appColors.darkBlue : appColors.darkBlue.withOpacity(0.5),
                              width: !controller.isRequested.value ? 2.0 : 1.0,
                            ),
                          )
                      ),
                      child: CustomText(
                        "My Listing",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        fontColor: !controller.isRequested.value ? appColors.darkBlue : appColors.darkBlue.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
          15.verticalSpace,
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              itemBuilder: (context, index) {
                return Obx(() => dataWidget(status: controller.isRequested.value ? "Pending for Approval" : "Approved"));
              },),
          ),
          5.verticalSpace,
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: appColors.guideColor,
              ),
              child: CustomText(
                "+ Add New Remedy",
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                fontColor: appColors.white,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10.0),
        ],
      ),
    );
  }

  Container dataWidget({required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appColors.white,
        // border: Border.all(color: appColors.guideColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260E2339),
            blurRadius: 6,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 96.0,
            width: 96.0,
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.0)
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Mritunjay Puja",
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                fontColor: appColors.black,
              ),
              4.verticalSpace,
              CustomText(
                "Listed Price : ₹6000",
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
                fontColor: appColors.black,
              ),
              16.verticalSpace,
              CustomText(
                status,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                fontColor: status == "Approved" ? appColors.green : appColors.guideColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
