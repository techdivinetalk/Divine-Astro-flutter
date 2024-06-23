
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';

class CustomProductWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  CustomProductWidget({required this.chatDetail, required this.yourMessage, this.controller});



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 165,
        height: 250,
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            chatDetail.getCustomProduct!.image == null
                ? ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                Assets.images.defaultProfile.path,
                height: 165,
                width: 165,
                fit: BoxFit.cover,
              ),
            )
                : CommonImageView(
              height: 165,
              width: 165,
              imagePath:
              "${preferenceService.getAmazonUrl()!}${chatDetail.getCustomProduct!.image}",
              radius:
              const BorderRadius.vertical(top: Radius.circular(10)),
              fit: BoxFit.cover,
              placeHolder: Assets.images.defaultProfile.path,
              placeholderWidget: Image.asset(
                Assets.images.defaultProfile.path,
                height: 165,
                width: 165,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              chatDetail.getCustomProduct!.name ?? "",
              maxLines: 1,
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "₹${chatDetail.getCustomProduct!.amount ?? "0"}",
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 26,
                width: 85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: appColors.guideColor),
                child: Center(
                  child: Text(
                    "Buy Now",
                    style: AppTextStyle.textStyle12(
                      fontColor: appColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
