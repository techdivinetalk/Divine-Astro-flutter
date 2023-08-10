// ignore_for_file: deprecated_member_use_from_same_package

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/appbar.dart';
import '../../common/colors.dart';
import '../../common/strings.dart';
import '../../gen/assets.gen.dart';
import '../side_menu/side_menu_ui.dart';
import 'chat_assistance_controller.dart';

class ChatAssistancePage extends GetView<ChatAssistanceController> {
  const ChatAssistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenuDrawer(),
      backgroundColor: AppColors.white,
      appBar: commonAppbar(
          title: "chatAssistance".tr,
          trailingWidget: InkWell(
            child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Assets.images.icSearch.svg(color: AppColors.darkBlue)),
          )),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemCount: 12,
        itemBuilder: (context, index) => ChatAssistanceTile(index: index),
      ),
    );
  }
}

class ChatAssistanceTile extends StatelessWidget {
  final int index;

  const ChatAssistanceTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.toNamed(RouteName.chatMessageUI);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: Assets.images.bgChatUserPro.image(
          fit: BoxFit.cover,
          height: 55.r,
          width: 55.r,
        ),
      ),
      title: Text(
        'Astrologer ${index + 1}',
      ),
      subtitle: Text(
        'Thank you for your help!',
        style: TextStyle(
          color: (index == 0) ? AppColors.blackColor : AppColors.greyColor,
          fontSize: 12.sp,
          fontWeight: (index == 0) ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '11:35 PM',
            style: AppTextStyle.textStyle12(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5.h),
          if (index == 0)
            CircleAvatar(
              radius: 10.r,
              backgroundColor: AppColors.lightYellow,
              child: Text(
                '2',
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brownColour),
              ),
            ),
        ],
      ),
    );
  }
}
