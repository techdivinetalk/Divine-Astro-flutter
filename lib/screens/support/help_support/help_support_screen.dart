import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import 'help_support_controller.dart';

class HelpSupportScreen extends GetView<HelpSupportController> {
  HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpSupportController>(
      init: HelpSupportController(UserRepository()),
      builder: (_) {
        return Scaffold(
          appBar: appbarSmall1(context, "Help & Support"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.problems.isEmpty
                  ? Center(
                      child: Text(
                        "No Tickets Here".tr,
                        style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w400,
                          fontColor: appColors.grey,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.problems.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = controller.problems[index];
                          return problemWidget(data, context);
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  problemWidget(data, context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              controller.selectProblemFun(data);
              Get.toNamed(
                RouteName.supportQuestionScreen,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    data['title'].toString(),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.textStyle14(
                      fontWeight: FontWeight.w600,
                      fontColor: appColors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.black,
                  size: 15,
                )
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Divider()),
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