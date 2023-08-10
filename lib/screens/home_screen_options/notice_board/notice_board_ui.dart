import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'notice_board_controller.dart';

class NoticeBoardUi extends GetView<NoticeBoardController> {
  const NoticeBoardUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: "noticeBoard".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ListView.builder(
                controller: controller.earningScrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  Widget separator = const SizedBox(height: 30);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      noticeBoardDetail(
                          ontap: () {
                            Get.toNamed(RouteName.noticeDetail);
                          },
                          title: "Sender Category",
                          date: "07:16 pm  23/06/2023",
                          description:
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and"),
                      separator,
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget noticeBoardDetail({
    required String? title,
    required String? date,
    required String? description,
    required VoidCallback? ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(color: AppColors.lightYellow)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.darkBlue),
                ),
                Text(
                  date ?? "",
                  style: AppTextStyle.textStyle10(
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.darkBlue),
                )
              ],
            ),
            const SizedBox(height: 10),
            ReadMoreText(
              description ?? "",
              trimLines: 4,
              colorClickableText: AppColors.blackColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: "readMore".tr,
              trimExpandedText: "showLess".tr,
              moreStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              lessStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
