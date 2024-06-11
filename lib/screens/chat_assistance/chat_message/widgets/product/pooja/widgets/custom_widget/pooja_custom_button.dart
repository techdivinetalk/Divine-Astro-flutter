import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class PoojaCustomButton extends StatelessWidget {
  final double height;
  final String text;
  final Color backgroundColor;
  final Color fontColor;
  final bool needCircularBorder;
  final void Function() onPressed;

  const PoojaCustomButton({
    super.key,
    required this.height,
    required this.text,
    required this.backgroundColor,
    required this.fontColor,
    required this.needCircularBorder,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: needCircularBorder
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.metropolis,

          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
