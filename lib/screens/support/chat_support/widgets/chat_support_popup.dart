import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/support/chat_support/chat_support_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';

class ChatSupportPopup extends GetView<ChatSupportController> {
  ChatSupportPopup({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<ChatSupportController>(
        init: ChatSupportController(UserRepository()),
        initState: (_) {},
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Ticket Closed!",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors().appRedColour,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Divider(
                    color: AppColors().extraLightGrey,
                    thickness: 0.8,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Our executive has closed your ticket. We hope your query has been resolved. If not, you can reopen the ticket",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle14(
                    fontWeight: FontWeight.w400,
                    fontColor: AppColors().grey,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: appColors.appRedColour,
                            border: Border.all(
                                color: AppColors().appRedColour, width: 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Re-Open".tr,
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w600,
                                  fontColor: appColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            // color: appColors.guideColor,

                            border:
                                Border.all(color: AppColors().black, width: 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Close".tr,
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w600,
                                  fontColor: appColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
