import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/remedy_view/remedies_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemediesDetailPage extends GetView<RemediesDetailController> {

  const RemediesDetailPage({super.key});


  @override
  Widget build(BuildContext context) {
    // Extract arguments if passed
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final String title = arguments['title'] ?? '';
    final String subtitle = arguments['subtitle'] ?? '';

    // Initialize the controller with data
    controller.init(title, subtitle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: CustomText(controller.title.value),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:  AppColors.yellow ,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.red,
                child: CustomText(
                  controller.title.value[0],
                  fontColor: AppColors.white,
                ), // Display the first letter of the name
              ),
              title: CustomText(
                controller.title.value,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              subtitle: CustomText(
                controller.subtitle.value,
                fontSize: 12.sp,
                maxLines: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}