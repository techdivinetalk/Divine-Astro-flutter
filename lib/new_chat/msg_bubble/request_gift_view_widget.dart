
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestGiftViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  RequestGiftViewWidget({required this.chatDetail, required this.yourMessage, this.controller});


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: yourMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            border: Border.all(width: 2, color: appColors.guideColor),
            color: appColors.guideColor),
        constraints: BoxConstraints(
            maxWidth: ScreenUtil().screenWidth * 0.8,
            minWidth: ScreenUtil().screenWidth * 0.27),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: CustomImageWidget(
                imageUrl: chatDetail.awsUrl ?? "",
                rounded: true,
                // added by divine-dharam
                typeEnum: TypeEnum.gift,
                //
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                '${controller!.astrologerName.value} has requested to send for ${chatDetail.message}.',
                style: AppTextStyle.textStyle14(
                  fontColor: appColors.whiteGuidedColor,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: () {
                // if (chatMessage.isPoojaProduct == false) {
                print("chatMessage.title");
                print(chatDetail.productId);
                // controller!.sendGifts(chatDetail);

                // write code for send gift

                controller?.update();
                // }
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: chatDetail.isPoojaProduct ?? false
                      ? appColors.grey
                      : appColors.red,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
                child: Text(
                  'Send',
                  style: AppTextStyle.textStyle12(fontColor: appColors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
