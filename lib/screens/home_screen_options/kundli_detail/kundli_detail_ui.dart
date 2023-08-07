import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import 'kundli_detail_controller.dart';
import 'widgets/basic_panchang_ui.dart';
import 'widgets/dosha_ui.dart';
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
    return Scaffold(
      body: DefaultTabController(
        length: 8,
        child: Builder(builder: (context) {
          var defaultController = DefaultTabController.of(context);
          defaultController.addListener(() {
            controller.currentIndex.value = defaultController.index;
          });
          return NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    leading: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Center(child: Assets.images.icLeftArrow.svg()),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const <StretchMode>[
                          StretchMode.blurBackground,
                        ],
                        background: Stack(
                          children: [
                            Center(
                              child: Assets.images.bgKundliDetail
                                  .svg(width: 128.w, height: 128.h),
                            ),
                            Obx(() => Center(
                                  child: controller.detailPageImage[
                                      controller.currentIndex.value],
                                )),
                          ],
                        )),
                    surfaceTintColor: AppColors.white,
                    expandedHeight: 280.h,
                    pinned: true,
                    title: Text("Kundli",
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue)),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kTextTabBarHeight),
                      child: Card(
                        surfaceTintColor: AppColors.white,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: Center(
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 0.0,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            labelPadding: EdgeInsets.zero,
                            labelColor: AppColors.brownColour,
                            unselectedLabelColor: AppColors.blackColor,
                            splashBorderRadius: BorderRadius.circular(20),
                            padding: EdgeInsets.symmetric(
                                vertical: 6.w, horizontal: 24.w),
                            labelStyle: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.brownColour),
                            indicator: BoxDecoration(
                              color: AppColors.lightYellow,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            onTap: (value) {
                              controller.currentIndex.value = value;
                            },
                            tabs: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Birth Details"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Lagna"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Moon"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Sun"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Navamansha"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Dosha"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Basic Panchang"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: const Tab(text: "Prediction"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [
                PersonalDetailUi(),
                LagnaUi(),
                MoonChartUi(),
                SunChartUi(),
                NavamanshaUi(),
                DoshaUi(),
                BasicPanchangUi(),
                PredictionUi(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
