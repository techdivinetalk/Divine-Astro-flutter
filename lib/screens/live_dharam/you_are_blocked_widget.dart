import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class YouAreBlockedWidget extends StatefulWidget {
  const YouAreBlockedWidget({
    required this.onClose,
    super.key,
  });

  final Function() onClose;

  @override
  State<YouAreBlockedWidget> createState() => _YouAreBlockedWidgetState();
}

class _YouAreBlockedWidgetState extends State<YouAreBlockedWidget> {
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
          child:  Icon(Icons.close, color: appColors.white),
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
        children: <Widget>[
          const SizedBox(height: 32),
          Image.asset(
            "assets/images/live_you_are_blocked.png",
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            "You are blocked!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "You cannot perform this action as you are blocked by the astrologer.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CommonButton(
            buttonText: "Okay",
            buttonCallback: widget.onClose,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
