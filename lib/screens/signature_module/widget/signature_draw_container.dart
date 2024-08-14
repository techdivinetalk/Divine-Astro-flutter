import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../common/colors.dart';

class SignatureDrawContainer extends StatelessWidget {
  final Key? signatureKey;
  final Color? strokeColor;
  final Color? backgroundColor;
  final Color? ContainerColor;
  final double? maximumStrokeWidth;
  final double? minimumStrokeWidth;
  final String? backgroundImage;
  final Function(Offset, DateTime)? onDraw;
  final Function()? onTap;
  final ScreenshotController? screenshotController;
  final bool isFileImage;
  final List<Color>? colors;
  final bool isRadius;


  const SignatureDrawContainer({
    this.signatureKey,
    this.screenshotController,
    this.strokeColor,
    this.backgroundColor,
    this.maximumStrokeWidth,
    this.backgroundImage = "",
    this.minimumStrokeWidth,
    this.onTap,
    this.colors,
    this.onDraw,
    this.isRadius = true,
    this.ContainerColor,
    this.isFileImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: appColors.guideColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Screenshot(
            controller: screenshotController!,
            child: Container(
              decoration: BoxDecoration(
                color: ContainerColor ?? Colors.white,
                borderRadius: BorderRadius.circular(isRadius ? 10 : 0.0),
                // image: backgroundImage != "" ? isFileImage ? DecorationImage(
                //     image: FileImage(File(backgroundImage!))
                // ) : DecorationImage(
                //     image: AssetImage(backgroundImage!),
                //     fit: BoxFit.fill,
                //   ) : null,
                // gradient: colors != null ? LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: colors!
                // ) : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SfSignaturePad(
                  key: signatureKey,
                  maximumStrokeWidth: maximumStrokeWidth ?? 3,
                  minimumStrokeWidth: minimumStrokeWidth ?? 3,
                  strokeColor: strokeColor ?? appColors.guideColor,
                  backgroundColor: backgroundImage == "" ? backgroundColor ?? Color(0xffFFFFFF) : null,
                  onDraw: onDraw,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
