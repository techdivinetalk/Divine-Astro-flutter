import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ChatCallOnOffWidget extends StatefulWidget {
  const ChatCallOnOffWidget({
    required this.onClose,
    required this.makeCall,
    required this.makeTurnOnOffCalls,
    required this.currentStatus,
    super.key,
  });

  final void Function() onClose;
  final void Function() makeCall;
  final void Function() makeTurnOnOffCalls;
  final bool currentStatus;

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
            border: Border.all(color: appColors.yellow),
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
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              "assets/images/live_end_session.png",
            ),
          ),
          const SizedBox(height: 16),
          const Text("What to do?"),
          const SizedBox(height: 16),
          widget.currentStatus
              ? Column(children: [callButton(), changeButton()])
              : changeButton()
        ],
      ),
    );
  }

  Widget callButton() {
    return Column(
      children: [
        CommonButton(
          buttonText: "Make a Call",
          buttonCallback: widget.makeCall,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget changeButton() {
    bool value = widget.currentStatus;
    return Column(
      children: [
        TextButton(
          onPressed: widget.makeTurnOnOffCalls,
          child: Text(
            "Turn ${value ? "off" : "on"} calls",
            style: const TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
              decorationColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
