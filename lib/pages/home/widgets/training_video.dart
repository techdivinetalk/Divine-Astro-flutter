import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../model/home_page_model_class.dart';
import '../home_controller.dart';

class TrainingVideoUI extends StatefulWidget {
  final TrainingVideo? video;

  const TrainingVideoUI({Key? key, required this.video}) : super(key: key);

  @override
  State<TrainingVideoUI> createState() => _TrainingVideoUIState();
}

class _TrainingVideoUIState extends State<TrainingVideoUI> {
  late YoutubePlayerController _controller;
  var shouldCall = true;

 /* Widget player() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      bottomActions: [
        RemainingDuration()
      ],
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
    );
  }*/

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: extractYoutubeVideoID(widget.video?.url ?? "") ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    _controller.addListener(() {
      var time = durationFormatter((_controller.metadata.duration.inMilliseconds) -
          (_controller.value.position.inMilliseconds));
      time = time.substring(time.length - 5);
      if(time == "00:30"){
        if(shouldCall){
          shouldCall = false;
          var controller = Get.find<HomeController>();
          controller.trainingVideoViewData(widget.video?.id ?? 0);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeController>(builder: (controller) {
        // print("Data-->${_controller.value.position}");
        return YoutubePlayer(
          progressIndicatorColor: Colors.red,
          onReady: () {},
          controller: _controller,
          topActions: const [
            SizedBox(),
          ],
          bottomActions: [
            SizedBox(
              width: 80.w,
              child: Row(
                children: [
                  CurrentPosition(controller: _controller),
                  RemainingDuration(controller: _controller),
                ],
              ),
            ),
            ProgressBar(
              isExpanded: true,
              controller: _controller,
              colors: ProgressBarColors(
                handleColor: AppColors.white,
                playedColor: AppColors.white,
                backgroundColor: AppColors.white.withOpacity(0.5),
              ),
            ),

            // const FullScreenExit(),
          ],
        );
      }),
    );
  }
}

String durationFormatter(int milliSeconds) {
  var seconds = milliSeconds ~/ 1000;
  final hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
      ? '00'
      : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
      ? '00'
      : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
      ? '00'
      : '0$seconds';
  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
  return formattedTime;
}
