// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/home_page_model_class.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../common/common_bottomsheet.dart';
import 'notice_detail_controller.dart';

class NoticeDetailUi extends GetView<NoticeDetailController> {
  const NoticeDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data;

    if (Get.parameters["from_list"] == "0") {
      data = Get.arguments as NoticeBoard;
    } else if (Get.parameters["from_list"] == "1") {
      data = Get.arguments as NoticeDatum;
    }
    return Scaffold(
      appBar: commonDetailAppbar(
        title: data.title.toString(),
        trailingWidget: Container(
          margin: EdgeInsets.only(right: 20.sp),
          child: Text(
            '${dateToString(data.createdAt ?? DateTime.now(), format: "h:mm a")}  '
                '${formatDateTime(data.createdAt ?? DateTime.now())} ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                data.description.toString(),
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
