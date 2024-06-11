import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class MoreOptionsForModWidget extends StatefulWidget {
  const MoreOptionsForModWidget({
    required this.onClose,
    required this.isHost,
    required this.isMod,
    required this.onTapAskForBlockUnBlockUser,
    required this.isBlocked,
    super.key,
  });

  final void Function() onClose;
  final bool isHost;
  final bool isMod;
  final void Function() onTapAskForBlockUnBlockUser;
  final bool isBlocked;

  @override
  State<MoreOptionsForModWidget> createState() =>
      _MoreOptionsForModWidgetState();
}

class _MoreOptionsForModWidgetState extends State<MoreOptionsForModWidget> {
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
          // height: Get.height / 3.00,
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
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          moreOptionsButton2(
            buttonText: "${widget.isBlocked ? "Unblock" : "Block"} This User",
            buttonCallback: widget.onTapAskForBlockUnBlockUser,
            buttonImage: widget.isBlocked
                ? "assets/images/live_unblock_icon.png"
                : "assets/images/live_block_icon.png",
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
              Image.asset(
                buttonImage,
                height: 24,
                width: 24,
              ),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(width: 1, color: appColors.red),
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
                style: TextStyle(color: appColors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
