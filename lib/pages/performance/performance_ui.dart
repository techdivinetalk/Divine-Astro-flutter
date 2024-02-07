import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/model/performance_response.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/appbar.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../model/filter_performance_response.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'performance_controller.dart';

class PerformanceUI extends GetView<PerformanceController> {
  const PerformanceUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PerformanceController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          commonAppbar(title: "performance".tr, trailingWidget: Container()),
      drawer: const SideMenuDrawer(),
      body: GetBuilder<PerformanceController>(builder: (controller) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: controller.loading.value == Loading.loading
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: const GenericLoadingWidget(),
          secondChild: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TodayAvailabilityWidget(
                      todaysAvailiblity:
                          controller.performanceData?.data?.todaysAvailiblity),
                  SizedBox(
                    height: 20.h,
                  ),
                  LastAvailabilityWidget(
                      last30DaysAvailiblity: controller
                          .performanceData?.data?.last30DaysAvailiblity),
                  SizedBox(
                    height: 20.h,
                  ),
                  // durationWidget(),
                  const DurationUI(),
                  SizedBox(
                    height: 20.h,
                  ),
                  OverAllScoreData(
                      performanceFilterResponse:
                          controller.performanceFilterResponse),
                  SizedBox(
                    height: 30.h,
                  ),
                  const YourScoreWidget(),
                  // yourScore(),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class YourScoreWidget extends GetView<PerformanceController> {
  const YourScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PerformanceController>(
      init: PerformanceController(),
      builder: (controller) {
        return Column(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              removeBottom: true,
              removeTop: true,
              removeRight: true,
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                primary: false,
                itemCount: controller.overAllScoreList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.h,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (BuildContext context, int index) {
                  Conversion? item = controller.overAllScoreList[index];
                  ScoreModelClass model = controller.percentageSubTitle[index];
                  return GridTile(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Assets.images.bgMeterFinal.svg(
                              height: 135.h,
                              width: 270.h,
                            ),
                            Positioned(
                              left: 32.h,
                              top: 40.h,
                              child: CustomText(
                                // "25",
                                '${item?.performance?.marks?[1].min ?? 0}',
                                //'${item?.rankDetail?[0].max ?? 0}',
                                fontSize: 8.sp,
                              ),
                            ),
                            Positioned(
                              right: 38.h,
                              top: 40.h,
                              child: CustomText(
                                // "50",
                                '${item?.performance?.marks?[1].max ?? 0}',
                                fontSize: 8.sp,
                              ),
                            ),
                            Positioned(
                              left: 5.h,
                              top: 105.h,
                              child: CustomText(
                                //0
                                '${item?.performance?.marks?[0].min ?? 0}',
                                fontSize: 8.sp,
                              ),
                            ),
                            Positioned(
                              right: 0.h,
                              top: 105.h,
                              child: CustomText(
                                //100
                                '${item?.performance?.marks?[2].max ?? 0}',
                                fontSize: 8.sp,
                              ),
                            ),
                            SizedBox(
                              height: 150.h,
                              width: 270.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(height: 25.h),
                                  Text(
                                    "Your Score",
                                    style: AppTextStyle.textStyle10(
                                        fontColor: AppColors.darkBlue),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${item?.performance?.marksObtains ?? 0}',
                                    // item?.performance?.isNotEmpty ?? false
                                    //     ? '${item?.performance?[0].value ?? 0}'
                                    //     : "0",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkBlue,
                                        fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Out of ${item?.performance?.totalMarks ?? 0}',
                                    // item?.performance?.isNotEmpty ?? false
                                    //     ? 'Out of ${item?.performance?[0].valueOutOff ?? 0}'
                                    //     : "Out of 0",
                                    // "Out of 100",
                                    style: AppTextStyle.textStyle10(
                                        fontColor: AppColors.darkBlue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  openBottomSheet(context,
                                      functionalityWidget: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item?.label} ( Percentage vs Marks )",
                                              style: AppTextStyle.textStyle16(
                                                  fontColor: AppColors.darkBlue,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              model.scoreName.toString(),
                                              style: AppTextStyle.textStyle14(
                                                  fontColor: AppColors.darkBlue,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 25.h,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12.h),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 1.0,
                                                      offset: const Offset(
                                                          0.0, 3.0)),
                                                ],
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.h),
                                                ),
                                              ),
                                              child: MediaQuery.removePadding(
                                                context: context,
                                                removeTop: true,
                                                removeBottom: true,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Percentage",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: AppTextStyle.textStyle12(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontColor:
                                                                        AppColors
                                                                            .darkBlue),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Marks",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: AppTextStyle.textStyle12(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontColor:
                                                                        AppColors
                                                                            .darkBlue),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: item
                                                                ?.rankDetail
                                                                ?.length ??
                                                            0,
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemBuilder:
                                                            (context, index) {
                                                          RankDetail? model =
                                                              item?.rankDetail?[
                                                                  index];
                                                          return Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    model?.min ==
                                                                                '0' ||
                                                                            model?.min ==
                                                                                null
                                                                        ? Text(
                                                                            'Less than ${model?.max}${model?.text}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
                                                                          )
                                                                        : model?.max == '0' ||
                                                                                model?.max == null
                                                                            ? Text(
                                                                                '${model?.min}${model?.text}+',
                                                                                textAlign: TextAlign.center,
                                                                                style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
                                                                              )
                                                                            : Text(
                                                                                '${model?.min}${model?.text}-${model?.max}${model?.text}',
                                                                                textAlign: TextAlign.center,
                                                                                style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
                                                                              ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      (model?.value ??
                                                                              '-')
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppTextStyle.textStyle12(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontColor:
                                                                              AppColors.darkBlue),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(12.h),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3.0,
                                              offset: const Offset(0.0, 3.0)),
                                        ],
                                        color: AppColors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      item?.label ?? '',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textStyle12(
                                          fontColor: AppColors.darkBlue),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class LastAvailabilityWidget extends StatelessWidget {
  final Last30DaysAvailiblity? last30DaysAvailiblity;

  const LastAvailabilityWidget({super.key, this.last30DaysAvailiblity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${'last30DaysAvailability'.tr} (${'inMins'.tr})",
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w700, fontColor: AppColors.darkBlue),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "No info for now!");
                  },
                  child: Assets.images.icInfo.svg(height: 17.h, width: 17.h)),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Column(
            children: [
              //title
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "date".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  SizedBox(
                    width: 6.h,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "availableChat".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  SizedBox(
                    width: 6.h,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "availableCall".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  SizedBox(
                    width: 6.h,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "busyChat".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  SizedBox(
                    width: 6.h,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "busyCall".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  SizedBox(
                    width: 6.h,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "availableLive".tr,
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "20-06-23",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableChat ?? "0"}",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableCall ?? "0"}",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.busyChat ?? "0"}",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.busyCall ?? "0"}",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableLive ?? "0"}",
                      style: AppTextStyle.textStyle9(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TodayAvailabilityWidget extends GetView<PerformanceController> {
  final TodaysAvailiblity? todaysAvailiblity;

  const TodayAvailabilityWidget({super.key, this.todaysAvailiblity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "availabilityTitle".tr,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w700, fontColor: AppColors.darkBlue),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "No info for now!");
                  },
                  child: Assets.images.icInfo.svg(height: 17.h, width: 17.h)),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "sessionType".tr,
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "chat".tr.toUpperCase(),
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "call".tr.toUpperCase(),
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "live".tr.toUpperCase(),
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.h,
              ),
              // Available
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "available".tr,
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${todaysAvailiblity?.availableChat ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${todaysAvailiblity?.availableCall ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${todaysAvailiblity?.availableLive ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 20.h,
              ),
              // Busy
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "busy".tr,
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      // "19 mins",
                      "${todaysAvailiblity?.busyChat ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${todaysAvailiblity?.busyCall ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${todaysAvailiblity?.busyLive} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OverAllScoreData extends GetView<PerformanceController> {
  final PerformanceFilterResponse? performanceFilterResponse;

  const OverAllScoreData({super.key, this.performanceFilterResponse});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.rankSystemUI, arguments: [
          controller.performanceFilterResponse?.data?.rankSystem
        ]);
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20.h),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "overallScore".tr,
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w700,
                            fontColor: AppColors.darkBlue),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        // "540/600 (90%)",
                        "${performanceFilterResponse?.data?.score ?? '-'}/${performanceFilterResponse?.data?.totalScore ?? '-'} (${performanceFilterResponse?.data?.scorePrecentage ?? 0}%)",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w400,
                            fontColor: AppColors.darkBlue),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "rank".tr,
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w700,
                            fontColor: AppColors.darkBlue),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          setImage(performanceFilterResponse?.data?.rank ??
                                  "") ??
                              SizedBox(
                                width: 10.w,
                              ),
                          // Assets.images.icDiamond
                          //     .image(height: 21.h, width: 21.h),
                          // SizedBox(
                          //   width: 10.w,
                          // ),
                          Text(
                            performanceFilterResponse?.data?.rank ?? '-',
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(msg: "No info for now!");
                              },
                              child: Assets.images.icInfo
                                  .svg(height: 17.h, width: 17.h)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

setImage(String rank) {
  if (rank == "Diamond") {
    return Assets.images.icDiamond.image(height: 21.h, width: 21.h);
  } else if (rank == "Platinum") {
    return Assets.images.icPlatinum.image(height: 21.h, width: 21.h);
  } else if (rank == "Gold") {
    return Assets.images.icGold.image(height: 21.h, width: 21.h);
  } else if (rank == "Silver") {
    return Assets.images.icSilver.image(height: 21.h, width: 21.h);
  } else if (rank == "Bronze") {
    return Assets.images.icBronze.image(height: 21.h, width: 21.h);
  } else {
    return SizedBox(
      width: 10.w,
    );
  }
}

class DurationUI extends StatelessWidget {
  const DurationUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GetBuilder<PerformanceController>(builder: (controller) {
        return Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                "select".tr,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              items: controller.durationOptions
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            item.tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ))
                  .toList(),
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              value: controller.selectedOption.value,
              onChanged: (String? value) {
                // if(value == controller.durationOptions.last){
                //   showCupertinoModalPopup(
                //     context: Get.context!,
                //     barrierColor:
                //     AppColors.darkBlue.withOpacity(0.5),
                //     builder: (context) => const DateSelection(),
                //   );
                // }
                // else{
                controller.updateDurationValue(value!);
                // }
              },
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                ),
                iconSize: 35,
                iconEnabledColor: AppColors.blackColor,
              ),
              dropdownStyleData: DropdownStyleData(
                width: ScreenUtil().screenWidth * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.white,
                ),
                offset: const Offset(-10, -17),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(false),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),
        );
      }),
    );
  }
}
