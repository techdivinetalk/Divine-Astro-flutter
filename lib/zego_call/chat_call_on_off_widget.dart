import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ChatCallOnOffWidget extends StatefulWidget {
  const ChatCallOnOffWidget({
    required this.onClose,
    required this.makeCall,
    required this.makeTurnOnOffCalls,
    required this.currentStatus,
    required this.isVideoCall,
    super.key,
  });

  final void Function() onClose;
  final void Function() makeCall;
  final void Function() makeTurnOnOffCalls;
  final bool currentStatus;
  final bool isVideoCall;

  @override
  State<ChatCallOnOffWidget> createState() => _ChatCallOnOffWidgetState();
}

class _ChatCallOnOffWidgetState extends State<ChatCallOnOffWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
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
            border: Border.all(color: appColors.white),
            color: appColors.white.withOpacity(0.2),
          ),
          child: Icon(Icons.close, color: appColors.white),
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
          // height: Get.height / 2.24,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white,
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
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          moreOptionsButton(
            buttonText: "Request ${type()} Call",
            buttonCallback: widget.makeCall,
            buttonImage: widget.isVideoCall
                ? "assets/images/chat_new_video_call_icon.png"
                : "assets/images/chat_new_voice_call_icon.png",
          ),
          const SizedBox(height: 16),
          moreOptionsButton2(
            buttonText: msg(),
            buttonCallback: widget.makeTurnOnOffCalls,
            buttonImage: widget.currentStatus
                ? "assets/images/chat_new_disable_icon.png"
                : "assets/images/chat_new_enable_icon.png",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String msg() {
    return "${widget.currentStatus ? "Disable" : "Enable"} ${type()} Call";
  }

  String type() {
    return widget.isVideoCall == true ? "Video" : "Voice";
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
            backgroundColor: MaterialStateProperty.all(appColors.guideColor),
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
              Image.asset(buttonImage, height: 24, width: 24),
              const SizedBox(width: 16),
              Text(
                buttonText,
                style: TextStyle(color: appColors.black),
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
            backgroundColor: MaterialStateProperty.all(appColors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(
                  color: widget.currentStatus ? appColors.red : appColors.black,
                ),
              ),
            ),
          ),
          onPressed: buttonCallback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(buttonImage, height: 24, width: 24),
              const SizedBox(width: 16),
              Text(
                buttonText,
                style: TextStyle(
                  color: widget.currentStatus ? appColors.red : appColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
