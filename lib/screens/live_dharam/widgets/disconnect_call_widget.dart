import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
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
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: CustomImageWidget(
                  imageUrl: widget.custoAvatar,
                  rounded: true,
                ),
              ),
              Image.asset(
                "assets/images/live_dashes.png",
                height: 50,
                width: 150,
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: CustomImageWidget(
                  imageUrl: widget.astroAvatar,
                  rounded: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Disconnect Call?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Are you Sure you want to disconnect the call with ${!widget.isAstro ? widget.astroUserName : widget.custoUserName}?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CommonButton(
            buttonText: "No, Continue the Call",
            buttonCallback: widget.noDisconnect,
          ),
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}
