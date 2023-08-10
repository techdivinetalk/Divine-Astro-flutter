import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'notice_detail_controller.dart';

class NoticeDetailUi extends GetView<NoticeDetailController> {
  const NoticeDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: "Sender category"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
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
  }) {
    return Container(
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
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
              Text(
                date ?? "",
                style: AppTextStyle.textStyle10(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
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
    );
  }
}
