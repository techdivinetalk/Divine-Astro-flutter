import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/astrr_feedback_details.dart';
import 'package:flutter/material.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackCallChatCardWidget extends StatelessWidget {
  final FeedbackProblem? feedbackProblem;

  const FeedbackCallChatCardWidget({super.key, this.feedbackProblem});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       /* Text(
          'Problem #${feedbackProblem!.id}',
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),*/
       /* Text(
          'Total Problems: ${feedbackProblem?.totalProblem ?? 0}',
          style: AppTextStyle.textStyle14(),
        ),
        SizedBox(height: 10.h),*/
        Text(
          'Problem: ${feedbackProblem?.problem}',
          style: AppTextStyle.textStyle14(fontColor: AppColors.red),
        ),
        SizedBox(height: 10.h),
        Text(
          'Solution: ${feedbackProblem?.solution}',
          style: AppTextStyle.textStyle14(fontColor: AppColors.darkGreen),
        ),
      ],
    );
  }
}
