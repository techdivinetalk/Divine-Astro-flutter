import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CannotSpendMoneyWidget extends StatefulWidget {
  const CannotSpendMoneyWidget({
    required this.onClose,
    required this.isForWaitList,
    required this.isForCall,
    super.key,
  });

  final Function() onClose;
  final bool isForWaitList;
  final bool isForCall;

  @override
  State<CannotSpendMoneyWidget> createState() => _CannotSpendMoneyWidgetState();
}

class _CannotSpendMoneyWidgetState extends State<CannotSpendMoneyWidget> {
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
        children: <Widget>[
          const SizedBox(height: 32),
          Image.asset(
            "assets/images/live_cannot_spend.png",
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isForWaitList
                ? "You can only spend your money once you're off the waitlist or after calling."
                : widget.isForCall
                    ? "You can spend your money once the call ends."
                    : "",
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
