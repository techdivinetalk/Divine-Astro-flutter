import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class KundliViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final   ChatMessage chatDetail;
  final bool yourMessage;
  KundliViewWidget({required this.chatDetail, required this.yourMessage, this.controller});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.kundliDetail, arguments: {
          "kundli_id": chatDetail.kundliId ?? chatDetail.kundli!.kundliId,
          "from_kundli": true,
          "birth_place":
          chatDetail.kundliPlace ?? chatDetail.kundli!.kundliPlace,
          "gender": chatDetail.gender ?? chatDetail.kundli!.gender,
          "name": chatDetail.kundliName ?? chatDetail.kundli!.kundliName,
          "longitude": chatDetail.longitude ?? chatDetail.kundli!.longitude,
          "latitude": chatDetail.latitude ?? chatDetail.kundli!.latitude,
        });
      },
      child: Card(
        color: appColors.white,
        surfaceTintColor: appColors.white,
        child: Container(
          padding: EdgeInsets.all(12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: appColors.extraLightGrey),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    chatDetail.kundliName?[0] ??
                        chatDetail.kundli?.kundliName[0] ??
                        '',
                    style: AppTextStyle.textStyle24(
                        fontColor: appColors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDetail.kundliName ??
                          chatDetail.kundli?.kundliName ??
                          "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliDateTime ??
                          chatDetail.kundli!.kundliDateTime,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        //color: appColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliPlace ??
                          chatDetail.kundli?.kundliPlace ??
                          "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: appColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
