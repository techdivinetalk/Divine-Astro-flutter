import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/remedie_chat/remedies_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';

class RemediesChatScreen extends GetView<RemediesChatController> {
  const RemediesChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RemediesChatController>(
        assignId: true,
        init: RemediesChatController(UserRepository()),
        builder: (controller) {
          return Scaffold(
            backgroundColor: appColors.white,
            appBar: AppBar(
              centerTitle: true,
              forceMaterialTransparency: true,
              backgroundColor: appColors.white,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Tripti (Job Healing)".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: appColors.textColor,
                          fontFamily: FontFamily.metropolis)),
                  Text("#9876543210".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: appColors.textColor,
                          fontFamily: FontFamily.metropolis)),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: appColors.guideColor.withOpacity(0.05)),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    "This is a free group chat to serve Remedy orders. It is not billed on per min basis."
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: appColors.guideColor,
                        fontFamily: FontFamily.metropolis),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.messages.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(left: 8),
                      itemBuilder: (context, index) {
                        var data = controller.messages[index];
                        return Align(
                          alignment: data['from'] == "me"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: data['from'] == "me"
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14),
                                        topLeft: Radius.circular(14),
                                      )
                                    : BorderRadius.only(
                                        bottomRight: Radius.circular(14),
                                        bottomLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                        // topLeft: Radius.circular(14),
                                      ),
                                color: data['from'] == "me"
                                    ? appColors.guideColor.withOpacity(0.05)
                                    : appColors.white,
                                border: Border.all(
                                  color: data['from'] == "me"
                                      ? appColors.guideColor.withOpacity(0.1)
                                      : appColors.grey.withOpacity(0.2),
                                ),
                              ),
                              constraints: BoxConstraints(
                                  maxWidth: ScreenUtil().screenWidth * 0.7,
                                  minWidth: ScreenUtil().screenWidth * 0.27),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: Stack(
                                  alignment: data['from'] == "me"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  children: [
                                    Column(
                                      children: [
                                        Wrap(
                                            alignment: data['from'] == "me"
                                                ? WrapAlignment.end
                                                : WrapAlignment.start,
                                            children: [
                                              Text(data['message'] ?? "",
                                                  maxLines: 100,
                                                  style:
                                                      AppTextStyle.textStyle14(
                                                          fontColor: appColors
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
                                          data['from'] != "me"
                                              ? Text(
                                                  "Admin",
                                                  style:
                                                      AppTextStyle.textStyle10(
                                                    fontColor:
                                                        appColors.guideColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(width: 3.w),

                                          Text(
                                              "${DateTime.parse(data['time'].toString()).hour}:${DateTime.parse(data['time'].toString()).minute}",
                                              style: AppTextStyle.textStyle10(
                                                  fontColor:
                                                      appColors.darkBlue)),
                                          SizedBox(width: 3.w),
                                          // if ( data['from'] == "me")
                                          // chatSeenStatusWidget(
                                          //     seenStatus:
                                          //     currentMsg.seenStatus ?? SeenStatus.sent)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // child: Column(
                                //   children: [
                                //     Wrap(
                                //         alignment: data['from'] == "me"
                                //             ? WrapAlignment.end
                                //             : WrapAlignment.start,
                                //         children: [
                                //           Text(data['message'] ?? "",
                                //               maxLines: 100,
                                //               style: AppTextStyle.textStyle14(
                                //                   fontColor:
                                //                       appColors.darkBlue))
                                //         ]),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                controller.chatEnded.value
                    ? SizedBox()
                    : SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: controller.templates.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 4),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          color: controller.templates[index] ==
                                                  "Add"
                                              ? Color.fromRGBO(218, 36, 57, 1)
                                              : appColors.guideColor
                                                  .withOpacity(0.05),
                                          border: Border.all(
                                            color: appColors.guideColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 4,
                                              bottom: 4),
                                          child: Center(
                                            child: Text(
                                              controller.templates[index] ==
                                                      "Add"
                                                  ? "+ Add"
                                                  : controller.templates[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color: controller.templates[
                                                              index] ==
                                                          "Add"
                                                      ? appColors.white
                                                      : appColors.black,
                                                  fontFamily:
                                                      FontFamily.metropolis),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                controller.chatEnded.value
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: appColors.grey.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            controller: controller.textController,
                            onChanged: (value) {
                              controller.update();
                            },
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: FontFamily.poppins,
                              fontWeight: FontWeight.w400,
                              color: appColors.black.withOpacity(0.9),
                            ),
                            decoration: InputDecoration(
                              hintText: "Type Something...",
                              hintStyle: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: FontFamily.poppins,
                                fontWeight: FontWeight.w400,
                                color: appColors.grey.withOpacity(0.9),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  top: 10, bottom: 5, left: 10, right: 10),
                              suffixIcon: SizedBox(
                                width: controller.textController.text.isNotEmpty
                                    ? 50
                                    : 80,
                                child: controller.textController.text.isNotEmpty
                                    ? SizedBox(
                                        child: InkWell(
                                            onTap: () {
                                              controller.messages.value.add(
                                                {
                                                  "id": 5,
                                                  "sent_by": "RB",
                                                  "from": "me",
                                                  "message": controller
                                                      .textController.text
                                                      .toString(),
                                                  "time": DateTime.now(),
                                                },
                                              );
                                              if (controller.scrollController
                                                  .hasClients) {
                                                controller.scrollController
                                                    .animateTo(
                                                        controller
                                                                .scrollController
                                                                .position
                                                                .maxScrollExtent *
                                                            2,
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        curve: Curves.ease);
                                              }
                                              controller.textController.clear();
                                              controller.update();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.send,
                                                color: appColors.guideColor,
                                              ),
                                            )),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: appColors.grey,
                                                ),
                                              )),
                                          InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Icon(
                                                  Icons.mic_none_outlined,
                                                  color: appColors.grey,
                                                ),
                                              )),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                controller.chatEnded.value
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.call_outlined,
                                      color: appColors.grey,
                                    )),
                                Text(
                                  "Voice Call",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: FontFamily.metropolis,
                                    fontWeight: FontWeight.w600,
                                    color: appColors.grey.withOpacity(0.9),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.video_call_outlined,
                                      color: appColors.grey,
                                    )),
                                Text(
                                  "Video Call",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: FontFamily.metropolis,
                                    fontWeight: FontWeight.w600,
                                    color: appColors.grey.withOpacity(0.9),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                controller.chatEnded.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 5, bottom: 5),
                            child: Divider(),
                          ),
                          Text(
                            "Order Closed",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.textStyle20(
                              fontColor: appColors.guideColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
