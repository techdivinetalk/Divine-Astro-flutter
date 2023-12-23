import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class EndSessionWidget extends StatefulWidget {
  const EndSessionWidget({
    required this.onClose,
    required this.continueLive,
    required this.endLive,
    super.key,
  });

  final void Function() onClose;
  final void Function() continueLive;
  final void Function() endLive;

  @override
  State<EndSessionWidget> createState() => _EndSessionWidgetState();
}

class _EndSessionWidgetState extends State<EndSessionWidget> {
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
          height: Get.height / 2.24,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              "assets/images/live_end_session.png",
            ),
          ),
          const SizedBox(height: 16 + 8),
          const Text("Are you Sure you want to end the Live Session?"),
          const SizedBox(height: 16 + 8),
          CommonButton(
            buttonText: "No, Continue the Live",
            buttonCallback: widget.continueLive,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.endLive,
            child: const Text(
              "End Live Session",
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
