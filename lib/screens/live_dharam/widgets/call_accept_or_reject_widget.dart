import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CallAcceptOrRejectWidget extends StatefulWidget {
  const CallAcceptOrRejectWidget({
    required this.onClose,
    required this.needAcceptButton,
    required this.needDeclinetButton,
    required this.onAcceptButton,
    required this.onDeclineButton,
    super.key,
  });

  final void Function() onClose;
  final bool needAcceptButton;
  final bool needDeclinetButton;
  final Function() onAcceptButton;
  final Function() onDeclineButton;

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
          height: Get.height / 1.50,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            widget.needAcceptButton
                ? Expanded(
                    child: commonButton(
                      buttonText: "Accept",
                      onPressed: widget.onAcceptButton,
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width:
                  widget.needAcceptButton && widget.needDeclinetButton ? 16 : 0,
            ),
            widget.needDeclinetButton
                ? Expanded(
                    child: commonButton(
                      buttonText: "Decline",
                      onPressed: widget.onDeclineButton,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }

  Widget commonButton({
    required String buttonText,
    required Function() onPressed,
  }) {
    return SizedBox(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.appYellowColour,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(color: AppColors.black),
        ),
      ),
    );
  }
}
