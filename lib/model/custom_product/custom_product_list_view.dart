import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/add_custom_product/add_custom_product_controller.dart';
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
            title: CustomText('Custom Product'.tr),
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
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    /*Text(
                                      "Lorem Ipsum is simply dummy text of the printing and need to fill some space ...",
                                      maxLines: 2 ,
                                      style: AppTextStyle.textStyle10(
                                        fontColor: appColors.textColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),*/
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
        );
      },
    );
  }
}
