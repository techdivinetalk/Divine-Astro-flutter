import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../model/home_page_model_class.dart';

class TrainingVideoUI extends StatefulWidget {
  final TrainingVideo video;

  const TrainingVideoUI({Key? key, required this.video}) : super(key: key);

  @override
  State<TrainingVideoUI> createState() => _TrainingVideoUIState();
}

class _TrainingVideoUIState extends State<TrainingVideoUI> {
  late YoutubePlayerController _controller;

  Widget player() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
    );
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: extractYoutubeVideoID(widget.video.url ?? "") ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("-------------");
    log("${widget.video.url}");
    log("${widget.video.id}");
    log("${widget.video.youtubeThumbNail}");

    //_controller.
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: YoutubePlayer(
            controller: _controller,
            topActions: const [
              SizedBox(),
            ],
            bottomActions: [
              ProgressBar(
                isExpanded: true,
                controller: _controller,
                colors: ProgressBarColors(
                  handleColor: AppColors.white,
                  playedColor: AppColors.white,
                  backgroundColor: AppColors.white.withOpacity(0.5),
                ),
              ),
              //   const FullScreenExit(),
            ],
          ),
        ),
      ),
    );
  }
}
