import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class MoreOptionsWidget extends StatefulWidget {
  const MoreOptionsWidget({
    required this.onClose,
    required this.isHost,
    required this.onTapAskForGifts,
    required this.onTapAskForVideoCall,
    required this.onTapAskForAudioCall,
    required this.onTapAskForPrivateCall,
    required this.onTapAskForBlockUnBlockUser,
    required this.isBlocked,
    super.key,
  });

  final void Function() onClose;
  final bool isHost;
  final void Function() onTapAskForGifts;
  final void Function() onTapAskForVideoCall;
  final void Function() onTapAskForAudioCall;
  final void Function() onTapAskForPrivateCall;
  final void Function() onTapAskForBlockUnBlockUser;
  final bool isBlocked;

  @override
  State<MoreOptionsWidget> createState() => _MoreOptionsWidgetState();
}

class _MoreOptionsWidgetState extends State<MoreOptionsWidget> {
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
          // height: Get.height / 3.00,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.yellow),
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
          const SizedBox(height: 8),
          moreOptionsButton(
            buttonText: "Ask For Gift",
            buttonCallback: widget.onTapAskForGifts,
            buttonImage: "assets/images/live_new_gift_latest.png",
          ),
          moreOptionsButton(
            buttonText: "Ask For Video Call",
            buttonCallback: widget.onTapAskForVideoCall,
            buttonImage: "assets/images/live_call_video.png",
          ),
          moreOptionsButton(
            buttonText: "Ask For Voice Call",
            buttonCallback: widget.onTapAskForAudioCall,
            buttonImage: "assets/images/live_call_audio.png",
          ),
          moreOptionsButton(
            buttonText: "Ask For Private Call",
            buttonCallback: widget.onTapAskForPrivateCall,
            buttonImage: "assets/images/live_call_private.png",
          ),
          moreOptionsButton2(
            buttonText: "${widget.isBlocked ? "Unblock" : "Block"} This User",
            buttonCallback: widget.onTapAskForBlockUnBlockUser,
            buttonImage: "assets/images/live_block_icon.png",
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget moreOptionsButton({
    required String buttonText,
    required Function() buttonCallback,
    required String buttonImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(AppColors.yellow),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          onPressed: buttonCallback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                buttonImage,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16),
              Text(
                buttonText,
                style: const TextStyle(color: AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moreOptionsButton2({
    required String buttonText,
    required Function() buttonCallback,
    required String buttonImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(AppColors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(width: 1, color: AppColors.red),
              ),
            ),
          ),
          onPressed: buttonCallback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                buttonImage,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16),
              Text(
                buttonText,
                style: const TextStyle(color: AppColors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}