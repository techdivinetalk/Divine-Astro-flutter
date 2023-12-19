import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CongratulationsWidget extends StatefulWidget {
  const CongratulationsWidget({
    required this.onClose,
    required this.imageURL,
    super.key,
  });

  final void Function() onClose;
  final String imageURL;

  @override
  State<CongratulationsWidget> createState() => _CongratulationsWidgetState();
}

class _CongratulationsWidgetState extends State<CongratulationsWidget> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: 100,
              child: CustomImageWidget(imageUrl: widget.imageURL, rounded: true),
            ),
            Positioned(
              bottom: -10,
              right: -10,
              child: Image.asset("assets/images/live_champion.png"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Congratulations!!"),
        const SizedBox(height: 16),
        const Text("You are now Astrologer's Live Star"),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
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
                    onPressed: widget.onClose,
                    child: const Text(
                      "Yay! Thank You",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
