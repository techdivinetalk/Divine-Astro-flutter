import 'package:divine_astrologer/model/feedback_response.dart';
import 'package:divine_astrologer/screens/order_feedback/order_feedback_controller.dart';
import 'package:divine_astrologer/screens/order_feedback/widget/feedback_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/appbar.dart';
import '../../common/colors.dart';

class OrderFeedbackUI extends GetView<OrderFeedbackController> {
  const OrderFeedbackUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(
        title: "All Order Feedback",
        trailingWidget: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              border: Border.all(color: AppColors.red, width: 1),
            ),
            child: Text(
              'Need Help ?',
              style: AppTextStyle.textStyle12(
                fontColor: AppColors.red,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemBuilder: (context, index) {
          FeedbackData feedback = controller.feedbacks[index];
          return FeedbackCardWidget(feedback: feedback);
        },
        itemCount: controller.feedbacks.length,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
      ),
    );
  }
}
