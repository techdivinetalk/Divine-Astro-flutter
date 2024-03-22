import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/custom_puja/create_custom_product.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedRemediesBottomSheet extends StatelessWidget {
  final List<CustomProductData>? customProductData;
  final ChatMessageWithSocketController? controller;

  const SavedRemediesBottomSheet(
      {super.key, this.customProductData, this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.white),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear_rounded,
                  color: appColors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Saved Remedies",
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 200,
                    child: controller!.customProductData.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: controller!.customProductData.length,
                            shrinkWrap: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            itemBuilder: (context, index) {
                              print("customProductData!.length");
                              CustomProductData data =
                                  controller!.customProductData[index];
                              print(controller!.pref.getAmazonUrl()! +
                                  data.image!);
                              print("data.image");
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          appColors.textColor.withOpacity(0.4),
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
                                          controller!.pref.getAmazonUrl()! +
                                              "/${data.image!}",
                                      radius: BorderRadius.circular(10),
                                      placeHolder:
                                          "assets/images/default_profiles.svg",
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                            separatorBuilder:
                                (BuildContext context, int index) =>
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
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.bottomSheet(
                          CreateCustomProductSheet(controller: controller),
                          isScrollControlled: true);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColors.guideColor,
                      ),
                      child: Text(
                        "Create New Remedy",
                        style: AppTextStyle.textStyle20(
                          fontColor: appColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
