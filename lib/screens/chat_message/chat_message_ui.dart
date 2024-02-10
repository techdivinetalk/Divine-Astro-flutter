import 'dart:ui';


import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/app_textstyle.dart';
import '../../gen/assets.gen.dart';
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
        backgroundColor: appColors.yellow,
        centerTitle: false,
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
                        loadingIndicator:  SizedBox(
                            child: CircularProgressIndicator(
                                color: appColors.yellow, strokeWidth: 2))),
                  )),
            ),
            SizedBox(width: 10.w),
            Text(controller.args!.name ?? '',
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: appColors.brown))
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
                    () => ListView.builder(
                      itemCount: controller.chatMessageList.length,
                      controller: controller.messageScrollController,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = controller.chatMessageList[index];
                        return SizedBox(
                          width: double.maxFinite,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 4.h),
                            child: Column(
                              crossAxisAlignment: (data.msgType ?? 0) == 1
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 3.0,
                                          offset: const Offset(0.0, 3.0)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().screenWidth * 0.7,
                                      minWidth:
                                          ScreenUtil().screenWidth * 0.27),
                                  child: Stack(
                                    alignment: (data.msgType ?? 0) == 1
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    children: [
                                      Column(
                                        children: [
                                          Wrap(
                                              alignment: data.msgType == 1
                                                  ? WrapAlignment.end
                                                  : WrapAlignment.start,
                                              children: [
                                                Text(data.message ?? "",
                                                    style: AppTextStyle.textStyle14(
                                                        fontColor:
                                                            (data.msgType ??
                                                                        0) ==
                                                                    1
                                                                ? appColors
                                                                    .darkBlue
                                                                : appColors
                                                                    .darkBlue))
                                              ]),
                                          SizedBox(height: 20.h)
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Row(
                                          children: [
                                            Text(
                                                DateFormat.jm().format(
                                                    DateTime.parse(
                                                        data.createdAt ?? '')),
                                                style: AppTextStyle.textStyle10(
                                                    fontColor:
                                                        appColors.darkBlue)),
                                            if (data.msgType == 1)
                                              (data.seenStatus ?? 0) == 0
                                                  ? SizedBox(width: 8.w)
                                                  : (data.seenStatus ?? 0) == 1
                                                      ? Assets
                                                          .images.icSingleTick
                                                          .svg()
                                                      : (data.seenStatus ??
                                                                  0) ==
                                                              2
                                                          ? Assets.images
                                                              .icDoubleTick
                                                              .svg()
                                                          : const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              chatBottomBar(),
              // Obx(() => Offstage(
              //       offstage: controller.emojiShowing.value,
              //       child: SizedBox(
              //         height: 300,
              //         child: EmojiPicker(
              //             // onEmojiSelected: (Category? category, Emoji emoji) {
              //             //   _onEmojiSelected(emoji);
              //             // },
              //             onBackspacePressed: () {
              //               _onBackspacePressed();
              //             },
              //             textEditingController: controller.messageController,
              //             config: const Config(
              //                 columns: 7,
              //                 emojiSizeMax: 32.0,
              //                 verticalSpacing: 0,
              //                 horizontalSpacing: 0,
              //                 initCategory: Category.RECENT,
              //                 bgColor: Color(0xFFF2F2F2),
              //                 indicatorColor: appColors.red,
              //                 iconColor: Colors.grey,
              //                 iconColorSelected: appColors.red,
              //                 enableSkinTones: true,
              //                 recentTabBehavior: RecentTabBehavior.RECENT,
              //                 recentsLimit: 28,
              //                 replaceEmojiOnLimitExceed: false,
              //                 backspaceColor: appColors.red,
              //                 categoryIcons: CategoryIcons(),
              //                 buttonMode: ButtonMode.MATERIAL)),
              //       ),
              //     )
              // ),
            ],
          ),
          // Positioned(
          //   bottom: 90.h,
          //   right: 25.w,
          //   child: Obx(() => controller.scrollToBottom.value
          //       ? InkWell(
          //           onTap: () {
          //             controller.messageScrollController.animateTo(
          //                 controller.messageScrollController.position.maxScrollExtent,
          //                 duration: const Duration(milliseconds: 20),
          //                 curve: Curves.easeOut);
          //             controller.updateReadMessageStatus();
          //           },
          //           child: badges.Badge(
          //             showBadge: controller.unreadMsgCount.value > 0,
          //             badgeStyle: const badges.BadgeStyle(
          //               badgeColor: appColors.appColorDark,
          //             ),
          //             badgeContent: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text("${controller.unreadMsgCount.value}"),
          //             ),
          //             child: Icon(Icons.arrow_drop_down_circle_outlined,
          //                 color: appColors.appColorDark, size: 50.h),
          //           ),
          //         )
          //       : const SizedBox()),
          // ),
        ],
      ),
    );
  }

  Widget chatBottomBar() {
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
                        // prefixIcon: InkWell(
                        //   onTap: () async {
                        //     controller.isEmojiShowing.value =
                        //         !controller.isEmojiShowing.value;
                        //     FocusManager.instance.primaryFocus?.unfocus();
                        //   },
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(6.w, 5.h, 6.w, 8.h),
                        //     child: Assets.images.icEmojiShare.image(),
                        //   ),
                        // ),
                        // suffixIcon: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         // controller.getKundliList();
                        //       },
                        //       child: Padding(
                        //         padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                        //         child: Assets.images.icKundliShare.image(),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         // controller.getImage(false);
                        //       },
                        //       child: Padding(
                        //         padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                        //         child: Assets.images.icAttechment.svg(),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide:  BorderSide(
                                color: appColors.white, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide:  BorderSide(
                                color: appColors.appColorLite, width: 1.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                InkWell(
                  onTap: () {
                    controller.sendMsg();
                  },
                  child: Assets.images.icSendMsg.svg(height: 48.h),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

// Widget textMsgView(BuildContext context, ChatMessage chatMessage, bool yourMessage) {
//   RxInt msgType = (chatMessage.type ?? 0).obs;
//   return SizedBox(
//     width: double.maxFinite,
//     child: Column(
//       crossAxisAlignment: yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.2), blurRadius: 3.0, offset: const Offset(0.0, 3.0)),
//             ],
//             color: Colors.white,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//           constraints: BoxConstraints(
//               maxWidth: ScreenUtil().screenWidth * 0.7, minWidth: ScreenUtil().screenWidth * 0.25),
//           child: Stack(
//             alignment: yourMessage ? Alignment.centerRight : Alignment.centerLeft,
//             children: [
//               Column(
//                 children: [
//                   Wrap(
//                     alignment: WrapAlignment.end,
//                     children: [
//                       Text(
//                         chatMessage.message ?? "",
//                         style: AppTextStyle.textStyle14(
//                             fontColor: yourMessage ? appColors.darkBlue : appColors.red),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h)
//                 ],
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Row(
//                   children: [
//                     Text(
//                       messageDateTime(chatMessage.time ?? 0),
//                       style: AppTextStyle.textStyle10(
//                         fontColor: appColors.darkBlue,
//                       ),
//                     ),
//                     if (yourMessage) SizedBox(width: 8.w),
//                     if (yourMessage)
//                       Obx(() => msgType.value == 0
//                           ? Assets.images.icSingleTick.svg()
//                           : msgType.value == 1
//                               ? Assets.images.icDoubleTick.svg(color: appColors.disabledGrey)
//                               : msgType.value == 2
//                                   ? Assets.images.icDoubleTick.svg()
//                                   : Assets.images.icSingleTick.svg())
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }
//
// Widget imageMsgView(String image, bool yourMessage, {required ChatMessage chatDetail, required int index}) {
//   Uint8List bytesImage = const Base64Decoder().convert(image);
//   int msgType = chatDetail.type ?? 0;
//   return SizedBox(
//     width: double.maxFinite,
//     child: Column(
//       crossAxisAlignment: yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8.0),
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.2), blurRadius: 3.0, offset: const Offset(0.0, 3.0)),
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(8.r)),
//           ),
//           constraints: BoxConstraints(
//               maxWidth: ScreenUtil().screenWidth * 0.7, minWidth: ScreenUtil().screenWidth * 0.25),
//           child: chatDetail.downloadedPath != ""
//               ? InkWell(
//                   onTap: () {
//                     Get.toNamed(RouteName.imagePreviewUi, arguments: chatDetail.downloadedPath);
//                   },
//                   child: Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0.r),
//                         child: Image.file(
//                           File(chatDetail.downloadedPath ?? ''),
//                           fit: BoxFit.cover,
//                           height: 200.h,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 4,
//                         right: 10,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               messageDateTime(chatDetail.time ?? 0),
//                               style: AppTextStyle.textStyle10(
//                                 fontColor: appColors.darkBlue,
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             if (yourMessage)
//                               msgType == 0
//                                   ? Assets.images.icSingleTick.svg()
//                                   : msgType == 1
//                                       ? Assets.images.icDoubleTick.svg(color: appColors.disabledGrey)
//                                       : msgType == 2
//                                           ? Assets.images.icDoubleTick.svg()
//                                           : Assets.images.icSingleTick.svg()
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0.sp),
//                       child: ImageFiltered(
//                         imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                         child: Image.memory(
//                           bytesImage,
//                           fit: BoxFit.cover,
//                           height: 200.h,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         // controller.downloadImage(
//                         //     fileName: image,
//                         //     chatDetail: chatDetail,
//                         //     index: index);
//                       },
//                       child: const Icon(Icons.download),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             messageDateTime(chatDetail.time ?? 0),
//                             style: AppTextStyle.textStyle10(
//                               fontColor: appColors.darkBlue,
//                             ),
//                           ),
//                           SizedBox(width: 8.w),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//         )
//       ],
//     ),
//   );
// }
//
// Widget kundliView({required ChatMessage chatDetail, required int index}) {
//   return GestureDetector(
//     onTap: () {
//       Get.toNamed(RouteName.kundliDetailPage,
//           arguments: {"kundli_id": chatDetail.kundliId, 'from_kundli': true});
//       // Get.toNamed(RouteName.kundliDetailPage);
//       log("Kundli_Detail==> ${chatDetail.kundliId}");
//     },
//     child: Card(
//       child: Container(
//         padding: EdgeInsets.all(12.h),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: const BoxDecoration(shape: BoxShape.circle, color: appColors.buttonDisableColor),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Text(
//                   chatDetail.kundliName?[0] ?? "",
//                   style: AppTextStyle.textStyle24(fontColor: appColors.white, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             SizedBox(width: 15.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chatDetail.kundliName ?? "",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.sp,
//                       color: appColors.darkBlue,
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Text(
//                     chatDetail.kundliDateTime ?? "",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 10.sp,
//                       color: appColors.disabledGrey,
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Text(
//                     chatDetail.kundliPlace ?? "",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 10.sp,
//                       color: appColors.disabledGrey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(top: 15),
//               child: Icon(
//                 Icons.keyboard_arrow_right,
//                 size: 35,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget unreadMessageView() {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 10.0),
//     child: Container(
//       padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 1.0, offset: const Offset(0.0, 3.0)),
//         ],
//         color: appColors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//       ),
//       child: Text("unreadMessages".tr),
//     ),
//   );
// }
//
// _onBackspacePressed() {
//   controller.messageController
//     ..text = controller.messageController.text.characters.toString()
//     ..selection =
//         TextSelection.fromPosition(TextPosition(offset: controller.messageController.text.length));
// }
}
