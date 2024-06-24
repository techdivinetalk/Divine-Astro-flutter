import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../pages/new_registration/new_registration_screen.dart';
import '../new_leave/new_leave_screen.dart';

class leaveAndResignationTab extends StatefulWidget {
  const leaveAndResignationTab({super.key});

  @override
  State<leaveAndResignationTab> createState() => _leaveAndResignationTabState();
}

class _leaveAndResignationTabState extends State<leaveAndResignationTab>
    with TickerProviderStateMixin {
  TabController? tabbarController;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    tabbarController = TabController(length: 2, vsync: this, initialIndex: 0);
    tabbarController?.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarSmall1(context, "Leave or Resignation"),
      body: Column(
        children: [
          Theme(
            data: ThemeData(useMaterial3: false),
            child: TabBar(
              controller: tabbarController,
              labelColor: appColors.blackColor,
              unselectedLabelColor: appColors.blackColor,
              labelStyle:
                  AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
              enableFeedback: true,
              indicatorColor: appColors.blackColor,
              indicatorWeight: 2,
              dividerColor: appColors.blackColor,
              unselectedLabelStyle:
                  AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
              tabs: [
                "Leave".tr,
                "Resignation".tr,
              ].map((e) => Tab(text: e)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabbarController,
              children: [
                NewLeaveScreen(),
                NewRegstrationScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

appbarSmall1(BuildContext context, String title,
    {PreferredSizeWidget? bottom, Color? backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors().white,
    bottom: bottom,
    forceMaterialTransparency: true,
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: IconButton(
        visualDensity: const VisualDensity(horizontal: -4),
        constraints: BoxConstraints.loose(Size.zero),
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    titleSpacing: 0,
    title: Text(
      title,
      style: AppTextStyle.textStyle16(),
    ),
    // centerTitle: true,
  );
}
