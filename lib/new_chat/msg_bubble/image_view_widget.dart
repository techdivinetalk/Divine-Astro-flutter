import 'dart:io';
import 'dart:ui';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/widgets/product/pooja/widgets/custom_widget/pooja_common_list.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/colors.dart';
import '../../gen/assets.gen.dart';
import '../../screens/order_chat_call_feedback/widget/chat_history_widget.dart';
import '../widget/common_read_function.dart';

class ImageViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final String image;
  final ChatMessage chatDetail;
  final bool yourMessage;

  ImageViewWidget({
    required this.chatDetail,
    required this.yourMessage,
    this.controller,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment:
            yourMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
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
                      padding: const EdgeInsets.only(top: 3, right: 5),
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
              : const SizedBox(),
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
                  ? Stack(children: [
                      GestureDetector(
                        onTap: () {
                          print("call this ne -------> ${chatDetail.message}");
                          Get.toNamed(RouteName.imagePreviewUi,
                              arguments: chatDetail.message == null
                                  ? "${chatDetail.awsUrl}"
                                  : "${chatDetail.message}");
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0.sp),
                          child: Image.network(
                            chatDetail.message == null
                                ? "${chatDetail.awsUrl}"
                                : "${chatDetail.message}",
                            fit: BoxFit.cover,
                            height: 200.h,
                          ),
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
                                appColors.textColor.withOpacity(0.0),
                                appColors.textColor.withOpacity(0.0),
                                appColors.textColor.withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                messageDateTime(
                                    int.parse(chatDetail.time.toString())),
                                style: AppTextStyle.textStyle10(
                                    fontColor: appColors.white),
                              ),
                              if (yourMessage) SizedBox(width: 3.w),
                              if (yourMessage)
                                CommonReadWidget(chatDetail: chatDetail),
                              // if (yourMessage) SizedBox(width: 8.w),
                              // if (yourMessage)
                              //   chatDetail.type == 0
                              //       ? Assets.images.icSingleTick.svg()
                              //       : chatDetail.type == 1
                              //           ? Assets.images.icDoubleTick.svg(
                              //               colorFilter: ColorFilter.mode(
                              //                   appColors.grey,
                              //                   BlendMode.srcIn))
                              //           : chatDetail.type == 3
                              //               ? Assets.images.icDoubleTick.svg()
                              //               : Assets.images.icSingleTick.svg()
                            ],
                          ),
                        ),
                      ),
                    ])
                  : (chatDetail.downloadedPath == "" || chatDetail.downloadedPath == null)
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
                            InkWell(
                              onTap: () {
                                controller?.downloadImage(
                                    fileName: image,
                                    chatDetail: chatDetail,
                                    id: chatDetail.id ?? 0);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.textColor.withOpacity(0.3),
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
                                          appColors.textColor.withOpacity(0.0),
                                          appColors.textColor.withOpacity(0.0),
                                          appColors.textColor.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      messageDateTime(int.parse(
                                          chatDetail.time.toString())),
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
                            print(chatDetail.message);

                            print("chatDetail.downloadedPath");
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
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6)
                                          .copyWith(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10.r)),
                                    gradient: LinearGradient(
                                      colors: [
                                        appColors.textColor.withOpacity(0.0),
                                        appColors.textColor.withOpacity(0.0),
                                        appColors.textColor.withOpacity(0.5),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        messageDateTime(int.parse(
                                            chatDetail.time.toString())),
                                        style: AppTextStyle.textStyle10(
                                            fontColor: appColors.white),
                                      ),
                                      if (yourMessage) SizedBox(width: 3.w),
                                      if (yourMessage)
                                        CommonReadWidget(chatDetail: chatDetail),
                                      // if (yourMessage) SizedBox(width: 8.w),
                                      // if (yourMessage)
                                      //   chatDetail.type == 0
                                      //       ? Assets.images.icSingleTick.svg()
                                      //       : chatDetail.type == 1
                                      //           ? Assets.images.icDoubleTick
                                      //               .svg(
                                      //                   colorFilter:
                                      //                       ColorFilter.mode(
                                      //                           appColors.grey,
                                      //                           BlendMode
                                      //                               .srcIn))
                                      //           : chatDetail.type == 3
                                      //               ? Assets.images.icDoubleTick
                                      //                   .svg()
                                      //               : Assets.images.icSingleTick
                                      //                   .svg()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
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
