import 'dart:io';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonDialogue{

  serverMaintenancePopUp(){
    showDialog(
      context: Get.context!,
      barrierColor: appColors.black.withOpacity(0.8),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            contentPadding: EdgeInsets.all(20.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: Image.asset("assets/images/server_maintainance.png"),
                ),
                SizedBox(height: 5.0,),
                Text(
                  "Server Under Maintenance",
                  style: AppTextStyle.textStyle20(
                      fontColor: appColors.red,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5.0,),
                Text(
                  "We're currently performing scheduled maintenance to improve our services.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle14(
                      fontColor: appColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.0,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(appColors.guideColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                      "Exit App",
                      style:  TextStyle(
                        color: appColors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}