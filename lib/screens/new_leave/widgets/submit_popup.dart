import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../new_leave_controller.dart';

Future<void> showLeavePopupAlert() async {
  return Get.dialog(
    barrierDismissible: true,
    Theme(
      data: ThemeData(canvasColor: AppColors().transparent),
      child: AlertDialog(
        backgroundColor: AppColors().white,
        insetPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0,
        content: StartPopUp(),
      ),
    ),
  );
}

class StartPopUp extends GetView<NewLeaveController> {
  StartPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<NewLeaveController>(
        init: NewLeaveController(UserRepository()),
        initState: (_) {},
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomImageView(
                    height: 40,
                    width: 40,
                    imagePath: "assets/images/done.png",
                    radius: BorderRadius.circular(10),
                    placeHolder: "assets/images/default_profiles.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Thank You For Informing",
                    style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors().black,
                    ).copyWith(fontFamily: "Metropolis"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
