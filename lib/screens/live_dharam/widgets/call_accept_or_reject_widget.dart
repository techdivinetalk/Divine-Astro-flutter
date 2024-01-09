import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_timer_countdown/flutter_timer_countdown.dart";
import "package:get/get.dart";

class CallAcceptOrRejectWidget extends StatefulWidget {
  const CallAcceptOrRejectWidget({
    required this.onClose,
    required this.needAcceptButton,
    required this.needDeclinetButton,
    required this.onAcceptButton,
    required this.onDeclineButton,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.isHost,
    required this.onTimeout,
    super.key,
  });

  final void Function() onClose;
  final bool needAcceptButton;
  final bool needDeclinetButton;
  final Function() onAcceptButton;
  final Function() onDeclineButton;
  final String userId;
  final String userName;
  final String avatar;
  final bool isHost;
  final Function() onTimeout;

  @override
  State<CallAcceptOrRejectWidget> createState() =>
      _CallAcceptOrRejectWidgetState();
}

class _CallAcceptOrRejectWidgetState extends State<CallAcceptOrRejectWidget> {
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
          // height: Get.height / 2.24,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: SizedBox(
            height: 100,
            width: 100,
            child: CustomImageWidget(
              imageUrl: widget.avatar,
              rounded: false,
              typeEnum: TypeEnum.user,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text("${widget.userName} wants to start the call"),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            if (widget.needAcceptButton)
              Expanded(
                child: CommonButton(
                  buttonText: "Accept",
                  buttonCallback: widget.onAcceptButton,
                ),
              )
            else
              const SizedBox(),
            SizedBox(
              width:
                  widget.needAcceptButton && widget.needDeclinetButton ? 16 : 0,
            ),
            if (widget.needDeclinetButton)
              Expanded(
                child: CommonButton(
                  buttonText: "Decline",
                  buttonCallback: widget.onDeclineButton,
                ),
              )
            else
              const SizedBox(),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        autoCloseOrDecline(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget autoCloseOrDecline() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Auto ${widget.isHost ? "close" : "decline"} in:"),
          const SizedBox(width: 4),
          newTimerWidget(),
        ],
      ),
    );
  }

  Widget newTimerWidget() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
      endTime: DateTime.now().add(
        const Duration(days: 0, hours: 0, minutes: 1, seconds: 0),
      ),
      onEnd: widget.onTimeout,
    );
  }
}
