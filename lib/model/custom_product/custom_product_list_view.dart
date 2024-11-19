import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/custom_product/custom_product__list_controller.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/custom_widgets.dart';
import '../../screens/chat_message_with_socket/model/custom_product_model.dart';

class CustomProductListView extends GetView<CustomProductListController> {
  const CustomProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomProductListController>(
      assignId: true,
      init: CustomProductListController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            backgroundColor: appColors.white,
            surfaceTintColor: appColors.white,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            title: CustomText('custom_product'.tr),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteName.addCustomProduct)!.then(
                    (value) {
                      print("added custom product");
                      controller.getSavedRemedies();
                    },
                  );
                },
                child: SvgPicture.asset(
                  "assets/svg/chat_new_custom_product.svg",
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: controller.isLoading
              ? const GenericLoadingWidget()
              : controller.noData.isEmpty

                  /// new design
                  /*? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                      // itemCount: 10,
                      itemCount: controller.customProductData.length,
                      shrinkWrap: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      itemBuilder: (context, index) {
                        // CustomProductData data = controller.customProductData[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: appColors.textColor.withOpacity(0.4),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      "New",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    fontColor: appColors.guideColor,
                                  ),
                                  40.horizontalSpace,
                                  Container(
                                    height: 24.0,
                                    width: 1.0,
                                    color: appColors.black.withOpacity(0.1),
                                  ),
                                  16.horizontalSpace,
                                  CustomText(
                                      "Waiting",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    fontColor: appColors.yellow1,
                                  ),
                                ],
                              ),
                              12.verticalSpace,
                              Container(
                                height: 1.0,
                                width: double.infinity,
                                color: appColors.black.withOpacity(0.1),
                              ),
                              12.verticalSpace,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 48.0,
                                              width: 48.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: CustomText(
                                                            "Soumita",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      8.horizontalSpace,
                                                      LevelWidget(level: "1000")
                                                    ],
                                                  ),
                                                  CustomText(
                                                      "01 Aug 24, 05:01 PM",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.0,
                                                    fontColor: appColors.darkBlue.withOpacity(0.5),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        12.verticalSpace,
                                        Row(
                                          children: [
                                            CustomText(
                                                "Order Id : ",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0,
                                            ),
                                            CustomText(
                                                "#1234567890",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ],
                                        ),
                                        8.verticalSpace,
                                        Row(
                                          children: [
                                            CustomText(
                                              "Product Name : ",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0,
                                            ),
                                            CustomText(
                                              "Job Healing",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ],
                                        ),
                                        8.verticalSpace,
                                        Row(
                                          children: [
                                            CustomText(
                                              "Quantity : ",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0,
                                            ),
                                            CustomText(
                                              "1",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(color: appColors.guideColor)
                                          ),
                                          child: CustomText(
                                              "Chat with us",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            fontColor: appColors.guideColor,
                                          ),
                                        ),
                                        12.verticalSpace,
                                        Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: appColors.guideColor,
                                            border: Border.all(
                                              color: appColors.guideColor,
                                            )
                                          ),
                                          child: CustomText(
                                              "Request to close",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            fontColor: appColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 15),
                    )*/
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      // itemCount: controller.customProductData!.length,
                      itemCount: controller.customProductData!.length,
                      shrinkWrap: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      itemBuilder: (context, index) {
                        CustomProductData data =
                            controller.customProductData[index];

                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: appColors.textColor.withOpacity(0.4),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CustomImageView(
                                height: 65,
                                width: 65,
                                imagePath:
                                    "${Get.find<SharedPreferenceService>().getAmazonUrl()!}/${data.image!}",
                                radius: BorderRadius.circular(10),
                                placeHolder:
                                    "assets/images/default_profiles.svg",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name ?? "",
                                      style: AppTextStyle.textStyle14(
                                        fontColor: appColors.textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "₹${data.amount}",
                                      style: AppTextStyle.textStyle14(
                                        fontColor: appColors.textColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      data.desc ??
                                          "", //  "Lorem Ipsum is simply dummy text of the printing and need to fill some space ...",
                                      maxLines: 2,
                                      style: AppTextStyle.textStyle10(
                                        fontColor: appColors.textColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 15),
                    )
                  : Center(
                      child: Text(
                        "No data found!.",
                        style: AppTextStyle.textStyle20(
                          fontColor: appColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
          /*bottomNavigationBar: Padding (
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(RouteName.myRemediesListingView),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: appColors.guideColor,
                    ),
                    child: CustomText(
                        "My Remedies Listing",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      fontColor: appColors.white,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 10.0),
              ],
            ),
          ),*/
        );
      },
    );
  }
}
