import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/pages/performance/widget/information_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          commonAppbar(title: "performance".tr, trailingWidget: Container()),
      drawer: const SideMenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              todayAvailabilityWidget(),
              SizedBox(
                height: 20.h,
              ),
              lastAvailabilityWidget(),
              SizedBox(
                height: 20.h,
              ),
              durationWidget(),
              SizedBox(
                height: 20.h,
              ),
              overallScoreWidget(),
              SizedBox(
                height: 30.h,
              ),
              yourScoreWidget(context),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget yourScoreWidget(BuildContext context) {
    return GetBuilder<PerformanceController>(
      init: PerformanceController(),
      builder: (DisposableInterface disposableInterface) {
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
                itemCount: controller.scoreList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15),
                itemBuilder: (BuildContext context, int index) {
                  ScoreModelClass item = controller.scoreList[index];
                  ScoreModelClass model = controller.percentageSubTitle[index];
                  return GridTile(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,


                          children: [
                            SizedBox(
                                height: 170.h,
                                child: SfRadialGauge(
                                    backgroundColor: Colors.white,
                                    animationDuration: 4500,
                                    // title: const GaugeTitle(text: "Main"),
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                          axisLineStyle: const AxisLineStyle(thickness: 0),
                                          radiusFactor: 0.99,
                                          canScaleToFit: false,
                                          axisLabelStyle: const GaugeTextStyle(color: Colors.black,fontSize: 10),
                                          showLastLabel: false,
                                          labelsPosition: ElementsPosition.inside,
                                          maximum: 150,
                                          startAngle: 180,
                                          endAngle: 360,
                                          // labelFormat: '100',
                                          labelOffset: 0.5,
                                          showLabels: false,


                                          ranges: <GaugeRange>[
                                            GaugeRange(
                                              label: "Poor",
                                              labelStyle:  GaugeTextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,fontSize: 12.sp),
                                              color: const Color(0xffFF4764),
                                              endWidth: 35,
                                              startWidth: 35,
                                              startValue: 0,
                                              endValue: 40,
                                            ),
                                            GaugeRange(
                                              label: "Average",
                                              labelStyle:  GaugeTextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12.sp),
                                              color: const Color(0xffFDD48E),
                                              endWidth: 35,
                                              startWidth: 35,
                                              startValue: 50,
                                              endValue: 100,
                                            ),
                                            GaugeRange(
                                              label: "Good",
                                              labelStyle:  GaugeTextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,fontSize: 12.sp),
                                              color: const Color(0xff4FD27E),
                                              endWidth: 35,
                                              startWidth: 35,
                                              startValue: 105,
                                              endValue: 150,
                                            )
                                          ],
                                          annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
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
                                                      '80',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.darkBlue,
                                                          fontSize: 20.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      "Out of 100",
                                                      style: AppTextStyle.textStyle10(
                                                          fontColor: AppColors.darkBlue),
                                                    ),
                                                  ],
                                                ),
                                                angle: 90,
                                                // horizontalAlignment: GaugeAlignment.center,
                                                // verticalAlignment: GaugeAlignment.center,
                                                positionFactor: 0.40)
                                          ])
                                    ])),
                            Positioned(
                              bottom: 0,
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
                                              "${item.scoreName} ( Percentage vs Marks )",
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
                                                        itemCount: controller
                                                            .percentageList.length,
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var item = controller
                                                              .percentageList[index];

                                                          return Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      item.name
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
                                                                      item.score
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
                                          item.scoreName!.tr.toString(),
                                          style: AppTextStyle.textStyle12(
                                              fontColor: AppColors.darkBlue),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
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

  Widget todayAvailabilityWidget() {
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
                      "126 mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "128 mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "0 mins",
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
                      "19 mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "0 mins",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "0 mins",
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

  Widget lastAvailabilityWidget() {
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
                      "472",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "143",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "11",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "61",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "0",
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

  Widget durationWidget() {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "June - 2023 ",
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
          ),
          Assets.images.icDownArrow.svg()
        ],
      ),
    );
  }

  Widget overallScoreWidget() {
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
                        "540/600 (90%)",
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
                            "diamond".tr,
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue),
                          ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: Get.context!,
                                  barrierColor:
                                      AppColors.darkBlue.withOpacity(0.5),
                                  builder: (context) => const InformationUI(),
                                );
                              },
                              child: Assets.images.icInfo
                                  .svg(height: 21.h, width: 21.h)),
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
