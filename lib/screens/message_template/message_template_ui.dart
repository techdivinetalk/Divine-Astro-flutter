import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/message_template/message_template_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/routes.dart';
import '../../common/switch_component.dart';
import '../../model/message_template_response.dart';
import '../../model/notice_response.dart';
import '../../utils/enum.dart';

class MessageTemplateUI extends GetView<MessageTemplateController> {
  const MessageTemplateUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("Template",
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
              'Message Template',
              style: AppTextStyle.textStyle20().copyWith(
                decoration: TextDecoration.underline,
                decorationColor: appColors.appColorDark,
                decorationThickness: 2,
              ), 
            ), 
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteName.addMessageTemplate,
                    arguments: [false, false]);
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
                  '+ Click here to add message template',
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
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteName.addMessageTemplate,
                                arguments: [false, true, messageTemplate]);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 1.0,
                                    offset: const Offset(0.0, 3.0)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text('Template Name: ',
                                              style: AppTextStyle.textStyle14(
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(width: 2.w),
                                          Flexible(
                                            child: Text(
                                                '${messageTemplate.message}',
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyle.textStyle14(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 6.w),
                                        SwitchWidget(
                                          onTap: () {
                                            // if (controller.offerTypeLoading.value !=
                                            //     Loading.loading) {
                                            // }
                                            // controller.updateOfferType(
                                            //   index: index,
                                            //   offerId: controller.homeData?.offers?.orderOffer?[index].id ?? 0,
                                            //   offerType: 1,
                                            //   value: !controller.orderOfferSwitch[index],
                                            // );
                                            messageTemplate.isOn =
                                                !messageTemplate.isOn!;
                                            controller.update();
                                          },
                                          switchValue: messageTemplate.isOn,
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
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text:
                                              '${messageTemplate.description}',
                                          style: AppTextStyle.textStyle14()),
                                    ])),
                                SizedBox(height: 10.h),
                                RichText(
                                    maxLines: 4,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Created On: ',
                                          style: AppTextStyle.textStyle14(
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text:
                                              '${formatDateTime(messageTemplate.createdAt ?? DateTime.now())} ',
                                          //'${messageTemplate.createdAt}',
                                          style: AppTextStyle.textStyle14()),
                                    ])),
                              ],
                            ),
                          ),
                        );
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
