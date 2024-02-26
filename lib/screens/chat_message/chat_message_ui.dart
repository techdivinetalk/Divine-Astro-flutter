import 'dart:convert';
import 'dart:ui';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/chat_message/widgets/assist_message_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../common/app_textstyle.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/common_functions.dart';
import '../../common/routes.dart';
import '../../firebase_service/firebase_service.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../model/chat_suggest_remedies/chat_suggest_remedies.dart';
import '../../model/message_template_response.dart';
import '../../tarotCard/FlutterCarousel.dart';
import '../../utils/load_image.dart';
import '../live_page/constant.dart';
import 'chat_message_controller.dart';
import 'widgets/voucher_popup.dart';

class ChatMessageSupportUI extends StatefulWidget {
  const ChatMessageSupportUI({super.key});

  @override
  State<ChatMessageSupportUI> createState() => _ChatMessageSupportUIState();
}

class _ChatMessageSupportUIState extends State<ChatMessageSupportUI> {
  ChatMessageController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class ChatMessageSupportUI extends GetView<ChatMessageController> {
//   const ChatMessageSupportUI({super.key});

  updateFirebaseToken() async {
    String? newtoken = await FirebaseMessaging.instance.getToken();
    print("token: new token: " + newtoken.toString());
    final data = await AppFirebaseService()
        .database
        .child("astrologer/${userData?.id}/deviceToken")
        .once();
    final currentToken = data.snapshot.value;
    if (newtoken != currentToken) {
      print("token updated from ${currentToken} to ${newtoken}");
      await AppFirebaseService()
          .database
          .child("astrologer/${userData?.id}/")
          .update({'deviceToken': newtoken});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.listenSocket();
    if (Get.arguments != null) {
      controller.args = Get.arguments;
      controller.update();
      updateFirebaseToken();
      controller.getAssistantChatList();
      controller.userjoinedChatSocket();
      controller.listenjoinedChatSocket();
      controller.getMessageTemplatesLocally();
      controller.scrollToBottomFunc();

      FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) {
        AppFirebaseService()
            .database
            .child("astrologer/${userData?.id}/")
            .update({'deviceToken': newtoken});
      });

      assistChatNewMsg.listen((newChatList) {
        if (newChatList.isNotEmpty) {
          print("new chat list ${newChatList.length} ");
          for (int index = 0; index < newChatList.length; index++) {
            print("new chat list ${jsonEncode(newChatList[index])} ");
            var responseMsg = newChatList[index];
            if (int.parse(responseMsg?["sender_id"].toString() ?? '') ==
                controller.args?.id) {
              print("inside chat add condition");
              controller.chatMessageList([
                ...controller.chatMessageList,
                AssistChatData(
                    isPoojaProduct: responseMsg['message']=="true"?true:false,
                    message: responseMsg['message'],
                    astrologerId:
                        int.parse(responseMsg?["userid"].toString() ?? ''),
                    createdAt: DateTime.parse(responseMsg?["created_at"])
                        .millisecondsSinceEpoch
                        .toString(),
                    // id: responseMsg["chatId"] != null &&
                    //         responseMsg["chatId"] != ''&& responseMsg["chatId"]=='undefined'
                    //     ? int.parse(responseMsg["chatId"])
                    //     : null,
                    isSuspicious: 0,

                    productId: responseMsg['productId'].toString(),
                    sendBy: SendBy.customer,
                    msgType: responseMsg["msg_type"] != null
                        ? msgTypeValues.map[responseMsg["msg_type"]]
                        : MsgType.text,
                    seenStatus: SeenStatus.received,
                    customerId: int.parse(responseMsg['sender_id'] ?? 0))
              ]);
              controller.chatMessageList.refresh();
              controller.scrollToBottomFunc();
              assistChatNewMsg.removeAt(index);
              controller.update();
              print(
                  "outside chat add condition ${json.encode(controller.chatMessageList.last)}");
            }
          }
          controller.update();
        }
        controller.scrollToBottomFunc();
        controller.reArrangeChatList();
      });
      controller.update();

      Future.delayed(const Duration(milliseconds: 600)).then((value) {
        controller.scrollToBottomFunc();
      });
      //to check if the list has enough number of elements to scroll
      // messageScrollController.hasClients ? null : getAssistantChatList();
      //

      // controller.keyboardVisibilityController.onChange.listen(
      //       (bool visible) {
      //     if (visible == false) {
      //     } else {}
      //   },
      // );

      controller.messageScrollController.addListener(() {
        final topPosition =
            controller.messageScrollController.position.minScrollExtent;
        if (controller.messageScrollController.position.pixels == topPosition) {
          //code to fetch old messages
          print("to fetch old messages");
          controller.getAssistantChatList();
        }
      });
      controller.scrollToBottomFunc();
      controller.messageScrollController.addListener(() {
        final bottomPosition =
            controller.messageScrollController.position.maxScrollExtent;
        if (controller.messageScrollController.position.pixels ==
            bottomPosition) {
          //code to fetch old messages
        }
      });
      // getAssistantChatList();
      controller.scrollToBottomFunc();
      controller.update();
    }
    controller.scrollToBottomFunc();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller.scrollToBottomFunc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.chatMessageList.clear();
    controller.userjoinedChatSocket();
    controller.listenjoinedChatSocket();
    controller.processedPages.clear();
    controller.currentPage(1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ChatMessageController(KundliRepository(), ChatRepository()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.guideColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.delete<ChatMessageController>();
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: appColors.white,
          ),
        ),
        leadingWidth: 30,
        title: Row(
          children: [
            SizedBox(
              height: 32.r,
              width: 32.r,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: LoadImage(
                    boxFit: BoxFit.fill,
                    imageModel: ImageModel(
                        assetImage: false,
                        placeHolderPath: Assets.images.defaultProfile.path,
                        imagePath:
                            "${preferenceService.getAmazonUrl()}${controller.args?.image ?? ''}",
                        loadingIndicator: SizedBox(
                            child: CircularProgressIndicator(
                                color: appColors.guideColor, strokeWidth: 2))),
                  )),
            ),
            SizedBox(width: 10.w),
            Text(controller.args!.name ?? '',
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: appColors.white))
          ],
        ),
      ),
      body: Stack(
        children: [
          Assets.images.bgChatWallpaper.image(
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification &&
                        notification.metrics.pixels == 0.0 &&
                        notification.metrics.axis == Axis.vertical &&
                        notification.dragDetails != null) {
                      // controller.getAssistantChatList();
                    }
                    return false;
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Obx(
                      () => controller.loading.value
                          ? msgShimmerList()
                          : controller.chatMessageList.isEmpty
                              ? Center(child: Text('start a conversastion'))
                              : ListView.builder(
                                  itemCount: controller.chatMessageList.length,
                                  controller:
                                      controller.messageScrollController,
                                  reverse: false,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  itemBuilder: (context, index) {
                                    final currentMsg =
                                        controller.chatMessageList[index]
                                            as AssistChatData;
                                    final nextIndex =
                                        controller.chatMessageList.length - 1 ==
                                                index
                                            ? index
                                            : index + 1;
                                    print(
                                        "chat assist msg data:${currentMsg.toJson()}");
                                    return AssistMessageView(
                                      index: index,
                                      chatMessage: currentMsg,
                                      nextMessage: index ==
                                              controller
                                                      .chatMessageList.length -
                                                  1
                                          ? controller.chatMessageList[index]
                                          : controller
                                              .chatMessageList[index + 1],
                                      yourMessage: currentMsg.sendBy ==
                                          SendBy.astrologer,
                                      unreadMessage: controller
                                              .unreadMessageList.isNotEmpty
                                          ? controller
                                                  .chatMessageList[index].id ==
                                              controller
                                                  .unreadMessageList.first.id
                                          : false,
                                      baseImageUrl: controller.preference
                                              .getBaseImageURL() ??
                                          '',
                                    );
                                  },
                                ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Column(
                  children: [
                    messageTemplateRow(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              chatBottomBar(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget messageTemplateRow() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.messageTemplates.length + 1,
        separatorBuilder: (_, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          late final MessageTemplates msg;
          return index == 0 || controller.messageTemplates.isEmpty
              ? GestureDetector(
                  onTap: () async {
                    await Get.toNamed(RouteName.messageTemplate);
                    controller.getMessageTemplatesLocally();
                    controller.update();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: appColors.red,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Text(
                      '+ Add',
                      style:
                          AppTextStyle.textStyle12(fontColor: appColors.white),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    controller.sendMsgTemplate(
                        controller.messageTemplates[index - 1]);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: appColors.brownColour,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Text(
                      '${controller.messageTemplates[index - 1].message}',
                      style:
                          AppTextStyle.textStyle12(fontColor: appColors.white),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget msgShimmerList() {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return Align(
          alignment:
              index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.3),
            highlightColor: Colors.grey,
            child: Container(
              width: index % 4 == 0
                  ? 130
                  : index % 3 == 0
                      ? 200
                      : 150,
              alignment: Alignment.centerRight,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 5),
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
            ),
          ),
        );
      },
    );
  }

  Widget chatBottomBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: GetBuilder<ChatMessageController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                children: [
                  if (controller.isRecording.value == false)
                    Flexible(
                      child: Container(
                        // height: 50.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.3, 3.0)),
                            ]),
                        child: TextFormField(
                          controller: controller.messageController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.newline,
                          maxLines: 1,
                          // focusNode: controller.msgFocus,
                          onChanged: (value) {
                            // controller.isEmojiShowing.value = true;
                            // FocusManager.instance.primaryFocus?.hasFocus ?? false
                            //     ? controller.scrollToBottomFunc()
                            //     : null;
                            controller.update();
                            controller.scrollToBottomFunc();
                          },
                          decoration: InputDecoration(
                            hintText: "message".tr,
                            isDense: true,
                            helperStyle: AppTextStyle.textStyle16(),
                            fillColor: appColors.white,
                            hintStyle: AppTextStyle.textStyle16(
                                fontColor: appColors.grey),
                            hoverColor: appColors.white,
                            filled: true,
                            suffixIcon: InkWell(
                              onTap: () async {
                                showCurvedBottomSheet(context);

                                // Move focus to an invisible focus node to dismiss the keyboard
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // if (controller.isOngoingChat.value) {

                                //   } else {
                                //     divineSnackBar(
                                //         data: "${'chatEnded'.tr}.", color: appColors.appYellowColour);
                                //   }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                                child: Assets.images.icAttechment.svg(),
                              ),
                            ),
                            constraints: BoxConstraints(maxHeight: 50.h),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0.sp),
                                borderSide: BorderSide(
                                    color: appColors.white, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0.sp),
                                borderSide: BorderSide(
                                    color: appColors.guideColor, width: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 15.w),

                  GestureDetector(
                    onTap: () async {
                      if (controller.messageController.text.isNotEmpty) {
                        controller.sendMsg(MsgType.text,
                            {'text': controller.messageController.text});
                      } else {
                        final result = await voucherPopUp(context);
                        if (result != null) {
                          controller.sendMsg(MsgType.voucher, {'data': result});
                        }
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: appColors.guideColor,
                      minRadius: 25,
                      child: controller.messageController.text.isEmpty
                          ? Assets.svg.chatGift.svg(height: 50.h)
                          : Assets.svg.icSendMsg.svg(height: 50.h),
                    ),
                  ),
                  // if (controller.messageController.text.isEmpty) ...[
                  //   SizedBox(width: 15.w),
                  //   Positioned(
                  //     right: 0,
                  //     bottom: 0,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         // Future.delayed(const Duration(milliseconds: 500))
                  //         //     .then((value) => controller.isRecording(false));
                  //       },
                  //       child: SocialMediaRecorder(
                  //         backGroundColor: appColors.guideColor,
                  //         cancelTextBackGroundColor: Colors.white,
                  //         recordIconBackGroundColor: appColors.guideColor,
                  //         radius: BorderRadius.circular(30),
                  //         initRecordPackageWidth:
                  //             kToolbarHeight - Get.width * 0.010,
                  //         recordIconWhenLockBackGroundColor:
                  //             appColors.guideColor,
                  //         maxRecordTimeInSecond: 30,
                  //         startRecording: () {
                  //           print("true record called");
                  //           controller.isRecording(true);
                  //           controller.update();
                  //         },
                  //         stopRecording: (time) {
                  //           print("false record called");
                  //           controller.isRecording(false);
                  //           controller.update();
                  //         },
                  //         sendRequestFunction: (soundFile, time) {
                  //           controller.isRecording(false);
                  //           debugPrint("soundFile ${soundFile.path}");
                  //           controller.uploadAudioFile(soundFile);
                  //         },
                  //         encode: AudioEncoderType.AAC,
                  //       ),
                  //     ),
                  //   )
                  // ]
                ],
              ),
            ),
            SizedBox(height: 20.h)
          ],
        );
      }),
    );
  }

  void showCurvedBottomSheet(context) {
    List<SvgPicture> itemList = [
      SvgPicture.asset('assets/svg/camera_icon.svg'),
      SvgPicture.asset('assets/svg/gallery_icon.svg'),
      SvgPicture.asset('assets/svg/remedies_icon.svg'),
      SvgPicture.asset('assets/svg/product.svg'),
      // SvgPicture.asset('assets/svg/deck_icon.svg'),
      // Add more items as needed
    ];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.sp),
                topRight: Radius.circular(30.sp),
              ),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(itemList.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    switch (index) {
                      case 0:
                        controller.getImage(true);
                        break;
                      case 1:
                        controller.getImage(false);
                        break;
                      case 2:
                        var result = await Get.toNamed(
                            RouteName.chatAssistSuggestRemedy);
                        if (result != null) {
                          final String time =
                              "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
                          controller.sendMsg(
                              MsgType.remedies, {'message': result.toString()});
                          // controller.addNewMessage(time, "Remedies",
                          //     messageText: result.toString());
                          print("getting ul not add1");
                        }
                        break;
                      case 3:
                        var result = await Get.toNamed(
                            RouteName.chatAssistProductPage,
                            arguments: {'customerId': controller.args?.id});
                        controller.sendMsg(MsgType.product, {'data': result});
                        break;
                      case 4:
                        controller.getImage(false);
                        break;
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      itemList[index],
                      // Replace with your asset images
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
