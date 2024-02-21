import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:flutter_timer_countdown/flutter_timer_countdown.dart";
import "package:get/get.dart";

class WaitingForUserToSelectCards extends StatefulWidget {
  const WaitingForUserToSelectCards({
    required this.onClose,
    required this.userName,
    required this.onTimeout,
    super.key,
  });

  final void Function() onClose;
  final String userName;
  final Function() onTimeout;

  @override
  State<WaitingForUserToSelectCards> createState() =>
      _WaitingForUserToSelectCardsState();
}

class _WaitingForUserToSelectCardsState
    extends State<WaitingForUserToSelectCards> {
  
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
          // height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white.withOpacity(0.2),
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
          Text(
            "Waiting For User to Select Cards",
            style: TextStyle(fontSize: 20, color: appColors.white),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: appColors.white),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: ListTile(
              title: Text(
                widget.userName,
                style: TextStyle(fontSize: 20, color: appColors.white),
              ),
              subtitle: newTimerWidget(),
              trailing: SizedBox(height: 50, width: 100, child: button()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all(appColors.guideColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
      onPressed: () {},
      child: Icon(
        Icons.more_horiz,
        color: appColors.black,
        size: 50,
      ),
    );
  }

  Widget newTimerWidget() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      endTime: DateTime.now().add(
        const Duration(days: 0, hours: 0, minutes: 1, seconds: 0),
      ),
      onEnd: widget.onTimeout,
    );
  }
}
