
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final NewChatController? controller;

  const ChatAppBarWidget({this.controller});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: appColors.transparent,
      leadingWidth: 30,
      leading: IconButton(
        onPressed: () {
          /// back method
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: appColors.black,
        ),
      ),
      title: Row(
        children: [
          const SizedBox(width: 10),
          Obx(
            () {
              Map<String, dynamic> order = {};
              order = AppFirebaseService().orderData.value;
              String imageURL = order["astroImage"] ?? "";
              String appended =
                  "${controller!.preference.getAmazonUrl()}$imageURL";
              print("img:: -xx-$appended");
              return GestureDetector(
                onTap: () {
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: appColors.guideColor),
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageWidget(
                    imageUrl: appended,
                    rounded: true,
                    typeEnum: TypeEnum.user,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Flexible(
            child: InkWell(
              onTap: () {
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          AppFirebaseService()
                                  .orderData
                                  .value["astrologerName"] ??
                              'Astrologer Name',
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: appColors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller!.showTalkTime.value == "-1"
                              ? "Chat Ended"
                              : "00:00:00",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: appColors.guideColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Chat in Progress",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commonRowForPopUpMenu({  IconData? icon,String? title}){
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(
        icon,
        size: 20,
        color: appColors.red,
      ),
      const SizedBox(width: 3),
      Text(
        title ?? "",
        style: AppTextStyle.textStyle13(),
      )
    ]);
  }
}
