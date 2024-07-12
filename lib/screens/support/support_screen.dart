import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/support/support_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/routes.dart';

class SupportScreen extends GetView<SupportController> {
  SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
      init: SupportController(UserRepository()),
      builder: (_) {
        return Scaffold(
          appBar: appbarSmall1(context, "Support Chat"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.tickets.isEmpty
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
                        itemCount: controller.tickets.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = controller.tickets[index];
                          return ticketWidget(data);
                        },
                      ),
                    ),
            ],
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Data Shown For last 3 days only".tr,
                        style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w400,
                          fontColor: appColors.appRedColour,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            RouteName.helpSupportScreen,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: appColors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "Create New Ticket".tr,
                                style: AppTextStyle.textStyle20(
                                  fontWeight: FontWeight.w600,
                                  fontColor: appColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ticketWidget(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
      child: Card(
        color: appColors.white,
        child: ListTile(
          title: Text(
            data['title'].toString(),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.textStyle16(
              fontWeight: FontWeight.w600,
              fontColor: appColors.black,
            ),
          ),
          subtitle: Text(
            data['date_time'].toString(),
            style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w400,
              fontColor: appColors.grey,
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: appColors.guideColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                data['status'].toString(),
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: appColors.white,
                ),
              ),
            ),
          ),
        ),
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
