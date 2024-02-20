import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/message_view.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/feedback_controller.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/widget/feedback_card.dart';
import 'package:divine_astrologer/screens/order_history/Widget/shimmer_widget_feedback.dart';
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
              border: Border.all(color: appColors.red, width: 1),
            ),
            child: Text(
              'Need Help ?',
              style: AppTextStyle.textStyle12(
                fontColor: appColors.red,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<FeedbackController>(
          builder: (controller) {
        print ("Product Id :: ${controller.order?.productType}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.order?.productType == null
                ? ShimmerLoader()
                : Padding(
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
                          fontColor: appColors.darkBlue,
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
                          fontColor: appColors.darkBlue.withOpacity(.5),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
                          (data.createdAt != null &&
                              controller.chatMessageList[index - 1].createdAt != null &&
                              (DateTime.tryParse(data.createdAt!) ??
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(data.createdAt!))) // Convert epoch time if parsing fails
                                  .day !=
                                  (DateTime.tryParse(controller.chatMessageList[index - 1].createdAt!) ??
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(controller.chatMessageList[index - 1].createdAt!)))
                                      .day);

                      return controller.order?.productType == 12
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isNewDay)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.w),
                                    child: Container(
                                      width: 60,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: appColors.brown,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data.createdAt != null
                                              ? DateFormat('dd MMM').format(
                                                  DateTime.parse(
                                                      data.createdAt!))
                                              : 'Na',
                                          style: AppTextStyle.textStyle10(
                                            fontColor: appColors.white,
                                          ),
                                        ),
                                      ),
                                    ).centered(),
                                  ),
                                // Display chat message
                                data.msgType == 0
                                    ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 4.h),
                                  child: MessageView(
                                    index: index,
                                    userName: '',
                                    chatMessage: data,
                                    yourMessage:
                                    data.senderId ==
                                        preferenceService
                                            .getUserDetail()!
                                            .id,
                                  ),
                                )
                                    : SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 4.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          (data.msgType ?? 0) == 1
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
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                offset: const Offset(0.0, 3.0),
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                    alignment:
                                                        WrapAlignment.end,
                                                    children: [
                                                      Text(
                                                        data.message ?? "",
                                                        style: AppTextStyle
                                                            .textStyle14(
                                                          fontColor:
                                                              (data.msgType ??
                                                                          0) ==
                                                                      1
                                                                  ? appColors
                                                                      .darkBlue
                                                                  : appColors
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
                                                            data.createdAt ??
                                                                ''),
                                                      ),
                                                      style: AppTextStyle
                                                          .textStyle10(
                                                        fontColor:
                                                            appColors.darkBlue,
                                                      ),
                                                    ),
                                                    (data.seenStatus ?? 0) == 0
                                                        ? SizedBox(width: 8.w)
                                                        : (data.seenStatus ??
                                                                    0) ==
                                                                1
                                                            ? Assets.images
                                                                .icSingleTick
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
                            )
                          : Column(
                              children: [
                                if (isNewDay)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.w),
                                    child: Container(
                                      width: 60,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: appColors.brown,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('dd MMM').format(
                                              DateTime.parse(data.createdAt!)),
                                          style: AppTextStyle.textStyle10(
                                            fontColor: appColors.white,
                                          ),
                                        ),
                                      ),
                                    ).centered(),
                                  ),
                                CustomVoicePlayer(
                                  playUrl: data.callRecording ?? "",
                                  callDuration: data.callDuration,
                                ),

                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
            controller.order?.productType == null
                ? ShimmerLoader()
                : Padding(
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
                                      '${controller.astroFeedbackDetailData.value?.totalProblem ?? 0}',
                                  style:  TextStyle(color: appColors.red),
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
                                      '-₹ ${controller.astroFeedbackDetailData.value?.fineAmounts ?? 0}',
                                  style:  TextStyle(color: appColors.red),
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
                    itemCount:
                        controller.astroFeedbackDetailData.value?.problems?.length ??
                            0,
                    itemBuilder: (context, index) {
                      final feedbackProblem =
                          controller.astroFeedbackDetailData.value?.problems?[index];
                      return FeedbackCallChatCardWidget(
                          feedbackProblem: feedbackProblem!);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget remediesMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    var jsonString = (chatMessage.message ?? '').substring(1,(chatMessage.message ?? '').length -1);
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
                  color:  appColors.yellow ,
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
                onTap: () => Get.toNamed(RouteName.remediesDetail, arguments:{'title': temp[0], 'subtitle': temp[1]}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class CustomVoicePlayer extends StatefulWidget {
  final String playUrl;
  final String callDuration; // Add callDuration as a parameter

  const CustomVoicePlayer({
    super.key,
    required this.playUrl,
    required this.callDuration,
  });

  @override
  State<CustomVoicePlayer> createState() => _CustomVoicePlayerState();
}

class _CustomVoicePlayerState extends State<CustomVoicePlayer> {
  bool isPlaying = false;
  double playbackProgress = 0.0;
  late Duration totalDuration;
  late Duration currentPosition;
  late Timer timer = Timer(Duration.zero, () {});
  bool isMuted = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    totalDuration = parseDuration(widget.callDuration);
    currentPosition = const Duration(seconds: 0);
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void togglePlayback() {
    if (isPlaying) {
      audioPlayer.pause();
      timer.cancel();
    } else {
      audioPlayer.play(UrlSource(widget.playUrl), position: currentPosition);
      startTimer();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        playbackProgress += 1.0;
        currentPosition = Duration(seconds: playbackProgress.toInt());
      });

      if (currentPosition >= totalDuration) {
        timer.cancel();
        setState(() {
          isPlaying = false;
          playbackProgress = 0.0;
          currentPosition = const Duration(seconds: 0);
        });
      }
    });
  }

  void handleSliderChange(double value) {
    setState(() {
      playbackProgress = value;
      currentPosition = Duration(seconds: playbackProgress.toInt());
    });
    // Play the audio at the adjusted position
    audioPlayer.play(UrlSource(widget.playUrl), position: currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              togglePlayback();
              if (!isPlaying) {
                timer.cancel();
              }
            },
            iconSize: 30.0,
            color: Colors.grey,
          ),
          Text(
            formatDuration(currentPosition),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(
            width: 150.w,
            child: Slider(
              value: playbackProgress.clamp(
                  0.0, totalDuration.inSeconds.toDouble()),
              onChanged: handleSliderChange,
              onChangeEnd: (double value) {
                // Add logic to seek to the specified position in the audio
              },
              min: 0.0,
              max: totalDuration.inSeconds.toDouble(),
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.grey,
            ),
          ),
          Text(
            "-${formatDuration(totalDuration - currentPosition)}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.grey,
              size: 24.0,
            ),
            onPressed: () {
              // Toggle mute state
              setState(() {
                isMuted = !isMuted;
                audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
              });
            },
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration parseDuration(String duration) {
    List<String> parts = duration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }
}
