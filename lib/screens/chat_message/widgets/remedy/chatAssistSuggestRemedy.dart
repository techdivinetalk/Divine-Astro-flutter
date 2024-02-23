import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/screens/chat_remedies/chat_suggest_remedies_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatAssistSuggestRemedyController.dart';

class ChatAssistSuggestRemedyPage extends GetView<ChatAssistSuggestRemedyController> {
  const ChatAssistSuggestRemedyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.white,
        surfaceTintColor: appColors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const CustomText('Suggest Remedies'),
      ),
      body: Obx(() {
        if (controller.remedies.value.remedies?.isEmpty ?? true) {
          return const GenericLoadingWidget();
        } else {
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: (1 / .4),
            ),
            itemCount: (controller.remedies.value.remedies ?? []).length,
            itemBuilder: (context, index) {
              final remedy = controller.remedies.value.remedies![index];
              final isLeftSide = index % 2 == 0; // Check if the item is on the left side

              return ElevatedButton(
                onPressed: () =>  Get.toNamed(RouteName.chatSuggestRemedyDetails, arguments: {'remedy': remedy}),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: isLeftSide ? appColors.lightBlack : appColors.black,),
                  ),
                ),
                child: CustomText(
                  remedy.name.upperCamelCase,
                  fontSize: 16.sp,
                ),
              );
            },
          );
        }
      }),
    );
  }
}

