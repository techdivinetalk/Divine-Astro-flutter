import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/message_view.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_ui.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/zego_call/zego_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_bottomsheet.dart';
import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../gen/assets.gen.dart';

class ChatBottomBarWidget extends StatefulWidget {
  final NewChatController? controller;

  const ChatBottomBarWidget({this.controller});

  @override
  State<ChatBottomBarWidget> createState() => _ChatBottomBarWidgetState();
}

class _ChatBottomBarWidgetState extends State<ChatBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.controller!.isRecording.value ? 0 : 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => widget.controller?.isReplay.value == true ? buildReplayMsgWidget() : const SizedBox()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: widget.controller!.isRecording.value
                        ? AudioWaveforms(
                            enableGesture: true,
                            size: Size(
                                MediaQuery.of(Get.context!).size.width, 36),
                            recorderController:
                                widget.controller!.recorderController!,
                            waveStyle: WaveStyle(
                              waveColor: appColors.guideColor,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF3F3F3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.only(left: 15),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 44,
                            child: TextFormField(
                              controller:
                                  widget.controller?.messageController,
                              keyboardType: TextInputType.text,

                              minLines: 1,

                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: FontFamily.metropolis,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: () {
                                if (widget.controller!.isEmojiShowing.value) {
                                  widget.controller!.isEmojiShowing.value =
                                      false;
                                }
                              },
                              scrollController:
                                  widget.controller?.typingScrollController,
                              onChanged: (value) {
                                /// write a code when user typing
                                widget.controller!.tyingSocket();
                              },
                              decoration: InputDecoration(
                                hintText: "Type something".tr,
                                isDense: true,
                                helperStyle: AppTextStyle.textStyle16(),
                                fillColor: const Color(0xffF3F3F3),
                                hintStyle: AppTextStyle.textStyle16(
                                    fontColor: appColors.grey),
                                hoverColor: appColors.white,
                                prefixIcon: InkWell(
                                  onTap: () async {
                                    widget.controller?.isEmojiShowing.value =
                                        !widget
                                            .controller!.isEmojiShowing.value;
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        6.w, 5.h, 6.w, 8.h),
                                    child: Assets.images.icEmojiShare.image(),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    !widget.controller!.hasMessage.value &&
                                            isGifts.value == 1
                                        ? GestureDetector(
                                            onTap: () {
                                              widget.controller!.askForGift();
                                            },
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/svg/chat_new_gift.svg"),
                                            ))
                                        : const SizedBox(),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0.sp),
                                    borderSide: BorderSide(
                                      color: appColors.white,
                                      width: 1.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0.sp),
                                    borderSide: BorderSide(
                                      color: appColors.transparent,
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                  ),
                ),
                widget.controller!.isRecording.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                            onTap: () => widget.controller!.refreshWave(),
                            child: Center(
                              child: Assets.images.icClose.svg(
                                  height: 24,
                                  color: const Color(0xff0E2339).withOpacity(0.5)),
                            )),
                      )
                    : const SizedBox(width: 5),
                if (!widget.controller!.hasMessage.value)
                  GestureDetector(
                      onTap: widget.controller!.startOrStopRecording,
                      child: Center(
                        child: SvgPicture.asset(
                            widget.controller!.isRecording.value
                                ? "assets/svg/new_chat_send.svg"
                                : "assets/svg/chat_new_mice.svg"),
                      ))
                else
                  InkWell(
                      onTap: () {
                        // write  logic for send msg code
                        widget.controller!.addNewMessage(
                            msgType: MsgType.text,
                            messageText: widget
                                .controller!.messageController.text
                                .trim());
                        widget.controller!.messageController.clear();
                        widget.controller?.isReplay.value = false;
                        widget.controller!.update();
                      },
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/new_chat_send.svg",
                        ),
                      )),
                const SizedBox(
                  width: 5,
                )
                // const SizedBox(width: 10),
              ],
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  isKundli.value == 1
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteName.checkKundli);
                          },
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svg/new_chat_kundli.svg")))
                      : SizedBox(),
                  isEcom.value == 1
                      ? GestureDetector(
                          onTap: () {
                            widget.controller!.openProduct();
                          },
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svg/chat_new_product.svg")),
                        )
                      : SizedBox(),
                  isEcom.value == 1
                      ? GestureDetector(
                          onTap: () {
                            widget.controller!.openCustomShop();
                          },
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svg/chat_new_custom_product.svg")),
                        )
                      : SizedBox(),
                  GestureDetector(
                    onTap: () {
                      widget.controller!.openShowDeck();
                    },
                    child: Center(
                      child: SvgPicture.asset(
                          "assets/svg/new_chat_tarrot_card.svg"),
                    ),
                  ),
                  isRemidies.value == 1
                      ? GestureDetector(
                          onTap: () {
                            widget.controller!.openRemedies();
                          },
                          child: Center(
                            child: SvgPicture.asset(
                                "assets/svg/chat_new_remedies.svg"),
                          ),
                        )
                      : SizedBox(),
                  Obx(() {
                    return isCamera.value == 1
                        ? GestureDetector(
                            onTap: () async {
                              if (await PermissionHelper()
                                  .askStoragePermission(Permission.photos)) {
                                openBottomSheet(Get.context!,
                                    functionalityWidget: Column(
                                      children: [
                                        Text("Choose Options",
                                            style: TextStyle(
                                                color: appColors.textColor,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        Text("Only photos can be shared",
                                            style: TextStyle(
                                                color: appColors.disabledGrey,
                                                fontFamily:
                                                    FontFamily.metropolis,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(height: 20.w),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.back();
                                                widget.controller!
                                                    .getImage(true);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        right: 30),
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.camera_alt,
                                                        color: appColors
                                                            .disabledGrey,
                                                        size: 50),
                                                    Text("Camera",
                                                        style: TextStyle(
                                                            color: appColors
                                                                .textColor,
                                                            fontFamily:
                                                                FontFamily
                                                                    .metropolis,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    Text(
                                                        "Capture an image\nfrom your camera",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: appColors
                                                                .disabledGrey,
                                                            fontFamily:
                                                                FontFamily
                                                                    .metropolis,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.back();
                                                widget.controller!
                                                    .getImage(false);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 30),
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.image,
                                                        color: appColors
                                                            .disabledGrey,
                                                        size: 50),
                                                    Text("Gallery",
                                                        style: TextStyle(
                                                            color: appColors
                                                                .textColor,
                                                            fontFamily:
                                                                FontFamily
                                                                    .metropolis,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    Text(
                                                        "Select an image\nfrom your gallery",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: appColors
                                                                .disabledGrey,
                                                            fontFamily:
                                                                FontFamily
                                                                    .metropolis,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ));
                              }
                            },
                            child: Center(
                                child: SvgPicture.asset(
                                    "assets/svg/new_chat_camera.svg")))
                        : SizedBox();
                  }),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget buildReplayMsgWidget() {
    print("photo url : ${widget.controller?.replayChatMessage.value?.message}");
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.controller?.replayChatMessage.value?.msgSendBy == "1" ? "You" : "Replying to ${AppFirebaseService().orderData.value["customerName"] ?? ''}",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        widget.controller!.replyScreenshotUnit8List.value != null ? SizedBox(
                          height: 100.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Image.memory(
                              widget.controller!.replyScreenshotUnit8List.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                        : const SizedBox(),
                        /*Text(
                          widget.controller?.replayChatMessage.value?.msgType == MsgType.text ? widget.controller?.replayChatMessage.value?.message ?? ""
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.image ? "Photo"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.remedies ? "Remedy"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.product ? "Product"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.customProduct ? "Custom Product"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.pooja ? "Pooja"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.kundli ? "Kundli"
                          : widget.controller?.replayChatMessage.value?.msgType == MsgType.sendgifts || widget.controller?.replayChatMessage.value?.msgType == MsgType.gift ? "Gift"
                          : "",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.0,
                            color: appColors.lightGrey,
                          ),
                        )*/
                      ],
                    ),
                  ),
                  widget.controller?.replayChatMessage.value?.msgType == MsgType.gift || widget.controller?.replayChatMessage.value?.msgType == MsgType.sendgifts || widget.controller?.replayChatMessage.value?.msgType == MsgType.customProduct || widget.controller?.replayChatMessage.value?.msgType == MsgType.image || widget.controller?.replayChatMessage.value?.msgType == MsgType.product || widget.controller?.replayChatMessage.value?.msgType == MsgType.pooja ? ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 40.0,
                      width: 30.0,
                      child: Image.network(
                        widget.controller?.replayChatMessage.value?.msgType == MsgType.product ? "${preferenceService.getAmazonUrl()}/${widget.controller?.replayChatMessage.value?.getProduct?.prodImage ?? ""}"
                        : widget.controller?.replayChatMessage.value?.msgType == MsgType.pooja ? "${preferenceService.getAmazonUrl()}/${widget.controller?.replayChatMessage.value?.getPooja?.poojaImage ?? ""}"
                        : widget.controller?.replayChatMessage.value?.msgType == MsgType.customProduct ? "${preferenceService.getAmazonUrl()}/${widget.controller?.replayChatMessage.value?.getCustomProduct?.image ?? ""}"
                        : widget.controller?.replayChatMessage.value?.msgType == MsgType.sendgifts || widget.controller?.replayChatMessage.value?.msgType == MsgType.gift ? widget.controller?.replayChatMessage.value?.awsUrl ?? ""
                        : widget.controller?.replayChatMessage.value?.message == null ? widget.controller?.replayChatMessage.value?.awsUrl ?? "" : widget.controller?.replayChatMessage.value?.message ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
        const SizedBox(width: 10.0,),
        GestureDetector(
          onTap: () => widget.controller?.isReplay.value = false,
          child: CircleAvatar(
            radius: 12.0,
            backgroundColor: appColors.bannerTitleColor,
            child: Icon(
              Icons.close,
              size: 20.0,
              color: appColors.whiteGuidedColor,
            ),
          ),
        ),
      ],
    );
  }
}
