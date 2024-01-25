import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/notice_response.dart';

class FeedbackCardWidget extends StatelessWidget {
  const FeedbackCardWidget({super.key, required this.feedback});

  final FeedbackData feedback;

  @override
  Widget build(BuildContext context) {
    print("FeedbackData: ${feedback.order?.orderId}");
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(14.r)),
      child: Material(
        color: AppColors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.h).copyWith(bottom: 14.h),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(14.r)),
              border: Border.all(color: AppColors.red, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Feedback Available',
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500, fontColor: AppColors.red),
                  ),
                  Text(
                    'New',
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      feedback.order?.productType == 12 ? Assets.svg.message.svg(height: 12.h, width: 12.h) :Assets.svg.icCall1.svg(height: 12.h, width: 12.h),
                      SizedBox(width: 8.w),
                      Text(
                        'ID : ${feedback.orderId}',
                        style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        feedback.createdAt != null ? "${dateToString(feedback.createdAt!, format: "h:mm a")} ${formatDateTime(feedback.createdAt!)}" : "NA",
                        style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Html(
                data: feedback.remark ?? '',
                onLinkTap: (url, __, ___) {
                  launchUrl(Uri.parse(url ?? ''));
                },
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteName.feedback, arguments: {
                    'order_id': feedback.orderId,
                    'product_type': feedback.order?.productType,
                  });
                },
                child: Text('Read More',
                  style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.red,
                  ).copyWith(decoration: TextDecoration.underline),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
