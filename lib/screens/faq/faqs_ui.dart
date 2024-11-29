import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/screens/faq/faqs_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_ui.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FAQsUI extends GetView<FAQsController> {
  const FAQsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColors.white,
          surfaceTintColor: appColors.white,
          leading:
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title:  CustomText('faq'.tr)),
      body: Obx(
        () => AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              controller.loading == Loading.loaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          secondChild: const GenericLoadingWidget(),
          firstChild: (controller.loading == Loading.loaded && controller.faqsResponse.value.data!.isEmpty)
              ? noDataWidget()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: (controller.faqsResponse.value.data ?? []).length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Material(
                        color: appColors.transparent,
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              initiallyExpanded: index == 0,
                              title: CustomText(controller.faqsResponse.value.data?[index].question ?? '', maxLines: 2, fontSize: 13,),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 8.h),
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 1, color: appColors.darkBlue.withOpacity(0.1)),
                                SizedBox(height: 8.h),
                                ExpandableHtmlView(
                                  htmlData:
                                  controller.faqsResponse.value.data?[index].answer ?? '',
                                  prodDesc: '',
                                )
                               // CustomText(controller.faqsResponse.value.data?[index].answer ?? '', maxLines: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Padding(
              padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: appColors.guideColor)),
          SizedBox(height: 8.h),
          CustomText('gettingData'.tr)
        ],
      ),
    );
  }

  Widget noDataWidget() {
    return SizedBox(
      width: double.maxFinite,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(width: double.maxFinite),
          const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.help_rounded, size: 50)),
          SizedBox(height: 8.h),
          CustomText('noDataAvailable'.tr)
        ]),
      ),
    );
  }
}
