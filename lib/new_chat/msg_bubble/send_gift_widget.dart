import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendGiftWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;

  SendGiftWidget({
    required this.chatDetail,
    required this.yourMessage,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    print(chatDetail.awsUrl);
    print("chatDetail.awsUrl");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !yourMessage
            ? Obx(
                () {
                  Map<String, dynamic> order = {};
                  order = AppFirebaseService().orderData.value;
                  String imageURL = order["customerImage"] ?? "";
                  String appended = "$preferenceService/$imageURL";
                  print("img:: $appended");
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: CustomImageWidget(
                        imageUrl: appended,
                        rounded: true,
                        typeEnum: TypeEnum.user,
                      ),
                    ),
                  );
                },
              )
            : SizedBox(),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
                color: yourMessage
                    ? const Color(0xffFFEEF0)
                    : const Color(0xffDCDCDC)),
            color: yourMessage ? const Color(0xffFFF9FA) : appColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(10),
              topLeft: Radius.circular(yourMessage ? 10 : 0),
              bottomRight: const Radius.circular(10),
              topRight: Radius.circular(!yourMessage ? 10 : 0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  "${AppFirebaseService().orderData.value["customerName"]} have sent ${chatDetail.message!.contains("https") ? "" : chatDetail.message ?? ""}",
                  style: const TextStyle(
                      color: Colors.red,
                      fontFamily: FontFamily.metropolis,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                width: 32,
                child: CustomImageWidget(
                  // imageUrl:preferenceService.getAmazonUrl()!.contains("https://divineprod.blob.core.windows.net/divineprod") ?chatDetail.awsUrl : "${preferenceService.getAmazonUrl()!}${chatDetail.awsUrl}",
                  imageUrl: chatDetail.awsUrl ?? '',
                  rounded: true,
                  // added by divine-dharam
                  typeEnum: TypeEnum.gift,
                  //
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
