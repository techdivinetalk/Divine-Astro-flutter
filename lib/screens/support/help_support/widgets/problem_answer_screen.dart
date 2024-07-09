import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../common/routes.dart';
import '../../../../repository/user_repository.dart';
import '../help_support_controller.dart';

class ProblemAnswerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(
      () => HelpSupportController(
        UserRepository(),
      ),
    );
  }
}

class ProblemAnswersScreen extends GetView<HelpSupportController> {
  ProblemAnswersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpSupportController>(
      init: HelpSupportController(UserRepository()),
      builder: (_) {
        return Scaffold(
          appBar: appbarSmall1(context, "Help & Support"),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14, bottom: 10, right: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.selectedAnswer['title'].toString(),
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textStyle14(
                        fontWeight: FontWeight.w600,
                        fontColor: appColors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14, bottom: 10, right: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.selectedAnswer['detail'].toString(),
                      textAlign: TextAlign.start,
                      // maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.black,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Still need help ?",
                    textAlign: TextAlign.center,
                    // maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        RouteName.chatSupportScreen,
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: appColors.guideColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1.0,
                            offset: const Offset(0.0, 3.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "Chat with us".tr,
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w600,
                              fontColor: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Wait time - 15 mins",
                    textAlign: TextAlign.center,
                    // maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.grey,
                    ),
                  ),
                ),
              ],
            ),
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
            onTap: () {},
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
              padding: EdgeInsets.only(top: 8, left: 12, right: 12),
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
