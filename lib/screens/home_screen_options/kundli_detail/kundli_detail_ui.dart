import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../repository/kundli_repository.dart';
import 'kundli_detail_controller.dart';
import 'widgets/basic_panchang_ui.dart';
import 'widgets/dasha_ui.dart';
import 'widgets/dosha_ui.dart';
import 'widgets/kp_ui.dart';
import 'widgets/lagna_ui.dart';
import 'widgets/moon_chart_ui.dart';
import 'widgets/navamansha_ui.dart';
import 'widgets/personal_detail.dart';
import 'widgets/prediction_ui.dart';
import 'widgets/sun_chart_ui.dart';

class KundliDetailUi extends GetView<KundliDetailController> {
  const KundliDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<KundliDetailController>(
      assignId: true,
      init: KundliDetailController(KundliRepository()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColors.white,
            title: Text(
              "${controller.selectedTab}".tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.textColor,
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                TabBarWidget(controller),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 14,
                    ),
                    child: Text(
                      "Kundali Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.textColor,
                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid
                    crossAxisSpacing: 2, // Horizontal space between grid items
                    mainAxisSpacing: 8, // Vertical space between grid items
                    mainAxisExtent: 35,
                  ),
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 8, bottom: 20),
                  itemCount: controller
                      .detailsPagesNames.length, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: InkWell(
                        onTap: () {
                          controller
                              .changingTab(controller.detailsPagesNames[index]);
                        },
                        child: Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            color: controller.selectedTab ==
                                    controller.detailsPagesNames[index]
                                ? appColors.red
                                : appColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: appColors.red,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.detailsPagesNames[index].toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: controller.selectedTab ==
                                        controller.detailsPagesNames[index]
                                    ? appColors.white
                                    : appColors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TabBarWidget(controller) {
    if (controller.selectedTab == "Lagna") {
      return LagnaUi(controller: controller);
    } else if (controller.selectedTab == "Personal Details") {
      return PersonalDetailUi(controller: controller);
    } else if (controller.selectedTab == "Navamasha") {
      return NavamanshaUi(controller: controller);
    } else if (controller.selectedTab == "Sun") {
      return SunChartUi(controller: controller);
    } else if (controller.selectedTab == "Moon") {
      return MoonChartUi(controller: controller);
    } else if (controller.selectedTab == "Kp") {
      return KpUI(controller: controller);
    } else if (controller.selectedTab == "Dasha") {
      return DashaUI(controller: controller);
    } else if (controller.selectedTab == "Dosha") {
      return DoshaUi(controller: controller);
    } else if (controller.selectedTab == "Basic Panchang") {
      return BasicPanchangUi(controller: controller);
    } else if (controller.selectedTab == "Prediction") {
      return PredictionUi(controller: controller);
    }
  }
}

// import 'package:divine_astrologer/common/app_textstyle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../common/colors.dart';
// import '../../../gen/assets.gen.dart';
// import 'kundli_detail_controller.dart';
// import 'widgets/basic_panchang_ui.dart';
// import 'widgets/dasha_ui.dart';
// import 'widgets/dosha_ui.dart';
// import 'widgets/kp_ui.dart';
// import 'widgets/lagna_ui.dart';
// import 'widgets/moon_chart_ui.dart';
// import 'widgets/navamansha_ui.dart';
// import 'widgets/personal_detail.dart';
// import 'widgets/prediction_ui.dart';
// import 'widgets/sun_chart_ui.dart';
//
// class KundliDetailUi extends GetView<KundliDetailController> {
//   const KundliDetailUi({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 10,
//         child: Builder(builder: (context) {
//           var defaultController = DefaultTabController.of(context);
//           defaultController.addListener(() {
//             controller.currentIndex.value = defaultController.index;
//           });
//           return NestedScrollView(
//             headerSliverBuilder: (context, value) {
//               return [
//                 SliverOverlapAbsorber(
//                   handle:
//                       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                   sliver: SliverAppBar(
//                     leading: InkWell(
//                       onTap: () => Get.back(),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8),
//                         child: Center(child: Assets.images.icLeftArrow.svg()),
//                       ),
//                     ),
//                     flexibleSpace: FlexibleSpaceBar(
//                         stretchModes: const <StretchMode>[
//                           StretchMode.blurBackground,
//                         ],
//                         background: Stack(
//                           children: [
//                             Center(
//                               child: Assets.images.bgKundliDetail
//                                   .svg(width: 128.w, height: 128.h),
//                             ),
//                             Obx(() => Center(
//                                   child: controller.detailPageImage[
//                                       controller.currentIndex.value],
//                                 )),
//                           ],
//                         )),
//                     surfaceTintColor: appColors.white,
//                     expandedHeight: 280.h,
//                     pinned: true,
//                     title: Text("kundliText".tr,
//                         style: AppTextStyle.textStyle16(
//                             fontWeight: FontWeight.w400,
//                             fontColor: appColors.darkBlue)),
//                     bottom: PreferredSize(
//                       preferredSize: const Size.fromHeight(kTextTabBarHeight),
//                       child: Card(
//                         surfaceTintColor: appColors.white,
//                         margin: EdgeInsets.zero,
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero),
//                         child: Center(
//                           child: TabBar(
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             indicatorWeight: 0.0,
//                             isScrollable: true,
//                             dividerColor: Colors.transparent,
//                             labelPadding: EdgeInsets.zero,
//                             labelColor: appColors.whiteGuidedColor,
//                             unselectedLabelColor: appColors.blackColor,
//                             splashBorderRadius: BorderRadius.circular(20),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 6.w, horizontal: 24.w),
//                             labelStyle: AppTextStyle.textStyle14(
//                                 fontWeight: FontWeight.w500,
//                                 fontColor: appColors.whiteGuidedColor),
//                             indicator: BoxDecoration(
//                               color: appColors.guideColor,
//                               borderRadius: BorderRadius.circular(28),
//                             ),
//                             onTap: (value) {
//                               controller.currentIndex.value = value;
//                               controller.getApiData(
//                                   Get.arguments['from_kundli'],
//                                   tab: value);
//                             },
//                             tabs: [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "personalDetails".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "lagna".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "moon".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "sun".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "navamansha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "dosha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "kp".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "dasha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "basicPanchang".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "prediction".tr),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(
//               children: [
//                 PersonalDetailUi(controller: controller),
//                 LagnaUi(controller: controller),
//                 MoonChartUi(controller: controller),
//                 SunChartUi(controller: controller),
//                 NavamanshaUi(controller: controller),
//                 DoshaUi(controller: controller),
//                 KpUI(controller: controller),
//                 DashaUI(controller: controller),
//                 BasicPanchangUi(controller: controller),
//                 PredictionUi(controller: controller),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
