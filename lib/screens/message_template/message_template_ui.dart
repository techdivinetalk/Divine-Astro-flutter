import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/message_template/message_template_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/colors.dart';
import '../../common/routes.dart';
import '../../common/switch_component.dart';
import '../../model/message_template_response.dart';
import '../../utils/enum.dart';
import '../live_page/constant.dart';

class MessageTemplateUI extends GetView<MessageTemplateController> {
  const MessageTemplateUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("template".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'messageTemplate'.tr,
              style: AppTextStyle.textStyle20().copyWith(
                decoration: TextDecoration.underline,
                decorationColor: appColors.textColor,
                decorationThickness: 2,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  RouteName.addMessageTemplate,
                  arguments: [false, false],
                );
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: appColors.darkBlue),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                    child: Text(
                  'clickToAdd'.tr,
                  style: AppTextStyle.textStyle14(),
                )),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: GetBuilder<MessageTemplateController>(
                builder: (controller) {
                  if (controller.loading == Loading.loading ||
                      controller.messageTemplates.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(Colors.yellow),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: controller.messageTemplates.length,
                      primary: false,
                      shrinkWrap: true,
                      separatorBuilder: (_, index) => SizedBox(
                        height: 20.h,
                      ),
                      itemBuilder: (context, index) {
                        MessageTemplates messageTemplate =
                            controller.messageTemplates[index];
                        log("messages- -${messageTemplate.toJson().toString()}");

                        // Check if the template type is 0, auto-enable and save to preferences
                        if (messageTemplate.type == 0) {
                          // Check if it's already in messageLocalTemplates, to avoid duplication
                          final result =
                              controller.messageLocalTemplates.indexWhere(
                            (element) => element.id == messageTemplate.id,
                          );

                          // If it's not already in the list, add it
                          if (result == -1) {
                            controller.messageLocalTemplates
                                .add(messageTemplate);
                            messageTemplateList.value.add(messageTemplate);

                            // Save the state to shared preferences (always true for type == 0)
                            controller.saveBoolToPrefs(
                              messageTemplate.id.toString(),
                              true,
                            );

                            // Update the local templates list after adding
                            controller.updateMessageTemplateLocally();
                          }
                        }
                        return FutureBuilder(
                            future: controller.getBoolFromPrefs(
                                messageTemplate.id.toString()),
                            builder: (context, snapshot) {
                              bool switchBool = snapshot.data ?? false;

                              // Auto-enable switch if messageTemplate.type == 0
                              if (messageTemplate.type == 0) {
                                switchBool = true; // Force the switch to be ON
                              }
                              // Parse the DateTime from the backend string
                              DateTime dateTime = DateTime.parse(
                                  messageTemplate.createdAt ??
                                      DateTime.now().toString());

                              // Format the DateTime to "22 May 2024"
                              String formattedDate =
                                  DateFormat('dd MMMM yyyy').format(dateTime);

                              return GestureDetector(
                                onTap: () {
                                  if (messageTemplate.type != 0) {
                                    Get.toNamed(
                                      RouteName.addMessageTemplate,
                                      arguments: [false, true, messageTemplate],
                                    )!
                                        .then((value) {
                                      if (value == 1) {
                                        print("here is updating");
                                        controller
                                            .updateMessageTemplateLocally();
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: appColors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 1.0,
                                          offset: const Offset(0.0, 3.0)),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text('Template Name: ',
                                                    style: AppTextStyle
                                                        .textStyle14(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                SizedBox(width: 2.w),
                                                Flexible(
                                                  child: Text(
                                                      '${messageTemplate.message}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppTextStyle
                                                          .textStyle14(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                )
                                              ],
                                            ),
                                          ),
                                          messageTemplate.type == 0
                                              ? SwitchWidget(
                                                  onTap: () {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Not able to disable default template");
                                                  }, // Disable tap for type == 0
                                                  switchValue:
                                                      true, // Always ON for type == 0
                                                )
                                              : Row(
                                                  children: [
                                                    SizedBox(width: 6.w),
                                                    SwitchWidget(
                                                      onTap: () async {
                                                        // if (controller.offerTypeLoading.value !=
                                                        //     Loading.loading) {
                                                        // }
                                                        // controller.updateOfferType(
                                                        //   index: index,
                                                        //   offerId: controller.homeData?.offers?.orderOffer?[index].id ?? 0,
                                                        //   offerType: 1,
                                                        //   value: !controller.orderOfferSwitch[index],
                                                        // );
                                                        // controller.messageTemplates[index]
                                                        //     .isOn = !(controller
                                                        //         .messageTemplates[index]
                                                        //         .isOn ??
                                                        //     true);
                                                        final result = controller
                                                            .messageLocalTemplates
                                                            .indexWhere(
                                                          (element) =>
                                                              element.id ==
                                                              messageTemplate
                                                                  .id,
                                                        );
                                                        print("1 $result");
                                                        if (result != -1) {
                                                          print("2");
                                                          controller
                                                              .messageLocalTemplates
                                                              .removeWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      messageTemplate
                                                                          .id);
                                                          controller
                                                              .saveBoolToPrefs(
                                                                  messageTemplate
                                                                      .id
                                                                      .toString(),
                                                                  false);
                                                          messageTemplateList
                                                              .value
                                                              .remove(
                                                                  messageTemplate);
                                                        } else {
                                                          controller
                                                              .messageLocalTemplates
                                                              .add(
                                                                  messageTemplate);
                                                          messageTemplateList
                                                              .value
                                                              .add(
                                                                  messageTemplate);
                                                          controller
                                                              .saveBoolToPrefs(
                                                                  messageTemplate
                                                                      .id
                                                                      .toString(),
                                                                  true);
                                                        }
                                                        await controller
                                                            .updateMessageTemplateLocally();
                                                        controller.update();
                                                        messageTemplateList
                                                            .refresh();
                                                        sendBroadcast(
                                                            BroadcastMessage(
                                                                name:
                                                                    "template",
                                                                data: {}));
                                                      },
                                                      switchValue: switchBool,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      RichText(
                                          maxLines: 4,
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Display Message: ',
                                                style: AppTextStyle.textStyle14(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            TextSpan(
                                                text:
                                                    '${messageTemplate.description}',
                                                style:
                                                    AppTextStyle.textStyle14()),
                                          ])),
                                      SizedBox(height: 10.h),
                                      RichText(
                                          maxLines: 4,
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Created On: ',
                                                style: AppTextStyle.textStyle14(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            TextSpan(
                                                text:
                                                    "${formattedDate.toString()}",
                                                style:
                                                    AppTextStyle.textStyle14()),
                                          ])),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
