import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ExitWaitListWidget extends StatefulWidget {
  const ExitWaitListWidget({
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
  State<ExitWaitListWidget> createState() => _ExitWaitListWidgetState();
}

class _ExitWaitListWidgetState extends State<ExitWaitListWidget> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: CustomImageWidget(
                  imageUrl: widget.custoAvatar,
                  rounded: true,
                  typeEnum: TypeEnum.user,
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
                  typeEnum: TypeEnum.user,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Wait!!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Are you sure you want to exit the wait list? Our Astrologer (${widget.astroUserName}) will soon be in touch with you.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CommonButton(
            buttonText: "Okay, Keep in Wait List",
            buttonCallback: widget.noDisconnect,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.yesDisconnect,
            child: const Text(
              "Exit Wait List",
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
}
