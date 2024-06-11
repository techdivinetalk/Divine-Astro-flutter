import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../chat_assistant_message_controller.dart';


voucherPopUp(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GetBuilder<ChatMessageController>(builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(color: appColors.darkBlue),
                      color: appColors.darkBlue),
                  child: Icon(
                    Icons.close_rounded,
                    color: appColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50.0)),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    voucherPopUpTitle(),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: controller.voucherList.length,
                        itemBuilder: (context, index) {
                          final voucher = controller.voucherList[index];
                          return InkWell(
                            onTap: () {
                              controller.selectedVoucher(voucher);
                              controller.update();
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: controller.selectedVoucher['id'] ==
                                        voucher['id']
                                    ? Border.all(color: appColors.guideColor)
                                    : Border.all(color: appColors.transparent),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    voucher['name'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: appColors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    voucher['description'],
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        height: 50,
                        padding: EdgeInsets.zero,
                        minWidth: MediaQuery.sizeOf(context).width,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        onPressed: () {
                          if (controller.selectedVoucher.isNotEmpty) {
                            Get.back(result: controller.selectedVoucher.value);
                          }
                        },
                        color: appColors.guideColor,
                        child: Text(
                          "Send",
                          style: TextStyle(
                              color: appColors.brownColour,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        });
      },
      context: context);
}

Widget voucherPopUpTitle() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.svg.gift.svg(),
        const SizedBox(width: 5),
        Text(
          'voucherPopUpTitle'.tr,
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
