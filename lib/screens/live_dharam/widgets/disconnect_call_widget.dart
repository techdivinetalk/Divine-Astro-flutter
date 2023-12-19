import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class DisconnectWidget extends StatefulWidget {
  const DisconnectWidget({
    required this.onClose,
    required this.noDisconnect,
    required this.yesDisconnect,
    required this.isAstro,
    required this.astroAvatar,
    required this.astroUserName,
    required this.custoAvatar,
    required this.custoUserName,
    super.key,
  });

  final Function() onClose;
  final Function() noDisconnect;
  final Function() yesDisconnect;
  final bool isAstro;
  final String astroAvatar;
  final String astroUserName;
  final String custoAvatar;
  final String custoUserName;

  @override
  State<DisconnectWidget> createState() => _DisconnectWidgetState();
}

class _DisconnectWidgetState extends State<DisconnectWidget> {
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
          height: Get.height / 2.00,
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
    final String userName =
        !widget.isAstro ? widget.astroUserName : widget.custoUserName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              CustomImageWidget(imageUrl: widget.custoAvatar, rounded: true),
              const SizedBox(width: 16),
              Image.asset(
                "assets/images/live_dashes.png",
                height: 50,
                width: 150,
              ),
              const SizedBox(width: 16),
              CustomImageWidget(imageUrl: widget.astroAvatar, rounded: true),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Disconnect Call?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text("Are you Sure you want to disconnect the call with $userName?"),
          const SizedBox(height: 16),
          commonButton(
            buttonText: "No, Continue the Call",
            onPressed: widget.noDisconnect,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.yesDisconnect,
            child: const Text(
              "Disconnect the call",
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget commonButton({
    required String buttonText,
    required Function() onPressed,
  }) {
    return SizedBox(
      height: 60,
      width: double.infinity,
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
