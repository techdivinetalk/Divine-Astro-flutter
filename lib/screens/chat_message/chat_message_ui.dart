import 'dart:ui';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/chat_message/widgets/assist_message_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_textstyle.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../tarotCard/FlutterCarousel.dart';
import '../../utils/load_image.dart';
import '../live_page/constant.dart';
import 'chat_message_controller.dart';

class ChatMessageSupportUI extends GetView<ChatMessageController> {
  const ChatMessageSupportUI({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatMessageController(KundliRepository(), ChatRepository()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.guideColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
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
                            "${globalConstantModel.data?.awsCredentails.baseurl}/${controller.args!.name ?? ''}",
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
                  child: Obx(
                    () => controller.loading.value
                        ? msgShimmerList()
                        : controller.chatMessageList.isEmpty? Text('start a conversastion'):ListView.builder(
                            itemCount: controller.chatMessageList.length,
                            controller: controller.messageScrollController,
                            reverse: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final currentMsg = controller
                                  .chatMessageList[index] as AssistChatData;
                              final nextIndex =
                                  controller.chatMessageList.length - 1 == index
                                      ? index
                                      : index + 1;
                              print(
                                  'length of chat assist list ${controller.chatMessageList.length}');
                              print(
                                  "chat assist msg data:${currentMsg.toJson()}");
                              return AssistMessageView(
                                index: index,
                                chatMessage: currentMsg,
                                nextMessage:
                                    controller.chatMessageList[nextIndex],
                                yourMessage:
                                    currentMsg.sendBy == SendBy.astrologer,
                                unreadMessage: controller
                                        .unreadMessageList.isNotEmpty
                                    ? controller.chatMessageList[index].id ==
                                        controller.unreadMessageList.first.id
                                    : false,
                              );
                            },
                          ),
                  ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Row(
              children: [
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
                        FocusManager.instance.primaryFocus?.hasFocus ?? false
                            ? controller.scrollToBottomFunc()
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "message".tr,
                        isDense: true,
                        helperStyle: AppTextStyle.textStyle16(),
                        fillColor: appColors.white,
                        hintStyle:
                            AppTextStyle.textStyle16(fontColor: appColors.grey),
                        hoverColor: appColors.white,
                        filled: true,
                        suffixIcon: InkWell(
                          onTap: () async {
                            showCurvedBottomSheet(context);

                            // Move focus to an invisible focus node to dismiss the keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            // if (controller.isOngoingChat.value) {

                            //   } else {
                            //     divineSnackBar(
                            //         data: "${'chatEnded'.tr}.", color: appColors.appYellowColour);
                            //   }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                            child: Assets.images.icAttechment.svg(),
                          ),
                        ),
                        constraints: BoxConstraints(maxHeight: 50.h),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide:
                                BorderSide(color: appColors.white, width: 1.0)),
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
                  onTap: () {
                    controller.sendMsg(MsgType.text, {});
                  },
                  child: CircleAvatar(
                    backgroundColor: appColors.guideColor,
                    child: SvgPicture.asset(
                      Assets.images.message.path,
                      color: appColors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

  void showCurvedBottomSheet(context) {
    List<SvgPicture> itemList = [
      SvgPicture.asset('assets/svg/camera_icon.svg'),
      SvgPicture.asset('assets/svg/gallery_icon.svg'),
      SvgPicture.asset('assets/svg/remedies_icon.svg'),
      SvgPicture.asset('assets/svg/product.svg'),
      SvgPicture.asset('assets/svg/deck_icon.svg'),
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
                        var result =
                            await Get.toNamed(RouteName.chatSuggestRemedy);
                        if (result != null) {
                          final String time =
                              "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
                          // controller.addNewMessage(time, "Remedies",
                          //     messageText: result.toString());
                          print("getting ul not add1");
                        }
                        break;
                      case 3:
                        var result =
                        await Get.toNamed(RouteName.chatAssistProductPage);
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

  // Widget attachmentWidget() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       // InkWell(
  //       //   onTap: () {
  //       //     // if (controller.loading != Loading.loading) {
  //       //     //   controller.getKundliList();
  //       //     // }
  //       //   },
  //       //   child: Padding(
  //       //     padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
  //       //     child: Assets.images.icKundliShare.image(),
  //       //   ),
  //       // ),
  //       InkWell(
  //         onTap: () async {
  //           if (await PermissionHelper()
  //               .askStoragePermission(Permission.photos)) {
  //             openBottomSheet(Get.context!,
  //                 functionalityWidget: Column(
  //                   children: [
  //                     Text("Choose Options",
  //                         style: TextStyle(
  //                             color: appColors.darkBlue,
  //                             fontFamily: FontFamily.metropolis,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600)),
  //                     Text("Only photos can be shared",
  //                         style: TextStyle(
  //                             color: appColors.disabledGrey,
  //                             fontFamily: FontFamily.metropolis,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w400)),
  //                     SizedBox(height: 20.w),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         InkWell(
  //                           onTap: () {
  //                             Get.back();
  //                             controller.getImage(
  //                                 isCamera: true);
  //                           },
  //                           child: Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(right: 30),
  //                               child: Column(
  //                                 children: [
  //                                   Icon(Icons.camera_alt,
  //                                       color: appColors.disabledGrey,
  //                                       size: 50),
  //                                   Text("Camera",
  //                                       style: TextStyle(
  //                                           color: appColors.darkBlue,
  //                                           fontFamily: FontFamily.metropolis,
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w400)),
  //                                   Text("Capture an image\nfrom your camera",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           color: appColors.disabledGrey,
  //                                           fontFamily: FontFamily.metropolis,
  //                                           fontSize: 10,
  //                                           fontWeight: FontWeight.w400)),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Get.back();
  //                             controller.getImage(
  //                                 isCamera: false);
  //                           },
  //                           child: Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(left: 30),
  //                               child: Column(
  //                                 children: [
  //                                   Icon(Icons.image,
  //                                       color: appColors.disabledGrey,
  //                                       size: 50),
  //                                   Text("Gallery",
  //                                       style: TextStyle(
  //                                           color: appColors.darkBlue,
  //                                           fontFamily: FontFamily.metropolis,
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w400)),
  //                                   Text("Select an image\nfrom your gallery",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           color: appColors.disabledGrey,
  //                                           fontFamily: FontFamily.metropolis,
  //                                           fontSize: 10,
  //                                           fontWeight: FontWeight.w400)),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     )
  //                   ],
  //                 ));
  //           }
  //         },
  //         child: Padding(
  //           padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
  //           child: Assets.images.icAttechment.svg(),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
