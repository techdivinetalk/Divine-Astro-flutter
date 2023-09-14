import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_textstyle.dart';

PreferredSizeWidget commonAppbar(
    {String? title = "", required Widget? trailingWidget}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    backgroundColor: AppColors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.blackColor),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? "",
          style: AppTextStyle.textStyle16(
            fontWeight: FontWeight.w400,
            fontColor: AppColors.darkBlue,
          ),
        ),
      ],
    ),
    actions: [trailingWidget!],
  );
}

PreferredSizeWidget commonDetailAppbar(
    {String? title = "", Widget? trailingWidget}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    backgroundColor: AppColors.white,
    elevation: 0,
    centerTitle: false,
    leading: InkWell(
        onTap: () {
          Navigator.pop(Get.context!);
        },
        child: const Icon(Icons.arrow_back_ios)),
    iconTheme: const IconThemeData(color: AppColors.blackColor),
    title: Text(
      title ?? "",
      style: AppTextStyle.textStyle16(
          fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
    ),
    actions: [trailingWidget ?? Container()],
  );
}
