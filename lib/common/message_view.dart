import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

class MessageView extends StatelessWidget {
  final int index;
  final ChatMessage chatMessage;
  final String userName;
  final bool yourMessage;
  final int? unreadMessage;

  const MessageView({
    super.key,
    required this.index,
    required this.userName,
    required this.chatMessage,
    required this.yourMessage,
    this.unreadMessage,
  });

  Widget buildMessageView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    Widget messageWidget;
    print("chat Message:: ${chatMessage.msgType}");
    switch (chatMessage.msgType) {
      case "gift":
        messageWidget = giftMsgView(context, chatMessage, yourMessage);
        break;
      case "sendGifts":
        messageWidget = giftSendUi(context, chatMessage, yourMessage, userName);
        break;
      case "Remedies" || 0:
        messageWidget = remediesMsgView(context, chatMessage, yourMessage);
        break;
      case "text":
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      case "audio":
        messageWidget = audioView(context,
            chatDetail: chatMessage, yourMessage: yourMessage);
        break;
      case "image":
        messageWidget = imageMsgView(chatMessage.base64Image ?? "", yourMessage,
            chatDetail: chatMessage, index: index);
        break;
      case "kundli":
        messageWidget = kundliView(chatDetail: chatMessage, index: 0);
        break;
      case "Product":
        messageWidget = productMsgView(chatMessage, yourMessage);
        break;
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat
    if (chatMessage.id == unreadMessage) {
      return Column(
        children: [
          unreadMessageView(),
          messageWidget,
        ],
      );
    } else {
      return messageWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildMessageView(context, chatMessage, yourMessage);
  }

  Widget productMsgView(ChatMessage chatMessage, bool yourMessage) {
    return GestureDetector(
      onTap: () {
        print(
            "data from page ${chatMessage.productId} ${chatMessage.isPoojaProduct} ${chatMessage.customerId}");
        if (chatMessage.isPoojaProduct ?? false) {
          Get.toNamed(RouteName.poojaDharamDetailsScreen, arguments: {
            'detailOnly': true,
            "isSentMessage": true,
            'data': int.parse(chatMessage.productId ?? '0')
          });
        } else {
          Get.toNamed(RouteName.categoryDetail, arguments: {
            "productId": chatMessage.productId.toString(),
            "isSentMessage": true,
            "customerId": chatMessage.senderId,
          });
        }
      },
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment:
              yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appColors.guideColor,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0.sp),
                    child: Image.asset('assets/svg/Group 128714.png'),
                  ),
                  title: CustomText(
                    "You have suggested a ${chatMessage.isPoojaProduct ?? false ? "Pooja" : "product"}",
                    fontSize: 14.sp,
                    maxLines: 2,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: CustomText(
                    chatMessage.message ?? '',
                    fontSize: 12.sp,
                    maxLines: 20,
                  ),
                  // onTap: () => Get.toNamed(RouteName.remediesDetail,
                  //     arguments: {'title': temp[0], 'subtitle': temp[1]}),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget giftMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    return SizedBox(
      width: double.maxFinite,
      child: Expanded(
        child: Column(
          crossAxisAlignment:
              yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                color: appColors.guideColor,
              ),
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
                      imageUrl: chatMessage.awsUrl ?? '',
                      rounded: true,
                      // added by divine-dharam
                      typeEnum: TypeEnum.gift,
                      //
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                      child: CustomText(
                          'Astrologer has requested to send ${chatMessage.message}.',maxLines: 2,))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget remediesMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    var jsonString = (chatMessage.message ?? '')
        .substring(1, (chatMessage.message ?? '').length - 1);
    List temp = jsonString.split(', ');

    print("get templist $temp");

    if (temp.length < 2) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: appColors.guideColor,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: appColors.red,
                  child: CustomText(
                    temp[0][0],
                    fontColor: appColors.white,
                  ), // Display the first letter of the name
                ),
                title: CustomText(
                  temp[0],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: CustomText(
                  temp[1] ?? '',
                  fontSize: 12.sp,
                  maxLines: 20,
                ),
                onTap: () => Get.toNamed(RouteName.remediesDetail,
                    arguments: {'title': temp[0], 'subtitle': temp[1]}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    RxInt msgType = (chatMessage.type ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
                maxWidth: ScreenUtil().screenWidth * 0.7,
                minWidth: ScreenUtil().screenWidth * 0.27),
            child: Stack(
              alignment:
                  yourMessage ? Alignment.centerRight : Alignment.centerLeft,
              children: [
                Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          chatMessage.message ?? "",
                          style: AppTextStyle.textStyle14(
                              fontColor: chatMessage.msgType == "text2"
                                  ? appColors.red
                                  : appColors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h)
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(chatMessage.time ?? 0),
                        style: AppTextStyle.textStyle10(
                          fontColor: appColors.darkBlue,
                        ),
                      ),
                      if (yourMessage) SizedBox(width: 8.w),
                      if (yourMessage)
                        Obx(() => msgType.value == 0
                            ? Assets.images.icSingleTick.svg()
                            : msgType.value == 1
                                ? Assets.images.icDoubleTick.svg(
                                    colorFilter: ColorFilter.mode(
                                        appColors.greyColor, BlendMode.srcIn))
                                : msgType.value == 3
                                    ? Assets.images.icDoubleTick.svg()
                                    : Assets.images.icSingleTick.svg())
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget audioView(BuildContext context,
      {required ChatMessage chatDetail, required bool yourMessage}) {
    RxInt msgType = (chatDetail.type ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 3.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                VoiceMessageView(
                    controller: VoiceController(
                        audioSrc: chatDetail.awsUrl!,
                        maxDuration: const Duration(seconds: 120),
                        isFile: false,
                        onComplete: () => debugPrint("onComplete"),
                        onPause: () => debugPrint("onPause"),
                        onPlaying: () => debugPrint("onPlaying")),
                    innerPadding: 0,
                    cornerRadius: 20),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(chatDetail.time ?? 0),
                        style: AppTextStyle.textStyle10(
                            fontColor: appColors.black),
                      ),
                      if (yourMessage) SizedBox(width: 8.w),
                      if (yourMessage)
                        msgType.value == 0
                            ? Assets.images.icSingleTick.svg()
                            : msgType.value == 1
                                ? Assets.images.icDoubleTick.svg(
                                    colorFilter: ColorFilter.mode(
                                        appColors.lightGrey, BlendMode.srcIn))
                                : msgType.value == 3
                                    ? Assets.images.icDoubleTick.svg()
                                    : Assets.images.icSingleTick.svg()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget giftSendUi(BuildContext context, ChatMessage chatMessage,
      bool yourMessage, String customerName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 10),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "$customerName have sent ${chatMessage.message}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(width: 10.h),
            SizedBox(
              height: 32,
              width: 32,
              child: CustomImageWidget(
                imageUrl: chatMessage.awsUrl ?? '',
                rounded: true,
                // added by divine-dharam
                typeEnum: TypeEnum.gift,
                //
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageMsgView(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    // Uint8List bytesImage = const Base64Decoder().convert(image);
    Uint8List bytesImage = base64.decode(image);
    // final localImagefile = File.fromRawPath(bytesImage);
    RxInt msgType = (chatDetail.type ?? 0).obs;
    var chatController = Get.find<ChatMessageWithSocketController>();
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              constraints: BoxConstraints(
                  maxWidth: ScreenUtil().screenWidth * 0.7,
                  minWidth: ScreenUtil().screenWidth * 0.27),
              child: yourMessage
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print(chatMessage.awsUrl);
                            print("chatMessage.awsUrl");
                            Get.toNamed(RouteName.imagePreviewUi,
                                arguments: chatMessage.awsUrl);
                          },
                          child: Image.memory(
                            bytesImage,
                            fit: BoxFit.cover,
                            height: 200.h,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6)
                                .copyWith(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10.r)),
                              gradient: LinearGradient(
                                colors: [
                                  appColors.darkBlue.withOpacity(0.0),
                                  appColors.darkBlue.withOpacity(0.0),
                                  appColors.darkBlue.withOpacity(0.5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  messageDateTime(chatDetail.time ?? 0),
                                  style: AppTextStyle.textStyle10(
                                      fontColor: appColors.white),
                                ),
                                if (yourMessage) SizedBox(width: 8.w),
                                if (yourMessage)
                                  msgType.value == 0
                                      ? Assets.images.icSingleTick.svg()
                                      : msgType.value == 1
                                          ? Assets.images.icDoubleTick.svg(
                                              colorFilter: ColorFilter.mode(
                                                  appColors.greyColor,
                                                  BlendMode.srcIn))
                                          : msgType.value == 3
                                              ? Assets.images.icDoubleTick.svg()
                                              : Assets.images.icSingleTick.svg()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : chatDetail.downloadedPath == ""
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Image.network(
                                  chatDetail.awsUrl ?? '',
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                chatController.downloadImage(
                                    fileName: image,
                                    chatDetail: chatDetail,
                                    index: index);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.darkBlue.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.download_rounded,
                                    color: appColors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 6)
                                        .copyWith(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.r)),
                                      gradient: LinearGradient(
                                        colors: [
                                          appColors.darkBlue.withOpacity(0.0),
                                          appColors.darkBlue.withOpacity(0.0),
                                          appColors.darkBlue.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      messageDateTime(chatDetail.time ?? 0),
                                      style: AppTextStyle.textStyle10(
                                          fontColor: appColors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed(RouteName.imagePreviewUi,
                                arguments: chatDetail.downloadedPath);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0.r),
                                child: Image.file(
                                  File(chatDetail.downloadedPath ?? ""),
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                ),
                              ),
                            ],
                          ),
                        ))
        ],
      ),
    );
  }

  Widget kundliView({required ChatMessage chatDetail, required int index}) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.kundliDetail, arguments: {
          "kundli_id": chatDetail.kundliId,
          "from_kundli": true,
          "birth_place": chatDetail.kundliPlace,
          "gender": chatDetail.gender,
          "name": chatDetail.kundliName,
        });
        debugPrint("KundliId : ${chatDetail.kundliId}");
      },
      child: Card(
        color: appColors.white,
        surfaceTintColor: appColors.white,
        child: Container(
          padding: EdgeInsets.all(12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: appColors.extraLightGrey),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    chatDetail.kundliName?[0] ?? "",
                    style: AppTextStyle.textStyle24(
                        fontColor: appColors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDetail.kundliName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliDateTime ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: appColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliPlace ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: appColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget unreadMessageView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: appColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text("unreadMessages".tr),
      ),
    );
  }
}
