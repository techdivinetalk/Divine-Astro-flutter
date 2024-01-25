import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/feedback_controller.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/widget/feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class FeedBack extends GetView<FeedbackController> {
  const FeedBack({super.key});

  @override
  Widget build(BuildContext context) {

    bool isPlaying = false;

    double playbackProgress = 0.5;
    void togglePlayback() {
      isPlaying = !isPlaying;

      // Add logic to start/stop audio playback here
    }

    return Scaffold(
      appBar: commonDetailAppbar(
        title: "Order Feedback",
        trailingWidget: InkWell(
          onTap: () => controller.homeController.whatsapp(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              border: Border.all(color: AppColors.red, width: 1),
            ),
            child: Text(
              'Need Help ?',
              style: AppTextStyle.textStyle12(
                fontColor: AppColors.red,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isFeedbackAvailable.value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        controller.order?.productType == 12
                            ? Assets.svg.message.svg(height: 12.h, width: 12.h)
                            : Assets.svg.icCall1.svg(height: 12.h, width: 12.h),
                        SizedBox(width: 8.w),
                        Text(
                          'ID : ${controller.order?.id ?? "N/A"}',
                          style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          controller.order?.createdAt != null
                              ? DateFormat('dd MMMM, hh:mma').format(
                                  DateTime.parse(controller.order!.createdAt!),
                                )
                              : "N/A",
                          style: AppTextStyle.textStyle10(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue.withOpacity(.5),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              /*Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: togglePlayback,
                      iconSize: 24.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 2.0),
                    const Text(
                      '0:00',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Slider(
                      value: playbackProgress,
                      onChanged: (double value) {
                        playbackProgress = value;
                      },
                      activeColor: Colors.greenAccent,
                      inactiveColor: Colors.grey,
                    ),
                    const Text(
                      '-0:00',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.volume_up,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                    const SizedBox(width: 4.0),
                  ],
                ),
              ),*/
              SizedBox(
                height: Get.height * 0.4,
                child: Stack(
                  children: [
                    Assets.images.bgChatWallpaper.image(
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    ListView.builder(
                      itemCount: controller.chatMessageList.length,
                      controller: controller.messageScrollController,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = controller.chatMessageList[index];

                        bool isNewDay = index == 0 ||
                            DateTime.parse(data.createdAt!).day !=
                                DateTime.parse(controller
                                        .chatMessageList[index - 1].createdAt!)
                                    .day;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display date header if it's a new day
                            if (isNewDay)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.w),
                              child: Container(
                                width: 60,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5F3C08),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    DateFormat('dd MMM')
                                        .format(DateTime.parse(data.createdAt!)),
                                    style: AppTextStyle.textStyle10(
                                      fontColor: AppColors.white,
                                    ),
                                  ),
                                ),
                              ).centered(),
                            ),
                            // Display chat message
                            SizedBox(
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
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 3.0,
                                            offset: const Offset(0.0, 3.0),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            ScreenUtil().screenWidth * 0.7,
                                        minWidth:
                                            ScreenUtil().screenWidth * 0.27,
                                      ),
                                      child: Stack(
                                        alignment: (data.msgType ?? 0) == 1
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Wrap(
                                                alignment: WrapAlignment.end,
                                                children: [
                                                  Text(
                                                    data.message ?? "",
                                                    style: AppTextStyle
                                                        .textStyle14(
                                                      fontColor:
                                                          (data.msgType ??
                                                                      0) ==
                                                                  1
                                                              ? AppColors
                                                                  .darkBlue
                                                              : AppColors
                                                                  .darkBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20.h),
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
                                                        data.createdAt ?? ''),
                                                  ),
                                                  style:
                                                      AppTextStyle.textStyle10(
                                                    fontColor:
                                                        AppColors.darkBlue,
                                                  ),
                                                ),
                                                (data.seenStatus ?? 0) == 0
                                                    ? SizedBox(width: 8.w)
                                                    : (data.seenStatus ?? 0) ==
                                                            1
                                                        ? Assets
                                                            .images.icSingleTick
                                                            .svg()
                                                        : (data.seenStatus ??
                                                                    0) ==
                                                                2
                                                            ? Assets.images
                                                                .icDoubleTick
                                                                .svg()
                                                            : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Total problems Found : ',
                                style: AppTextStyle.textStyle16(
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text:
                                        '${controller.astroFeedbackDetailData?.totalProblem ?? 0}',
                                    style:
                                        const TextStyle(color: AppColors.red),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                text: 'Total Applicable Fine : ',
                                style: AppTextStyle.textStyle16(
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text:
                                        '-₹ ${controller.astroFeedbackDetailData?.fineAmounts ?? 0}',
                                    style:
                                        const TextStyle(color: AppColors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.info_outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller
                              .astroFeedbackDetailData?.problems?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final feedbackProblem = controller
                            .astroFeedbackDetailData?.problems?[index];
                        return FeedbackCallChatCardWidget(
                            feedbackProblem: feedbackProblem!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const GenericLoadingWidget();
        }
      }),
    );
  }
}
