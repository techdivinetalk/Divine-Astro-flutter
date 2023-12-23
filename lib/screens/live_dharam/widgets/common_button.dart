import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.buttonText,
    required this.buttonCallback,
    super.key,
  });

  final String buttonText;
  final void Function() buttonCallback;

  @override
  Widget build(BuildContext context) {
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
        onPressed: buttonCallback,
        child: Text(
          buttonText,
          style: const TextStyle(color: AppColors.black),
        ),
      ),
    );
  }
}
