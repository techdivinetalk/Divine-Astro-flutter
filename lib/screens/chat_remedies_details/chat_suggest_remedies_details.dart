import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/screens/chat_remedies_details/chat_sugget_remedies_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatSuggestRemediesDetailsPage
    extends GetView<ChatSuggestRemedyDetailsController> {
  const ChatSuggestRemediesDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: CustomText("${controller.name.value.upperCamelCase} Remedies"),
      ),
      body: Obx(() {
        if (controller.remedies.value.remedies?.isEmpty ?? true) {
          return const GenericLoadingWidget();
        } else {
          return Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: (controller.remedies.value.remedies ?? []).length,
                itemBuilder: (context, index) {

                  return Obx(() {
                    print("above line ${controller.selectedIndex.obs}");
                    return card(index);
                  });
                },
              ).expand(),
              Visibility(
                visible: controller.selectedIndex.value != -1,
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      final remedy = controller.remedies.value.remedies![controller.selectedIndex.value];
                      List temp = [ remedy.name.upperCamelCase, remedy.content];
                      Get.back();
                      Get.back(result: temp);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            "Send Remedy",
                            style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.brownColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
      }),
    );
  }

  Widget card(index){
    final remedy = controller.remedies.value.remedies![index];
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedIndex.value == index ? AppColors.yellow : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          //tileColor: controller.selectedIndex == index ? AppColors.yellow : null,
          leading: CircleAvatar(
            backgroundColor: AppColors.red,
            child: CustomText(
              remedy.name[0].upperCamelCase,
              fontColor: AppColors.white,
            ), // Display the first letter of the name
          ),
          title: CustomText(
            remedy.name.upperCamelCase,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          subtitle: CustomText(
            remedy.content,
            fontSize: 12.sp,
            maxLines: 20,
          ),
          onTap: () {
            controller.selectedIndex(index).obs;
            controller.update();
          },
        ),
      ),
    );
  }
}
