import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_textstyle.dart';

PreferredSizeWidget commonAppbar(
    {String? title = "", required Widget? trailingWidget, Widget? leading}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    backgroundColor: appColors.white,
    elevation: 0,
    centerTitle: false,
    iconTheme:  IconThemeData(color: appColors.blackColor),
    leading: leading,
    titleSpacing: 0,
    title: Text(
      title ?? "",
      style: AppTextStyle.textStyle16(
        fontWeight: FontWeight.w400,
        fontColor: appColors.darkBlue,
      ),
    ),
    actions: [trailingWidget!],
  );
}

PreferredSizeWidget commonDetailAppbar(
    {String? title = "", Widget? trailingWidget,Function()? onTap}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    backgroundColor: appColors.white,
    elevation: 0,
    titleSpacing: 0,
    centerTitle: false,
    leading: InkWell(
        onTap: onTap ??() => Get.back(),
        child: const Icon(Icons.arrow_back_ios)),
    iconTheme:  IconThemeData(color: appColors.blackColor),
    title: Text(
      title ?? "",
      style: AppTextStyle.textStyle16(
          fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
    ),
    actions: [trailingWidget ?? Container()],
  );
}
