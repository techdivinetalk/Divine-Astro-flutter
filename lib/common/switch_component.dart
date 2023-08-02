// ignore_for_file: must_be_immutable

import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchWidget extends StatelessWidget {
  bool? switchValue;
  Function? onTap;
  SwitchWidget({super.key, this.switchValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      inactiveTextColor: AppColors.darkGreen,
      activeTextColor: AppColors.darkGreen,
      width: 58.0,
      height: 28.0,
      toggleSize: 20.0,
      value: switchValue!,
      showOnOff: true,
      borderRadius: 30.0,
      padding: 2.0,
      valueFontSize: 12.0,
      // toggleColor: const Color.fromRGBO(225, 225, 225, 1),
      activeToggleColor: AppColors.appYellowColour,
      inactiveToggleColor: Colors.grey,
      toggleColor: AppColors.greyColour,
      switchBorder: Border.all(
        color: AppColors.darkGreen,
        width: 01.0,
      ),
      toggleBorder: Border.all(
        color: Colors.transparent,
        width: 1.0,
      ),
      activeColor: Colors.white,
      inactiveColor: Colors.white,
      onToggle: (val) {
        onTap!();
      },
    );
  }
}
