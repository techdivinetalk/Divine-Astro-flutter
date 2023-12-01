import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/utils/enum.dart';
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
      body: Padding(
        padding: EdgeInsets.only(
          left: 20.sp,
          right: 20.sp,
          top: 10.sp,
        ),
        child: GetBuilder<NoticeBoardController>(
          builder: (controller) {
            if (controller.loading == Loading.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(Colors.yellow),
                ),
              );
            }

            if (controller.loading == Loading.loaded) {
              return ListView.builder(
                controller: controller.earningScrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.noticeList.length,
                itemBuilder: (context, index) {
                  Widget separator = SizedBox(height: 15.sp);
                  final data = controller.noticeList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      noticeBoardDetail(
                        onTap: () {
                          Get.toNamed(RouteName.noticeDetail,
                              arguments: data, parameters: {"from_list": "1"});
                        },
                        title: data.title.toString(),
                        date: data.getTimeAndDate(),
                        description: data.description.toString(),
                      ),
                      separator,
                    ],
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget noticeBoardDetail({
    required String? title,
    required String? date,
    required String? description,
    required VoidCallback? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              border: Border.all(color: AppColors.lightYellow)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
