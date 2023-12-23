import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CongratulationsWidget extends StatefulWidget {
  const CongratulationsWidget({
    required this.onClose,
    required this.leader,
    required this.isHost,
    super.key,
  });

  final void Function() onClose;
  final LeaderboardModel leader;
  final bool isHost;

  @override
  State<CongratulationsWidget> createState() => _CongratulationsWidgetState();
}

class _CongratulationsWidgetState extends State<CongratulationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[top(), const SizedBox(height: 16), bottom()],
      ),
    );
  }

  Widget top() {
    return InkWell(
      onTap: widget.onClose,
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: AppColors.white),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: const Icon(Icons.close, color: AppColors.white),
        ),
      ),
    );
  }

  Widget bottom() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: Get.height / 2.24,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.appYellowColour),
            color: AppColors.white,
          ),
          child: grid(),
        ),
      ),
    );
  }

  Widget grid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              SizedBox(
                height: 100,
                width: 100,
                child: CustomImageWidget(
                  imageUrl: widget.leader.avatar,
                  rounded: true,
                ),
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: Image.asset("assets/images/live_champion.png"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Congratulations!!"),
          const SizedBox(height: 16),
          Text(
            widget.isHost
                ? "${widget.leader.userName} is your Live Star"
                : "You are now Astrologer's Live Star",
          ),
          const SizedBox(height: 16),
          CommonButton(
            buttonText: widget.isHost ? "Okay, Sure" : "Yay! Thank You",
            buttonCallback: widget.onClose,
          )
        ],
      ),
    );
  }
}
