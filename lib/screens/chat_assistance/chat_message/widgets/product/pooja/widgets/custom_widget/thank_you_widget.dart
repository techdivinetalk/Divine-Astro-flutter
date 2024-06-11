import "dart:ui";

import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../../../../../common/colors.dart";
import "../../../../../../../live_dharam/widgets/common_button.dart";


class ThankYouWidget extends StatefulWidget {
  const ThankYouWidget({
    required this.onClose,
    required this.openOrderHistory,
    super.key,
  });

  final Function() onClose;
  final Function() openOrderHistory;

  @override
  State<ThankYouWidget> createState() => _ThankYouWidgetState();
}

class _ThankYouWidgetState extends State<ThankYouWidget> {
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
            "assets/images/pooja_thank_you.png",
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            "Thank You For Your Purchase!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          CommonButton(
            buttonText: "Go to Order History",
            buttonCallback: widget.openOrderHistory,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
