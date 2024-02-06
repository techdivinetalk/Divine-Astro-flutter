import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class WaitingForUserToSelectCards extends StatefulWidget {
  const WaitingForUserToSelectCards({
    required this.onClose,
    required this.userName,
    super.key,
  });

  final void Function() onClose;
  final String userName;

  @override
  State<WaitingForUserToSelectCards> createState() =>
      _WaitingForUserToSelectCardsState();
}

class _WaitingForUserToSelectCardsState
    extends State<WaitingForUserToSelectCards> {
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
          // height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.yellow),
            color: AppColors.white.withOpacity(0.2),
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
          const Text(
            "Waiting For User to Select Cards",
            style: TextStyle(fontSize: 20, color: AppColors.white),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: ListTile(
              title: Text(
                widget.userName,
                style: const TextStyle(fontSize: 20, color: AppColors.white),
              ),
              subtitle: const Text(
                "05 M 30 S",
                style: TextStyle(color: AppColors.white),
              ),
              trailing: SizedBox(height: 50, width: 100, child: button()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all(AppColors.yellow),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
      onPressed: () {},
      child: const Icon(
        Icons.more_horiz,
        color: AppColors.black,
        size: 50,
      ),
    );
  }
}