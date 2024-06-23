import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

class SendGiftWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  SendGiftWidget({required this.chatDetail, required this.yourMessage, this.controller});


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: CustomImageWidget(
                imageUrl: chatDetail.awsUrl ?? "" ?? '',
                rounded: true,
                // added by divine-dharam
                typeEnum: TypeEnum.gift,
                //
              ),
            ),
            Text(
              " you have sent ${chatDetail.message!.contains("https") ? "" : chatDetail.message ?? ""}",
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
