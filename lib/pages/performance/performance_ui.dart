import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/performance_model_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_textstyle.dart';
import '../../common/appbar.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
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
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TodayAvailabilityWidget(
                    daysAvailiblity:
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
                    score: controller.performanceData?.data?.score),
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
                primary: false,
                itemCount: controller.overAllScoreList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15),
                itemBuilder: (BuildContext context, int index) {
                  BusyHours? item = controller.overAllScoreList[index];
                  ScoreModelClass model = controller.percentageSubTitle[index];
                  return GridTile(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children:  [
                            Assets.images.bgMeterFinal.svg(
                              height: 135.h,
                              width: 270.h,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Your Score",
                                  style: AppTextStyle.textStyle10(
                                      fontColor: AppColors.darkBlue),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  item?.performance?.isNotEmpty ?? false
                                      ? '${item?.performance?[0].value ?? 0}'
                                      : "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkBlue,
                                      fontSize: 20.sp),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  item?.performance?.isNotEmpty ?? false
                                      ? 'Out of ${item?.performance?[0].valueOutOff ?? 0}'
                                      : "Out of 0",
                                  // "Out of 100",
                                  style: AppTextStyle.textStyle10(
                                      fontColor: AppColors.darkBlue),
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                height: 140.h,
                                width: 280.h,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 8,
                                      left: 10.w,
                                      child: Row(
                                        children: [
                                          Text(
                                            // "0",
                                            '${item?.rankDetail?[0].min ?? 0}',
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 140.w,
                                          ),
                                          Text(
                                            // "100",
                                            '${item?.rankDetail?[2].max ?? 0}',
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 28.h,
                                      left: 40.w,
                                      child: Row(
                                        children: [
                                          Text(
                                            // "25",
                                            '${item?.rankDetail?[0].max ?? 0}',
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 75.w,
                                          ),
                                          Text(
                                            '${item?.rankDetail?[1].max ?? 0}',
                                            // "50",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        InkWell(
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
                                                offset: const Offset(0.0, 3.0)),
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
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .textStyle12(
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
                                                              TextAlign.center,
                                                          style: AppTextStyle
                                                              .textStyle12(
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
                                                  itemCount:
                                                      item?.detail?.length ?? 0,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Detail? model =
                                                        item?.detail?[index];
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                (model?.percentage ??
                                                                        '-')
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: AppTextStyle.textStyle12(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontColor:
                                                                        AppColors
                                                                            .darkBlue),
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                (model?.marks ??
                                                                        '-')
                                                                    .toString(),
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
                                                                height: 10.h,
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
                              // height: 40.h,
                              // width: 120.h,
                              padding: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 3.0,
                                        offset: const Offset(0.0, 3.0)),
                                  ],
                                  color: AppColors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Column(
                                children: [
                                  Text(
                                    item?.label ?? '',
                                    style: AppTextStyle.textStyle12(
                                        fontColor: AppColors.darkBlue),
                                  ),
                                ],
                              )),
                        ),
                        // SizedBox(
                        //     height: 170.h,
                        //     child: SfRadialGauge(
                        //         backgroundColor: Colors.white,
                        //         animationDuration: 4500,
                        //         title: GaugeTitle(text: "22"),
                        //         axes: <RadialAxis>[
                        //           RadialAxis(
                        //               radiusFactor: 0.9,
                        //               canScaleToFit: true,
                        //               axisLabelStyle: const GaugeTextStyle(
                        //                   color: Colors.white),
                        //               showLastLabel: false,
                        //               // maximum: 50,
                        //               maximum: 150,
                        //               ranges: <GaugeRange>[
                        //                 GaugeRange(
                        //                   label: "First",
                        //                   labelStyle: const GaugeTextStyle(color: Colors.black),
                        //                   color: Colors.red,
                        //                   endWidth: 15,
                        //                   startWidth: 15,
                        //                   startValue: 0,
                        //                   endValue: 50,
                        //                 ),
                        //                 GaugeRange(
                        //                   color: Colors.green,
                        //                   endWidth: 15,
                        //                   startWidth: 15,
                        //                   startValue: 50,
                        //                   endValue: 100,
                        //                 ),
                        //                 GaugeRange(
                        //                   color: Colors.amber,
                        //                   startValue: 100,
                        //                   endWidth: 15,
                        //                   startWidth: 15,
                        //                   endValue: 150,
                        //                 )
                        //               ],
                        //               pointers: const <GaugePointer>[
                        //                 MarkerPointer(
                        //                   animationDuration: 5000,
                        //                   value: 40,
                        //                   enableAnimation: true,
                        //                   borderColor: AppColors.markerColor,
                        //                   borderWidth: 9,
                        //                   markerWidth: 9,
                        //                   markerHeight: 9,
                        //                   // overlayRadius: 800,
                        //                   markerType:
                        //                       MarkerType.invertedTriangle,
                        //                   animationType:
                        //                       AnimationType.elasticOut,
                        //                   markerOffset: -6,
                        //                 )
                        //               ],
                        //               annotations: <GaugeAnnotation>[
                        //                 GaugeAnnotation(
                        //                     widget: Column(
                        //                       children: [
                        //                         SizedBox(
                        //                           height: 20.h,
                        //                         ),
                        //                         Text(
                        //                           "Your Score",
                        //                           style:
                        //                               AppTextStyle.textStyle12(
                        //                                   fontColor: AppColors
                        //                                       .darkBlue),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 10.h,
                        //                         ),
                        //                         Text(
                        //                           '90.0',
                        //                           style: TextStyle(
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               color: AppColors.darkBlue,
                        //                               fontSize: 25.sp),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 10.h,
                        //                         ),
                        //                         Text(
                        //                           "Out of 100",
                        //                           style:
                        //                               AppTextStyle.textStyle12(
                        //                                   fontColor: AppColors
                        //                                       .darkBlue),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     angle: 90,
                        //                     horizontalAlignment:
                        //                         GaugeAlignment.center,
                        //                     verticalAlignment:
                        //                         GaugeAlignment.center,
                        //                     axisValue: 10,
                        //                     positionFactor: 0.5)
                        //               ])
                        //         ])),
                      ],
                    ), //just for testing, will fill with image later
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
  final DaysAvailiblity? last30DaysAvailiblity;

  const LastAvailabilityWidget({super.key, this.last30DaysAvailiblity});

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
          Text(
            "Last 30 Days Availability (in mins)",
            style: AppTextStyle.textStyle12(
                fontWeight: FontWeight.w700, fontColor: AppColors.darkBlue),
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
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
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableChat ?? "0"}",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableCall ?? "0"}",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.busyChat ?? "0"}",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.busyCall ?? "0"}",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${last30DaysAvailiblity?.availableLive ?? "0"}",
                      style: AppTextStyle.textStyle10(
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
  final DaysAvailiblity? daysAvailiblity;

  const TodayAvailabilityWidget({super.key, this.daysAvailiblity});

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
          Text(
            "availabilityTitle".tr,
            style: AppTextStyle.textStyle12(
                fontWeight: FontWeight.w700, fontColor: AppColors.darkBlue),
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
                      // "128 mins",
                      "${daysAvailiblity?.availableChat ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${daysAvailiblity?.availableCall ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${daysAvailiblity?.availableLive ?? "0"} mins",
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
                      "${daysAvailiblity?.busyChat ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${daysAvailiblity?.busyCall ?? "0"} mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${daysAvailiblity?.busyLive ?? "0"} mins",
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
  final Score? score;

  const OverAllScoreData({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.rankSystemUI);
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
                        "${score?.marks ?? '-'}/${score?.obtainMarks ?? '-'} (${score?.percentage ?? 0}%)",
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
                          Assets.images.icDiamond
                              .image(height: 21.h, width: 21.h),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            score?.rank ?? '-',
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          const Expanded(child: SizedBox()),
                          Assets.images.icInfo.svg(height: 21.h, width: 21.h),
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
                "Select",
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
