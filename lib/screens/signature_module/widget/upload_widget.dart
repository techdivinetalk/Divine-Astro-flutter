import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/generated/assets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadWidget extends StatelessWidget {
  final Function()? onTap;
  final Function()? removeOnTap;
  final String? title;
  final double? height;
  final String? imageFile;

  const UploadWidget(
      {super.key,
      this.onTap,
      this.height,
      this.title,
      this.imageFile,
      this.removeOnTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [4],
      strokeWidth: 2,
      color: appColors.guideColor,
      child: Container(
        height: height ?? 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: imageFile == null || imageFile == ""
              ? Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.addPhoto,height: 40,),
                      SizedBox(height: 3),
                      CustomText(
                        "Upload here",
                        fontSize: 12,
                      ),
                    ],
                  ),
                )
              : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imageFile!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    GestureDetector(
                      onTap: removeOnTap,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
