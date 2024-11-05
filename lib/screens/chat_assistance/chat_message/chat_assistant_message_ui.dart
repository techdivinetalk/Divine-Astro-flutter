import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/helper_widgets.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/common_functions.dart';
import '../../../common/routes.dart';
import '../../../firebase_service/firebase_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../model/chat_offline_model.dart';
import '../../../model/message_template_response.dart';
import '../../live_page/constant.dart';
import 'chat_assistant_message_controller.dart';
import 'widgets/assist_message_widget.dart';

class ChatMessageSupportUI extends StatefulWidget {
  const ChatMessageSupportUI({super.key});

  @override
  State<ChatMessageSupportUI> createState() => _ChatMessageSupportUIState();
}

class _ChatMessageSupportUIState extends State<ChatMessageSupportUI> {
  ChatMessageController controller = Get.find();

  Timer? timer;

  updateFirebaseToken() async {
    String? newtoken = await FirebaseMessaging.instance.getToken();
    final data = await AppFirebaseService()
        .database
        .child(
            "astrologer/${preferenceService.getUserDetail()?.id}/deviceToken")
        .once();
    final currentToken = data.snapshot.value;
    if (newtoken.toString() != currentToken.toString()) {
      print("token updated from ${currentToken} to ${newtoken}");
      await AppFirebaseService()
          .database
          .child("astrologer/${preferenceService.getUserDetail()?.id}/")
          .update({'deviceToken': newtoken});
    }
  }

  @override
  void initState() {
    super.initState();
    noticeAPi();
    controller.listenSocket();

    if (Get.arguments != null) {
      controller.args = Get.arguments;

      controller.update();
      chatAssistantCurrentUserId(controller.args?.id);
      updateFirebaseToken();
      controller.socketReconnect();
      controller.getAssistantChatList();
      controller.listenUserEnterChatSocket();
      controller.userEnterChatSocket();
      // controller.userjoinedChatSocket();
      // controller.listenjoinedChatSocket();
      // controller.userleftChatSocketListen();

      controller.getMessageTemplateForChatAssist();
      // controller.getMessageTemplatesLocally();
      // controller.scrollToBottomFunc();
      timer = Timer.periodic(const Duration(minutes: 5), (timer) {
        controller.socketReconnect();
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) {
        AppFirebaseService()
            .database
            .child("astrologer/${preferenceService.getUserDetail()?.id}/")
            .update({'deviceToken': newtoken});
      });

      assistChatNewMsg.listen((newChatList) {
        if (newChatList.isNotEmpty) {
          print("ˇˇ ${newChatList.length} ");
          controller.messageScrollController.position.animateTo(
              controller.messageScrollController.position.maxScrollExtent + 80,
              duration: Duration(seconds: 1),
              curve: Curves.ease);
          for (int index = 0; index < newChatList.length; index++) {
            print("new chat list ${jsonEncode(newChatList[index])} ");
            var responseMsg = newChatList[index];
            if (int.parse(responseMsg?["sender_id"].toString() ?? '') ==
                controller.args?.id) {
              controller.chatMessageList([
                ...controller.chatMessageList,
                AssistChatData(
                    isPoojaProduct:
                        responseMsg['message'] == "1" ? true : false,
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
                    id: int.parse(responseMsg?["chatId"].toString() ?? ''),
                    isSuspicious: 0,
                    suggestedRemediesId:
                        int.parse(responseMsg['suggestedRemediesId'] ?? '0'),
                    productId: responseMsg['productId'].toString(),
                    sendBy: SendBy.customer,
                    msgType: responseMsg["msg_type"] != null
                        ? msgTypeValues.map[responseMsg["msg_type"]]
                        : MsgType.text,
                    seenStatus: SeenStatus.received,
                    customerId: int.parse(responseMsg['sender_id'] ?? 0))
              ]);
              controller.chatMessageList.refresh();
              // controller.scrollToBottomFunc();
              assistChatNewMsg.removeAt(index);
              controller.update();
              print(
                  "outside chat add condition ${json.encode(controller.chatMessageList.last)}");
            }
          }
          controller.update();
        }
        // controller.scrollToBottomFunc();

        controller.reArrangeChatList();
      });

      controller.update();

      //to check if the list has enough number of elements to scroll
      // messageScrollController.hasClients ? null : getAssistantChatList();
      //
      // controller.keyboardVisibilityController.onChange.listen(
      //       (bool visible) {
      //     if (visible == false) {
      //     } else {}
      //   },
      // );
      if (mounted && controller.messageScrollController.hasClients) {
        controller.messageScrollController.addListener(() {
          final topPosition =
              controller.messageScrollController.position.minScrollExtent;
          // if (controller.isKeyboardOpen(context)) {
          //   // controller.scrollToBottomFunc();
          // }

          if (controller.messageScrollController.position.pixels ==
              topPosition) {
            //code to fetch old messages
            print("to fetch old messages");
            controller.getAssistantChatList();
          }
        });
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   if (mounted && _scrollController.hasClients) {
        //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        //   }
        // });

        // controller.scrollToBottomFunc();
        controller.messageScrollController.addListener(() {
          final bottomPosition =
              controller.messageScrollController.position.maxScrollExtent;
          if (controller.messageScrollController.position.pixels ==
              bottomPosition) {
            print("to fetch new messages");

            //code to fetch old messages
          }
        });
      }

      // getAssistantChatList();
      // controller.scrollToBottomFunc();
      controller.update();
    }
    // controller.scrollToBottomFunc();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // controller.scrollToBottomFunc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.isCustomerOnline = false.obs;
    controller.chatMessageList.clear();
    controller.processedPages.clear();
    controller.currentPage(1);
    controller.listenUserEnterChatSocket();
    // controller.userleftChatSocket();
    chatAssistantCurrentUserId(0);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "print image:: ${preferenceService.getAmazonUrl()}/${controller.args?.image ?? ''}");
    Get.put(ChatMessageController(KundliRepository(), ChatRepository()));
    if (controller.isKeyboardOpen(context)) {
      controller.scrollToBottomFunc();
    }
    return WillPopScope(
      onWillPop: () async {
        print("datascrollingBack");
        print(controller.isKeyboardOpen(context));
        print("datascrollingBack");
        if (controller.isKeyboardOpen(context)) {
          print("object");

          FocusScope.of(context).unfocus();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.messageScrollController.jumpToBottom();
            if (mounted && controller.messageScrollController.hasClients) {
              controller.messageScrollController.jumpTo(
                  controller.messageScrollController.position.maxScrollExtent);
              controller.update();
            }
          });
        } else {
          Get.delete<ChatMessageController>();
          Get.back();
        }
        controller.update();

        return false;
      },
      child: Scaffold(
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
              color: appColors.whiteGuidedColor,
            ),
          ),
          actions: [
            // show_call_on_assistant.value.toString() == "1"
            //     ?
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.checkingCalling.value == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          print(controller.args!.id);
                          controller.checkCalling();
                        },
                        icon: Icon(
                          Icons.call,
                          color: appColors.white,
                        ),
                      ),
              );
            }),
            // : SizedBox(),
          ],
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
                          imagePath: (controller.args?.image ?? '').startsWith(
                                  'https://divineprod.blob.core.windows.net/divineprod/')
                              ? controller.args?.image ?? ''
                              : "${preferenceService.getAmazonUrl()}/${controller.args?.image ?? ''}",
                          loadingIndicator: SizedBox(
                              child: CircularProgressIndicator(
                                  color: appColors.guideColor,
                                  strokeWidth: 2))),
                    )),
              ),
              SizedBox(width: 10.w),
              Text(controller.args!.name ?? '',
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.whiteGuidedColor))
            ],
          ),
        ),
        body: Stack(
          children: [
            Assets.images.bgChatWallpaper.image(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover),
            Column(
              children: [
                Obx(() {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: controller.loading.value
                          ? msgShimmerList()
                          : controller.chatMessageList.isEmpty
                              ? HelpersWidget().emptyChatWidget()
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 10, // Position at the top
                                      left: 0,
                                      right: 0,
                                      child: SizedBox(
                                        height:
                                            noticeDataChat.isNotEmpty ? 50 : 0,
                                        // Adjust the height as needed
                                        child: noticeDataChat.isNotEmpty
                                            ? CarouselSlider(
                                                options: CarouselOptions(
                                                  height: 200,
                                                  autoPlay: true,
                                                  aspectRatio: 1,
                                                  viewportFraction: 1,
                                                ),
                                                items: noticeDataChat.map((i) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              appColors.white,
                                                          border: Border.all(
                                                              color:
                                                                  appColors.red,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: HTML.toTextSpan(
                                                              context,
                                                              i.description ??
                                                                  ""),
                                                          maxLines: 2,

                                                          //...
                                                        ),
                                                        /* ExpandableHtml(
                                                            htmlData: '${i.description}',
                                                            trimLength: 3000,
                                                          )*/
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    Positioned(
                                      top: noticeDataChat.isNotEmpty ? 70 : 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      // Take remaining space
                                      child: ListView.builder(
                                        itemCount:
                                            controller.chatMessageList.length,
                                        controller:
                                            controller.messageScrollController,
                                        physics: const ScrollPhysics(),
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .manual,
                                        // reverse: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final currentMsg =
                                              controller.chatMessageList[index]
                                                  as AssistChatData;
                                          final nextIndex = controller
                                                          .chatMessageList
                                                          .length -
                                                      1 ==
                                                  index
                                              ? index
                                              : index + 1;
                                          print(
                                              "chat assist msg data:${currentMsg.toJson()}");
                                          print(
                                              "controller.chatMessageList.length ------> ${controller.chatMessageList.length}");
                                          print(
                                              "=== ------> ${controller.chatMessageList[0]}");
                                          print(
                                              "currentMsg type ------> ${currentMsg.msgType}");
                                          return AssistMessageView(
                                            index: index,
                                            chatMessage: currentMsg,
                                            nextMessage: index ==
                                                    controller.chatMessageList
                                                            .length -
                                                        1
                                                ? controller
                                                    .chatMessageList[index]
                                                : controller
                                                    .chatMessageList[index + 1],
                                            yourMessage: currentMsg.sendBy ==
                                                SendBy.astrologer,
                                            unreadMessage: controller
                                                    .unreadMessageList
                                                    .isNotEmpty
                                                ? controller
                                                        .chatMessageList[index]
                                                        .id ==
                                                    controller.unreadMessageList
                                                        .first.id
                                                : false,
                                            baseImageUrl: controller
                                                    .preferenceService
                                                    .getBaseImageURL() ??
                                                '',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  );
                }),
                // Obx(
                //   () => Column(
                //     children: [
                //       messageTemplateRow(),
                //       SizedBox(height: 20.h),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.h),
                chatBottomBar(context),

                // Padding(
                //   padding:
                //   EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h),
                //   child: MaterialButton(
                //       height: 50,
                //       elevation: 0,
                //       minWidth: Get.width,
                //       shape: const RoundedRectangleBorder(
                //         borderRadius:
                //         BorderRadius.all(Radius.circular(25.0)),
                //       ),
                //       onPressed: () {
                //         chatAssistantTemplateSendMessagePopup();
                //       },
                //       color: appColors.guideColor,
                //       child: Text(
                //         "sendMessage".tr,
                //         style: TextStyle(
                //           fontWeight: FontWeight.w600,
                //           fontSize: 20.sp,
                //           color: appColors.white,
                //         ),
                //       )),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  chatAssistantTemplateSendMessagePopup() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      barrierColor: appColors.textColor.withOpacity(0.5),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50.0)),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "selectMessageToSend".tr,
                      style: AppTextStyle.textStyle20(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.textColor,
                      ),
                    ).centered(),
                    SizedBox(height: 20.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            0.8, // Constrain height to 70% of screen height
                      ),
                      child: controller.messageTemplates.isEmpty
                          ? Container(
                              height: 100.h,
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                "noAnyTemplateFound".tr,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appColors.grey,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: controller.messageTemplates.length,
                              itemBuilder: (context, index) {
                                MessageTemplates messageTemplatesModel =
                                    controller.messageTemplates[index];

                                return GestureDetector(
                                  onTap: () {
                                    controller.sendMsgTemplate(
                                        messageTemplatesModel, true);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 13),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${messageTemplatesModel.message}',
                                                textAlign: TextAlign.start,
                                                // maxLines: 3,
                                                maxLines: 1000,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 1.h,
                                        color: appColors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget messageTemplateRow() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        // itemCount: controller.messageTemplates.length + 1,
        itemCount: controller.messageTemplates.length,
        separatorBuilder: (_, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          late final MessageTemplates msg;
          return
              // index == 0 || controller.messageTemplates.isEmpty
              //   ? GestureDetector(
              //       onTap: () async {
              //         await Get.toNamed(RouteName.messageTemplate);
              //         controller.getMessageTemplateForChatAssist();
              //         controller.getMessageTemplatesLocally();
              //         controller.update();
              //       },
              //       child: Container(
              //         padding:
              //             const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //         decoration: BoxDecoration(
              //           color: appColors.red,
              //           borderRadius: const BorderRadius.all(Radius.circular(18)),
              //         ),
              //         child: Text(
              //           '+ Add',
              //           style:
              //               AppTextStyle.textStyle12(fontColor: appColors.white),
              //         ),
              //       ),
              //     )
              //   :
              GestureDetector(
            onTap: () {
              controller.sendMsgTemplate(
                  controller.messageTemplates[/*index - 1*/ index], false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: /*appColors.brownColour*/ appColors.textColor,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
              ),
              child: Text(
                '${controller.messageTemplates[/*index - 1*/ index].message}',
                style: AppTextStyle.textStyle12(fontColor: appColors.white),
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
                            // controller.scrollToBottomFunc();
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
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
                            {'text': controller.messageController.text}, false);
                        controller.messageScrollController.position.animateTo(
                            controller.messageScrollController.position
                                    .maxScrollExtent +
                                80,
                            duration: Duration(seconds: 1),
                            curve: Curves.ease);
                      } /*else {
                        final result = await voucherPopUp(context);
                        if (result != null) {
                          controller.sendMsg(MsgType.voucher, {'data': result});
                        }
                      }*/
                    },
                    child: CircleAvatar(
                      backgroundColor: appColors.guideColor,
                      minRadius: 25,
                      child: /*controller.messageController.text.isEmpty
                          ? Assets.svg.chatGift.svg(height: 50.h)
                          :*/
                          Assets.svg.icSendMsg.svg(height: 50.h),
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
                            RouteName.chatAssistSuggestRemedy,
                            arguments: {
                              "customer_id": controller.args?.id.toString(),
                            });
                        if (result != null) {
                          final String time =
                              "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
                          controller.sendMsg(
                            MsgType.remedies,
                            {'message': result.toString()},
                            false,
                          );
                          // controller.addNewMessage(time, "Remedies",
                          //     messageText: result.toString());
                          print("getting ul not add1");
                        }
                        break;
                      case 3:
                        var result = await Get.toNamed(
                          RouteName.chatAssistProductPage,
                          arguments: {'customerId': controller.args?.id},
                        );
                        controller.sendMsg(
                            MsgType.product, {'data': result}, false);
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

  List<NoticeDatum> noticeDataChat = [];
  final noticeRepository = NoticeRepository();

  noticeAPi() async {
    try {
      final response = await noticeRepository.get(
          ApiProvider.getAstroAllNoticeType4,
          headers: await noticeRepository.getJsonHeaderURL());

      if (response.statusCode == 200) {
        final noticeResponse = noticeResponseFromJson(response.body);
        if (noticeResponse.statusCode == noticeRepository.successResponse &&
            noticeResponse.success!) {
          noticeDataChat = noticeResponse.data;
          print(noticeDataChat.length);
          print("noticeDataChat.length");
        } else {
          throw CustomException(json.decode(response.body));
        }
      } else {
        throw CustomException(json.decode(response.body));
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}

Future<void> showCallingPopup(response, callLoading, callUser) async {
  var size = MediaQuery.of(Get.context!).size;
  return Get.dialog(
    barrierDismissible: true,
    AlertDialog(
      insetPadding: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      elevation: 0,
      scrollable: true,
      contentPadding: EdgeInsets.fromLTRB(10, 12, 10, 10),
      content: SizedBox(
        height: 330,
        width: size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              response.title ?? "",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.poppins,
                color: appColors.red,
              ),
            ),
            // Set a fixed height to avoid layout issues
            Container(
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Html(
                      shrinkWrap: true,
                      data: response.description ?? "",
                    ),
                  ],
                ),
              ),
            ),

            // Flexible(
            //   child: SizedBox(
            //     height: 300, // You can also set this dynamically or adjust it
            //     child: Column(
            //       children: [
            //         Expanded(
            //           child: Html(
            //             shrinkWrap: true,
            //             data: response.description ?? "",
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Obx(() {
              return callLoading.value == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: appColors.red,
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        callUser();
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(Get.context!).size.width,
                        decoration: BoxDecoration(
                          color: appColors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Start Voice Call",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamily.poppins,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    ),
  );
}

Future<void> showCallingError(response, callLoading, callUser) async {
  var size = MediaQuery.of(Get.context!).size;
  return Get.dialog(
    barrierDismissible: true,
    AlertDialog(
      insetPadding: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      elevation: 0,
      scrollable: true,
      contentPadding: EdgeInsets.fromLTRB(10, 12, 10, 10),
      content: SizedBox(
        height: 370,
        width: size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Wait",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.poppins,
                color: appColors.red,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              response!.message! ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.poppins,
                color: appColors.darkBlue,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                  color: appColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Okay",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.poppins,
                      color: appColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
