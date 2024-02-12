// ignore_for_file: must_be_immutable

import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchWidget extends StatelessWidget {
  bool? switchValue;
  Function? onTap;
  String? onText, offText;
  double? width;
  double? height;
  SwitchWidget(
      {super.key,
      this.switchValue,
      this.onTap,
      this.onText,
      this.offText,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      inactiveTextColor: appColors.darkBlue,
      activeTextColor: appColors.darkBlue,
      width: width ?? 58.0,
      height: height ?? 28.0,
      toggleSize: 20.0,
      value: switchValue!,
      showOnOff: true,
      borderRadius: 30.0,
      padding: 2.0,
      activeText: onText ?? "On",
      inactiveText: offText ?? "Off",
      valueFontSize: 12.0,
      activeTextFontWeight: FontWeight.w400,
      inactiveTextFontWeight: FontWeight.w400,
      activeToggleColor: appColors.appYellowColour,
      inactiveToggleColor: Colors.grey,
      toggleColor: appColors.greyColour,
      switchBorder: Border.all(
        color: appColors.darkBlue,
        width: 01.0,
      ),
      toggleBorder: Border.all(
        color: Colors.transparent,
        width: 1.0,
      ),
      activeColor: Colors.white,
      inactiveColor: Colors.white,
      onToggle: (val) => onTap!(),
    );
  }
}
