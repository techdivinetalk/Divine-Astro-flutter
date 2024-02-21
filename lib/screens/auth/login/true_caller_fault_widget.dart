import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class TrueCallerFaultWidget extends StatefulWidget {
  const TrueCallerFaultWidget({
    required this.onClose,
    super.key,
  });

  final void Function() onClose;

  @override
  State<TrueCallerFaultWidget> createState() => _TrueCallerFaultWidgetState();
}

class _TrueCallerFaultWidgetState extends State<TrueCallerFaultWidget> {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          Image.asset(
            "assets/images/true_caller_icon.png",
            height: 50,
            width: 50,
          ),
          const SizedBox(height: 16),
          const Text(
            "Oops, seems like you're not logged-in in the TrueCaller App. Please ensure that you're logged-in in the TrueCaller App.",
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
