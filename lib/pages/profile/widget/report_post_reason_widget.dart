import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/custom_widgets.dart';
import '../../../gen/assets.gen.dart';

class ReportPostReasons extends StatefulWidget {
  final String reviewID;
  final ProfilePageController? controller;

  const ReportPostReasons(this.reviewID, {super.key, this.controller});

  @override
  State<ReportPostReasons> createState() => _ReportPostReasonsState();
}

class _ReportPostReasonsState extends State<ReportPostReasons> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: appColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: appColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              children: [
                Assets.images.report.svg(),
                SizedBox(height: 20.h),
                CustomText("${'reportingQue'.tr}?",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: appColors.darkBlue),
                SizedBox(height: 20.h),
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeRight: true,
                  removeLeft: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.controller!.reportReason.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var report = widget.controller!.reportReason[index];
                      return Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                  widget.controller!.reportReviews(
                                      report.first, widget.reviewID);
                                },
                                child: Text(
                                  report.first.tr,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.textStyle15(
                                      fontColor: appColors.darkBlue,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}