import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_ui.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/zego_call/zego_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final NewChatController? controller;

  const ChatAppBarWidget({this.controller});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: appColors.transparent,
      leadingWidth: 30,
      leading: IconButton(
        onPressed: () {
          /// back method
          controller!.backFunction();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: appColors.black,
        ),
      ),
      title: Row(
        children: [
          // const SizedBox(width: 10),
          Obx(
            () {
              Map<String, dynamic> order = {};
              order = AppFirebaseService().orderData.value;
              String imageURL = order["astroImage"] ?? "";
              String appended =
                  "${controller!.preference.getAmazonUrl()}$imageURL";
              print("img:: -xx-$appended");
              return Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.guideColor),
                  shape: BoxShape.circle,
                ),
                child: CustomImageWidget(
                  imageUrl: appended,
                  rounded: true,
                  typeEnum: TypeEnum.user,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Flexible(
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          AppFirebaseService()
                                  .orderData
                                  .value["customerName"] ??
                              'Astrologer Name',
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: appColors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller!.showTalkTime.value == "-1"
                              ? "Chat Ended"
                              : controller!.showTalkTime.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: appColors.guideColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Chat in Progress",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Obx(
          () {
            Map orderData = AppFirebaseService().orderData.value;
            final String astrImage = orderData["astroImage"] ?? "";
            final String custImage = orderData["customerImage"] ?? "";

            String appendedAstrImage =
                "${preferenceService.getAmazonUrl()}/$astrImage";
            String appendedCustImage =
                "${preferenceService.getAmazonUrl()}/$custImage";

            print("test_appendedCustImage: $appendedAstrImage");

            return isVOIP.value.toString() == "0"
                ? const SizedBox()
                : ZegoService().buttonUI(
                    isVideoCall: false,
                    targetUserID: orderData["userId"] ?? "",
                    targetUserName: orderData["customerName"] ?? "",
                    checkOppositeSidePermGranted: () {
                      String name =
                          preferenceService.getUserDetail()?.name ?? "";
                      String message =
                          "$name wants to start a call, please allow all required permissions";

                      /// write code for send call
                      // controller.messageController.text = message;
                      // controller.sendMsg();
                    },
                    customData: {
                      "astr_id": orderData["astroId"] ?? "",
                      "astr_name": orderData["astrologerName"] ?? "",
                      "astr_image": appendedAstrImage,
                      "cust_id": orderData["userId"] ?? "",
                      "cust_name": orderData["customerName"] ?? "",
                      "cust_image": appendedCustImage,
                      // "time": "00:20:00",
                      "time": controller!.showTalkTime.value,
                    },
                    isAstrologer: true,
                    astrologerDisabledCalls: () {
                      astroNotAcceptingCallsSnackBar(
                        context: context,
                        isVideoCall: false,
                      );
                    },
                  );
          },
        ),
        const SizedBox(width: 15),
        Obx(
          () {
            Map orderData = AppFirebaseService().orderData.value;
            final String astrImage = orderData["astroImage"] ?? "";
            final String custImage = orderData["customerImage"] ?? "";

            String appendedAstrImage =
                "${preferenceService.getAmazonUrl()}$astrImage";
            String appendedCustImage =
                "${preferenceService.getAmazonUrl()}$custImage";

            return controller!.isOfferVisible.value || isVOIP.toString() == "0"
                ? const SizedBox()
                : ZegoService().buttonUI(
                    isVideoCall: true,
                    targetUserID: orderData["astroId"] ?? "",
                    targetUserName: orderData["astrologerName"] ?? "",
                    checkOppositeSidePermGranted: () {
                      String name =
                          preferenceService.getUserDetail()?.name ?? "";
                      String message =
                          "$name wants to start a call, please allow all required permissions";
                      controller!.messageController.text = message;

                      /// permission require auto generating msg
                      // controller!.sendMsg();
                    },
                    customData: {
                      "astr_id": orderData["astroId"] ?? "",
                      "astr_name": orderData["astrologerName"] ?? "",
                      "astr_image": appendedAstrImage,
                      "cust_id": orderData["userId"] ?? "",
                      "cust_name": orderData["customerName"] ?? "",
                      "cust_image": appendedCustImage,
                      "time": controller!.showTalkTime.value,
                    },
                    isAstrologer: false,
                    astrologerDisabledCalls: () {
                      astroNotAcceptingCallsSnackBar(
                        context: Get.context!,
                        isVideoCall: true,
                      );
                    },
                  );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget commonRowForPopUpMenu({IconData? icon, String? title}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(
        icon,
        size: 20,
        color: appColors.red,
      ),
      const SizedBox(width: 3),
      Text(
        title ?? "",
        style: AppTextStyle.textStyle13(),
      )
    ]);
  }
}
