import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class BlockUnblockWidget extends StatefulWidget {
  const BlockUnblockWidget({
    required this.onClose,
    required this.performAction,
    required this.isAlreadyBeenBlocked,
    super.key,
  });

  final Function() onClose;
  final Function() performAction;
  final bool isAlreadyBeenBlocked;

  @override
  State<BlockUnblockWidget> createState() => _BlockUnblockWidgetState();
}

class _BlockUnblockWidgetState extends State<BlockUnblockWidget> {
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
        children: <Widget>[
          const SizedBox(height: 32),
          Image.asset(
            widget.isAlreadyBeenBlocked
                ? "assets/images/live_unblock_icon.png"
                : "assets/images/live_block_icon.png",
            fit: BoxFit.contain,
            height: 50,
            width: 50,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isAlreadyBeenBlocked
                ? "Unblock This User ?"
                : "Block This User ?",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isAlreadyBeenBlocked
                ? "If you block this user, then you won't be able see their messages until you unblock them."
                : "If you block this user, then you won't be able see their messages until you unblock them.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          widget.isAlreadyBeenBlocked
              ? CommonButton(
                  buttonText: "Yes, unblock this user",
                  buttonCallback: widget.performAction,
                )
              : blockButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget blockButton() {
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
          onPressed: widget.performAction,
          child:  Text(
            "Yes, Block this user",
            style: TextStyle(color: appColors.red),
          ),
        ),
      ),
    );
  }
}
