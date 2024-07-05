
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';

class RemediesViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  RemediesViewWidget({required this.chatDetail, required this.yourMessage, this.controller});


  @override
  Widget build(BuildContext context) {
    var jsonString = (chatDetail.message ?? '')
        .substring(1, (chatDetail.message ?? '').length - 1);
    List temp = jsonString.split(', ');

    print("message:: $temp");

    if (temp.length < 2) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.textColor.withOpacity(0.4),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          // leading: CircleAvatar(
          //   backgroundColor: appColors.red,
          //   child: CustomText(
          //     temp[0][0],
          //     fontColor: appColors.white,
          //   ), // Display the first letter of the name
          // ),
          title: CustomText(
            temp[0],
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(temp.length, (index) {
              return GestureDetector(
                  onTap: () => Get.toNamed(RouteName.remediesDetail,
                      arguments: {'title': temp[0], 'subtitle': jsonString}),
                  child: CustomText(temp[index], fontSize: 12.sp));
            }),
          ),
        ),
      ),
    );
  }
}
