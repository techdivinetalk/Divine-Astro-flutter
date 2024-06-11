import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final bool showBorder;
  final double textSize;

  const CommonElevatedButton({
    super.key,
    required this.text,
    this.width = double.infinity,
    this.height = 50.0,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 16,
    this.showBorder = true,
    this.borderColor = Colors.blue,
    required this.onPressed,  this.textSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: showBorder ? borderColor : Colors.transparent),
          ),
        ),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
          color: textColor,
          fontSize: textSize,
          fontWeight: FontWeight.w400)
        ),
      ),
    );
  }
}
