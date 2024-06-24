
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
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
      alignment: Alignment.bottomRight,
      child: Container(
        width: 165,
        height: 220,
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomImageView(
              height: 165,
              width: 165,
              imagePath:
              "$preferenceService/${chatDetail.getCustomProduct!.image}",
              radius: const BorderRadius.vertical(top: Radius.circular(10)),
              placeHolder: "assets/images/default_profiles.svg",
              fit: BoxFit.cover,
            ),
            Text(
              chatDetail.getCustomProduct!.name ?? "",
              maxLines: 1,
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w400,
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
          ],
        ),
      ),
    );
  }
}
