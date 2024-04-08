import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import '../utils/load_image.dart';

var chatController = Get.find<ChatMessageWithSocketController>();

class MessageView extends StatelessWidget {
  final int index;
  final ChatMessage chatMessage;
  final ChatMessage nextChatMessage;
  final String userName;
  final bool yourMessage;
  final int? unreadMessage;
  final bool? unreadMessageShow;
  final List<String>? myList;

  const MessageView({
    super.key,
    required this.index,
    required this.userName,
    required this.chatMessage,
    required this.nextChatMessage,
    required this.yourMessage,
    this.unreadMessage,
    this.unreadMessageShow = true,
    this.myList,
  });

  Widget buildMessageView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    // print("message Detail $chatMessage");
    // final currentMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(chatMessage.createdAt ?? '0'));
    // final nextMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(nextChatMessage.createdAt ?? '0'));
    // final differenceOfDays = nextMsgDate.day - currentMsgDate.day;
    // final isToday = (DateTime.now().day - currentMsgDate.day) == 1;
    // final isYesterday = (DateTime.now().day - currentMsgDate.day) == 2;
    Widget messageWidget;
    print("chat Message:: ${chatMessage.msgType}");
    switch (chatMessage.msgType) {
      case MsgType.gift:
        messageWidget =
            giftMsgView(context, chatMessage, yourMessage, userName);
        break;
      case MsgType.sendgifts:
        messageWidget = giftSendUi(context, chatMessage, yourMessage, userName);
        break;
      case MsgType.remedies:
        messageWidget = remediesMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.text:
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.audio:
        messageWidget = audioView(context,
            chatDetail: chatMessage, yourMessage: yourMessage);
        break;
      case MsgType.image:
        messageWidget = imageMsgView(chatMessage.base64Image ?? "", yourMessage,
            chatDetail: chatMessage, index: index);
        break;
      case MsgType.kundli:
        messageWidget = kundliView(chatDetail: chatMessage, index: 0);
        break;
      case MsgType.customProduct:
        messageWidget = CustomProductView(chatDetail: chatMessage, index: 0);
        break;
      case MsgType.product || MsgType.pooja:
        messageWidget = productMsgView(chatMessage, yourMessage);
        break;
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat

    return unreadMessageShow! == false ? Column(
      children: [
        if (chatMessage.id == unreadMessage) unreadMessageView(),
        // if (index == 0)
        //   dayWidget(
        //       currentMsgDate: currentMsgDate,
        //       nextMsgDate: nextMsgDate,
        //       isToday: (DateTime.now().day - currentMsgDate.day) == 0,
        //       isYesterday: (DateTime.now().day - currentMsgDate.day) == 1,
        //       differenceOfDays: 1),

        messageWidget,
        // if (index != 0)
        //   dayWidget(
        //       currentMsgDate: currentMsgDate,
        //       nextMsgDate: nextMsgDate,
        //       isToday: (DateTime.now().day - currentMsgDate.day) == 0,
        //       isYesterday: (DateTime.now().day - currentMsgDate.day) == 1,
        //       differenceOfDays: 1),
      ],
    ) : messageWidget;
  }

  Widget dayWidget(
      {required DateTime currentMsgDate,
      required DateTime nextMsgDate,
      required bool isToday,
      required bool isYesterday,
      required int differenceOfDays}) {
    if (differenceOfDays >= 1) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: appColors.guideColor),
          child: Text(
            isToday
                ? 'Today'
                : isYesterday
                    ? 'Yesterday'
                    : '${DateFormat('EEEE ,dd MMMM').format(nextMsgDate)}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.textColor.withOpacity(0.4),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          // border: Border.all(color: appColors.guidedColorOnChatPage),
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
    );
  }

  Widget giftMsgView(BuildContext context, ChatMessage chatMessage,
      bool yourMessage, String customerName) {
    return Align(
      alignment: yourMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
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
              '$customerName has requested to send ${chatMessage.message ?? ""}.',
              maxLines: 2,
            ))
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
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: appColors.textColor.withOpacity(0.4),
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
        // border: Border.all(color: appColors.guidedColorOnChatPage),
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
                        Text(chatMessage.message ?? "",
                            style: AppTextStyle.textStyle14(
                              fontColor: chatMessage.id.toString() ==
                                      AppFirebaseService()
                                          .orderData["astroId"]
                                          .toString()
                                  ? appColors.red
                                  : appColors.black,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: chatMessage.id.toString() ==
                              AppFirebaseService()
                                  .orderData["userId"]
                                  .toString()
                          ? 10
                          : 0,
                    ),
                    Visibility(
                      visible: chatMessage.id.toString() ==
                          AppFirebaseService().orderData["userId"].toString(),
                      child: CustomButton(
                          color: appColors.guideColor,
                          onTap: () {
                            print(AppFirebaseService()
                                .orderData["lat"]);
                            print("objectobjectobjectobjectobject");
                            final dateData = DateFormat("dd/MM/yyyy")
                                .parse(AppFirebaseService().orderData["dob"]);
                            DateTime timeData = DateFormat("h:mm a").parse(
                                AppFirebaseService().orderData["timeOfBirth"]);
                            Params params = Params(
                              name: AppFirebaseService()
                                  .orderData["customerName"],
                              day: dateData.day,
                              year: dateData.year,
                              month: dateData.month,
                              hour: timeData.hour,
                              min: timeData.minute,
                              lat: double.parse(AppFirebaseService()
                                  .orderData["lat"].toString()),
                              long: double.parse(AppFirebaseService()
                                  .orderData["lng"]),
                              location: AppFirebaseService()
                                  .orderData["placeOfBirth"],
                            );
                            Get.toNamed(RouteName.kundliDetail, arguments: {
                              "kundli_id": 0,
                              "from_kundli": false,
                              "params": params,
                              "gender":
                                  AppFirebaseService().orderData["gender"],
                            });
                          },
                          child: Text(
                            "View Kundli",
                            style: TextStyle(color: appColors.guideTextColor),
                          )),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(chatMessage.time != null
                            ? int.parse(chatMessage.time.toString())
                            : 0),
                        style: AppTextStyle.textStyle10(
                          fontColor: appColors.darkBlue,
                        ),
                      ),
                      if (yourMessage) SizedBox(width: 8.w),
                      if (yourMessage)
                        Obx(() => (msgType.value == 0 || msgType.value == 0) &&
                                chatMessage.seenStatus == 0
                            ? Assets.images.icSingleTick.svg()
                            : (msgType.value == 1 || msgType.value == 0) &&
                                    chatMessage.seenStatus == 1
                                ? Assets.images.icDoubleTick.svg(
                                    colorFilter: ColorFilter.mode(
                                        appColors.greyColor, BlendMode.srcIn))
                                : (msgType.value == 3 || msgType.value == 0) &&
                                        chatMessage.seenStatus == 3
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
    return GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
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
                  AbsorbPointer(
                    absorbing: controller.isAudioPlaying.value,
                    child: VoiceMessageView(
                        controller: VoiceController(
                            audioSrc: chatDetail.awsUrl ?? chatDetail.message ?? "",
                            maxDuration: const Duration(minutes: 30),
                            isFile: false,
                            onComplete: () {
                              controller.isAudioPlaying(false);
                            },
                            onPause: () {
                              controller.isAudioPlaying(false);
                            },
                            onPlaying: () {
                              print(
                                  "value of audio playing ${controller.isAudioPlaying.value}");
                              if (controller.isAudioPlaying.value) {
                                Fluttertoast.showToast(
                                    msg: "Audio is Already playing");
                              } else {
                                controller.isAudioPlaying(true);
                              }
                            }),
                        innerPadding: 0,
                        cornerRadius: 20),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Text(
                          messageDateTime(chatDetail.time != null
                              ? int.parse(chatDetail.time!)
                              : 0),
                          style: AppTextStyle.textStyle10(
                              fontColor: appColors.black),
                        ),
                        if (yourMessage) SizedBox(width: 8.w),
                        if (yourMessage)
                         Obx(() =>  msgType.value == 0
                             ? Assets.images.icSingleTick.svg()
                             : msgType.value == 1
                             ? Assets.images.icDoubleTick.svg(
                             colorFilter: ColorFilter.mode(
                                 appColors.lightGrey, BlendMode.srcIn))
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
    });
  }

  Widget giftSendUi(BuildContext context, ChatMessage chatMessage,
      bool yourMessage, String customerName) {
    print("giftsend called");
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
                "$customerName have sent ${chatMessage.message!.contains("https") ? "" : chatMessage.message ?? ""}",
                // "$customerName have sent ${chatMessage.message ?? ""}",
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

  /*Widget imageMsgView(String image, bool yourMessage,
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
                                  messageDateTime(int.parse(chatDetail.time.toString())),
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
                  : chatDetail.downloadedPath == "" && chatDetail.downloadedPath == null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: SizedBox(
                                    height: 200.h,
                                    width: 150.w,
                                    child: LoadImage(
                                      boxFit: BoxFit.cover,
                                      imageModel: ImageModel(
                                          assetImage: false,
                                          placeHolderPath:
                                              Assets.images.defaultProfile.path,
                                          imagePath: chatDetail.awsUrl ?? chatDetail.message!,
                                          loadingIndicator: SizedBox(
                                              child: CircularProgressIndicator(
                                                  color: appColors.guideColor,
                                                  strokeWidth: 2))),
                                    ),
                                  )),
                            ),
                            if (chatDetail.awsUrl != null)
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
                                      messageDateTime(int.parse(chatDetail.time.toString())),
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
                                arguments: chatDetail.awsUrl);
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
  }*/

  Widget imageMsgView(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    // Uint8List bytesImage = base64.decode(image);
    Rx<int> msgType = (chatDetail.seenStatus ?? (chatDetail.type ?? 0)).obs;
    print(
        "chatDetail.type ${msgType.value} - ${chatDetail.type} - ${chatDetail.seenStatus} - ${yourMessage}");

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
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            constraints: BoxConstraints(
              maxWidth: ScreenUtil().screenWidth * 0.7,
              minWidth: ScreenUtil().screenWidth * 0.27,
            ),
            child: yourMessage
                ? chatDetail.downloadedPath == null
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.imagePreviewUi,
                              arguments: chatDetail.message);
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                            ),
                            constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.7,
                                minWidth: ScreenUtil().screenWidth * 0.27),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0.sp),
                                  child: CachedNetworkImage(
                                    imageUrl: chatDetail.message ?? '',
                                    fit: BoxFit.cover,
                                    height: 200.h,
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
                                              bottomRight:
                                                  Radius.circular(10.r)),
                                          gradient: LinearGradient(
                                            colors: [
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.0),
                                              appColors.darkBlue
                                                  .withOpacity(0.5),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Text(
                                          messageDateTime(chatDetail.time !=
                                                  null
                                              ? int.parse(chatDetail.time!)
                                              : 0),
                                          style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteName.imagePreviewUi,
                                  arguments: chatMessage.message != null
                                      ? "${chatMessage.message}"
                                      : "${chatMessage.awsUrl}");
                            },
                            child: Image.network(
                              chatMessage.message != null
                                  ? "${chatMessage.message}"
                                  : "${chatMessage.awsUrl}",
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
                                  bottomRight: Radius.circular(10.r),
                                ),
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
                                    messageDateTime(chatDetail.time != null
                                        ? int.parse(chatDetail.time!)
                                        : 0),
                                    style: AppTextStyle.textStyle10(
                                      fontColor: appColors.white,
                                    ),
                                  ),
                                  if (yourMessage) SizedBox(width: 8.w),
                                  if (yourMessage)
                                    msgType.value == 0
                                        ? Assets.images.icSingleTick.svg()
                                        : msgType.value == 1
                                            ? Assets.images.icDoubleTick.svg(
                                                colorFilter: ColorFilter.mode(
                                                  appColors.greyColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : msgType.value == 3
                                                ? Assets.images.icDoubleTick
                                                    .svg()
                                                : Assets.images.icSingleTick
                                                    .svg(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                : chatDetail.downloadedPath == "" ||
                        chatDetail.downloadedPath == null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0.sp),
                            child: ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Image.network(
                                "${chatDetail.message}",
                                fit: BoxFit.cover,
                                height: 200.h,
                              ),
                            ),
                          ),
                          if (chatDetail.message != null)
                            InkWell(
                              onTap: () {
                                chatController.downloadImage(
                                  fileName: image,
                                  chatDetail: chatDetail,
                                  index: index,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.darkBlue.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.download_rounded,
                                  color: appColors.white,
                                ),
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
                                    horizontal: 6,
                                  ).copyWith(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.r),
                                    ),
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
                                    messageDateTime(chatDetail.time != null
                                        ? int.parse(chatDetail.time!)
                                        : 0),
                                    style: AppTextStyle.textStyle10(
                                      fontColor: appColors.white,
                                    ),
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
                              arguments: chatDetail.message != null
                                  ? "${chatDetail.message}"
                                  : "${pref.getAmazonUrl()}${chatDetail.awsUrl}");
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0.r),
                              child: chatDetail.message != null
                                  ? Image.network(
                                      "${chatDetail.message}",
                                      fit: BoxFit.cover,
                                      height: 200.h,
                                    )
                                  : Image.file(
                                      File(chatDetail.downloadedPath ?? ""),
                                      fit: BoxFit.cover,
                                      height: 200.h,
                                    ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget kundliView({required ChatMessage chatDetail, required int index}) {
    String getKundliDateTime(ChatMessage chatDetail) {
      if (chatDetail.kundliDateTime != null) {
        return chatDetail.kundliDateTime!;
      } else if (chatDetail.kundli != null &&
          chatDetail.kundli!.kundliDateTime != null) {
        return DateFormat('dd MMM yy, hh:mm a')
            .format(chatDetail.kundli!.kundliDateTime!);
      } else {
        return "";
      }
    }

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
                    chatDetail.kundliName?[0] ??
                        chatDetail.kundli?.kundliName[0] ??
                        '',
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
                      chatDetail.kundliName ??
                          chatDetail.kundli?.kundliName ??
                          "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      getKundliDateTime(chatDetail),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        //color: appColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliPlace ??
                          chatDetail.kundli?.kundliPlace ??
                          "",
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

  Widget CustomProductView(
      {required ChatMessage chatDetail, required int index, String? baseUrl}) {
    print(chatDetail.id);
    print("chatDetail.id");
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
              imagePath: "${chatDetail.awsUrl}",
              radius: const BorderRadius.vertical(top: Radius.circular(10)),
              placeHolder: "assets/images/default_profiles.svg",
              fit: BoxFit.cover,
            ),
            Text(
              chatDetail.message ?? "",
              maxLines: 1,
              style: AppTextStyle.textStyle12(
                fontColor: appColors.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "₹${chatDetail.productPrice ?? '${chatDetail.getCustomProduct != null ? chatDetail.getCustomProduct["amount"] : "0"}'}",
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
