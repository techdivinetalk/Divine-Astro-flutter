import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';

import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../screens/order_chat_call_feedback/widget/chat_history_widget.dart';
import '../new_chat_controller.dart';

class TextViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  TextViewWidget({required this.chatDetail, required this.yourMessage, this.controller});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
        yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !yourMessage
                  ? Obx(
                    () {
                  Map<String, dynamic> order = {};
                  order = AppFirebaseService().orderData.value;
                  String imageURL = order["customerImage"] ?? "";
                  String appended =
                      "$preferenceService/$imageURL";
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
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                      yourMessage ? Color(0xffFFEEF0) : Color(0xffDCDCDC)),
                  color: yourMessage ? Color(0xffFFF9FA) : appColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(yourMessage ? 10 : 0),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(!yourMessage ? 10 : 0),
                  ),
                ),
                constraints: BoxConstraints(
                    maxWidth: ScreenUtil().screenWidth * 0.8,
                    minWidth: ScreenUtil().screenWidth * 0.27),
                child: Stack(
                  alignment:
                  yourMessage ? Alignment.centerLeft : Alignment.centerLeft,
                  children: [
                    Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            Text(
                              chatDetail.message ?? "",
                              style: AppTextStyle.textStyle12(
                                  fontColor: yourMessage
                                      ? chatDetail.msgType == "warningMsg"
                                      ? appColors.red
                                      : appColors.textColor
                                      : appColors.textColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h)
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          if (chatDetail.msgType != "warningMsg")
                            Text(
                              messageDateTime(
                                  int.parse(chatDetail.time.toString())),
                              style: TextStyle(
                                  fontSize: 7,
                                  color: appColors.greyColor,
                                  fontFamily: FontFamily.metropolis,
                                  fontWeight: FontWeight.w500),
                            ),
                          if (yourMessage) SizedBox(width: 5.w),
                          if (yourMessage &&
                              chatDetail.msgType != "warningMsg")
                            Obx(() => chatDetail.type == 0
                                ? Assets.images.icSingleTick.svg()
                                : chatDetail.type == 1
                                ? Assets.images.icDoubleTick.svg(
                                colorFilter: ColorFilter.mode(
                                    appColors.disabledGrey,
                                    BlendMode.srcIn))  
                                : chatDetail.type == 3
                                ? Assets.images.icDoubleTick.svg()
                                : Assets.images.icSingleTick.svg())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String messageDateTime(int datetime) {
    var millis = datetime;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
    return DateFormat('hh:mm a').format(dt);
  }
}
