import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedRemediesBottomSheet extends StatelessWidget {
  const SavedRemediesBottomSheet({super.key});

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
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      itemCount: 10,
                      shrinkWrap: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      itemBuilder: (context, index) {
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
                              CommonImageView(
                                imagePath: "assets/images/empty-box 1.png",
                                height: 70,
                                width: 70,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Shani Dev Puja",
                                          style: AppTextStyle.textStyle14(
                                            fontColor: appColors.textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: appColors.textColor,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "For relationship",
                                            style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "₹1000",
                                      style: AppTextStyle.textStyle14(
                                        fontColor: appColors.textColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "Lorem Ipsum is simply dummy text of the printing and need to fill some space ...",
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
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
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
