import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';
import '../../../../model/internal/dasha_chart_data_model.dart';
import '../../../../model/internal/planet_detail_model.dart';
import '../../../../model/internal/pran_dasha_model.dart';
import '../../../../model/internal/pratyantar_dasha_model.dart';
import '../../../../model/internal/sookshma_dasha_model.dart';
import '../kundli_detail_controller.dart';

class DashaUI extends StatefulWidget {
  final KundliDetailController controller;

  const DashaUI({Key? key, required this.controller}) : super(key: key);

  @override
  State<DashaUI> createState() => _DashaUIState();
}

class _DashaUIState extends State<DashaUI> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isVimshottari.value = true;
                            controller.isYogini.value = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.isVimshottari.value
                                      ? Colors.white
                                      : appColors.blackColor),
                              borderRadius: BorderRadius.circular(20),
                              color: controller.isVimshottari.value
                                  ? appColors.guideColor
                                  : Colors.white),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 12.h),
                            child: Text(
                              "vimshottari".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isVimshottari.value = false;
                            controller.isYogini.value = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: controller.isYogini.value
                                      ? Colors.white
                                      : appColors.blackColor),
                              color: controller.isYogini.value
                                  ? appColors.guideColor
                                  : appColors.white),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 12.h),
                            child: Text(
                              "yogini".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: controller.isVimshottari.value == true
                          ? ((controller.subDashaLevel.value == 4)
                              ? pranDashaWidget()
                              : (controller.subDashaLevel.value == 3)
                                  ? sookshmaDashaWidget()
                                  : (controller.subDashaLevel.value == 2)
                                      ? pratyantarDashaWidget()
                                      : (controller.subDashaLevel.value == 1)
                                          ? antarDashaWidget()
                                          : mahaDashaWidget())
                          : yoginiWidget(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  //maha Dasha Data
  Widget mahaDashaWidget() {
    // Rx<DashaChartDataModel> dashaTableData
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("mahadasha".tr,
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.textColor)),
              const SizedBox(height: 24),
            ],
          ),
          SizedBox(height: 15.h),
          Table(
              border: const TableBorder(
                verticalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid),
              ),
              children: List.generate(
                  controller.dashaTableData.value.data?.vimshottari?.length ??
                      0 + 1, (index) {
                if (index == 0) {
                  return TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        height: 65.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 3.0)),
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "planet".tr,
                            style: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w500,
                                fontColor: appColors.brownColour),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        height: 65.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 3.0)),
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "startDate".tr,
                            style: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w500,
                                fontColor: appColors.brownColour),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        height: 65.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 3.0)),
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "endDate".tr,
                            style: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w500,
                                fontColor: appColors.brownColour),
                          ),
                        ),
                      ),
                    ),
                  ]);
                }
                Vimshottari? vimshottariData =
                    controller.dashaTableData.value.data?.vimshottari?[index];
                return TableRow(children: [
                  GestureDetector(
                    onTap: () {
                      controller.subDashaLevel.value = 1;
                      if (controller.subDashaPlanetName.value ==
                          vimshottariData?.planet.toString()) {
                      } else {
                        controller.subDashaPlanetName.value =
                            vimshottariData?.planet.toString() ?? '';
                        controller.planetDataDetail.value.data = null;
                        controller.getAntraDataApiList(
                            vimshottariData?.planet.toString() ?? '');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        vimshottariData?.planet ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.subDashaLevel.value = 1;
                      if (controller.subDashaPlanetName.value ==
                          vimshottariData?.planet.toString()) {
                      } else {
                        controller.subDashaPlanetName.value =
                            vimshottariData?.planet.toString() ?? '';
                        controller.planetDataDetail.value.data = null;
                        controller.getAntraDataApiList(
                            vimshottariData?.planet.toString() ?? '');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(vimshottariData?.start),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.subDashaLevel.value = 1;
                            if (controller.subDashaPlanetName.value ==
                                vimshottariData?.planet.toString()) {
                            } else {
                              controller.subDashaPlanetName.value =
                                  vimshottariData?.planet.toString() ?? '';
                              controller.planetDataDetail.value.data = null;
                              controller.getAntraDataApiList(
                                  vimshottariData?.planet.toString() ?? '');
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getDashaFormattedDate(vimshottariData?.end),
                                style: AppTextStyle.textStyle12(),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList()),
          SizedBox(
            height: 20.h,
          ),
        ],
      );
    });
  }

  //antar Dasha  Data
  Widget antarDashaWidget() {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: controller.planetDataDetail.value.data == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 10.h, width: double.maxFinite),
            const LoadingWidget(),
          ],
        ),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.subDashaLevel.value = 0;
                  },
                  child: Row(
                    children: [
                      Text("mahadasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
                Text("antarDasha".tr,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.textColor)),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.grey, style: BorderStyle.solid),
                ),
                children: List.generate(
                    controller.planetDataDetail.value.data?.length ?? 0 + 1,
                    (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "planet".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "startDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "endDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }
                  Vimshottari? vimshottariData =
                      controller.dashaTableData.value.data?.vimshottari?[index];
                  Datum? subModel =
                      controller.planetDataDetail.value.data?[index];

                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        subModel?.planet ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(subModel?.start),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.subDashaLevel.value = 2;
                              controller.getPratyantarDashaApiList(
                                vimshottariData?.planet.toString() ?? '',
                                subModel?.planet.toString() ?? '',
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getDashaFormattedDate(subModel?.end),
                                    style: AppTextStyle.textStyle12(),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList()),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                controller.subDashaLevel.value = 0;
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: appColors.guideColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                        child: Text(
                      "levelUp".tr,
                      style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.brownColour),
                    )),
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      );
    });
  }

  //Pratyantar Dasha  Data
  Widget pratyantarDashaWidget() {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: controller.pratyantarDataDetail.value.data == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 10.h, width: double.maxFinite),
            const LoadingWidget(),
          ],
        ),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 0;
                      },
                      child: Row(
                        children: [
                          Text("mahadasha".tr,
                              style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.textColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 1;
                      },
                      child: Text("antarDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Text("pratyantarDasha".tr,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.textColor)),
              ],
            ),
            SizedBox(height: 15.h),
            Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.grey, style: BorderStyle.solid),
                ),
                children: List.generate(
                    controller.pratyantarDataDetail.value.data?.length ?? 0 + 1,
                    (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "planet".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "startDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "endDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }
                  Vimshottari? vimshottariData =
                      controller.dashaTableData.value.data?.vimshottari?[index];
                  Datum? subModel =
                      controller.planetDataDetail.value.data?[index];
                  PratyantarData? pratyantarModel =
                      controller.pratyantarDataDetail.value.data?[index];
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        pratyantarModel?.planet ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(pratyantarModel?.start),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.subDashaLevel.value = 3;
                              controller.getSookshmaDashaApiList(
                                  vimshottariData?.planet.toString() ?? '',
                                  subModel?.planet.toString() ?? '',
                                  pratyantarModel?.planet.toString() ?? '');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getDashaFormattedDate(pratyantarModel?.end),
                                  style: AppTextStyle.textStyle12(),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList()),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                controller.subDashaLevel.value = 1;
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: appColors.guideColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                        child: Text(
                      "levelUp".tr,
                      style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.brownColour),
                    )),
                  )),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    });
  }

  //Sookshma Dasha  Data
  Widget sookshmaDashaWidget() {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: controller.sookshmaDataDetail.value.data == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 10.h, width: double.maxFinite),
            const LoadingWidget(),
          ],
        ),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 0;
                      },
                      child: Row(
                        children: [
                          Text("mahadasha".tr,
                              style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.textColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 1;
                      },
                      child: Text("antarDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 2;
                      },
                      child: Text("pratyantarDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Text("sookshmaDasha".tr,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.textColor)),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.grey, style: BorderStyle.solid),
                ),
                children: List.generate(
                    controller.sookshmaDataDetail.value.data?.length ?? 0 + 1,
                    (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "planet".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "startDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "endDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }
                  Vimshottari? vimshottariData =
                      controller.dashaTableData.value.data?.vimshottari?[index];
                  Datum? subModel =
                      controller.planetDataDetail.value.data?[index];
                  PratyantarData? pratyantarModel =
                      controller.pratyantarDataDetail.value.data?[index];
                  SookshmaData? sookshmaData =
                      controller.sookshmaDataDetail.value.data?[index];
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        sookshmaData?.planet ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(sookshmaData?.start),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.subDashaLevel.value = 4;
                              controller.getPranDashaApiList(
                                  vimshottariData?.planet.toString() ?? '',
                                  subModel?.planet.toString() ?? '',
                                  pratyantarModel?.planet.toString() ?? '',
                                  sookshmaData?.planet.toString() ?? '');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getDashaFormattedDate(sookshmaData?.end),
                                  style: AppTextStyle.textStyle12(),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList()),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                controller.subDashaLevel.value = 2;
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: appColors.guideColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                        child: Text(
                      "levelUp".tr,
                      style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.brownColour),
                    )),
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      );
    });
  }

  //Pran Dasha  Data
  Widget pranDashaWidget() {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: controller.pranDataDetail.value.data == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 10.h, width: double.maxFinite),
            const LoadingWidget(),
          ],
        ),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 0;
                      },
                      child: Row(
                        children: [
                          Text("mahadasha".tr,
                              style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.textColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 1;
                      },
                      child: Text("antarDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 2;
                      },
                      child: Text("pratyantarDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.subDashaLevel.value = 3;
                      },
                      child: Text("sookshmaDasha".tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.textColor)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                Text("pranDasha".tr,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.textColor)),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.grey, style: BorderStyle.solid),
                ),
                children: List.generate(
                    controller.pranDataDetail.value.data?.length ?? 0 + 1,
                    (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "planet".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "startDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "endDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }
                  PranDashaData? pranDashaData =
                      controller.pranDataDetail.value.data?[index];
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        pranDashaData?.planet ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle10(
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(pranDashaData?.start),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getDashaFormattedDate(pranDashaData?.end),
                            style: AppTextStyle.textStyle12(
                                fontColor: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList()),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                controller.subDashaLevel.value = 3;
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: appColors.guideColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                        child: Text(
                      "levelUp".tr,
                      style: AppTextStyle.textStyle20(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.brownColour),
                    )),
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      );
    });
  }

  //yogini Data
  Widget yoginiWidget() {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: controller.dashaTableData.value.data?.yogini == null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 50.h),
            const LoadingWidget(),
          ],
        ),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("bhadrika".tr,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500,
                    fontColor: appColors.textColor)),
            SizedBox(
              height: 15.h,
            ),
            Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.grey, style: BorderStyle.solid),
                ),
                children: List.generate(
                    controller.dashaTableData.value.data?.yogini?.length ??
                        0 + 1, (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "planet".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "startDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "endDate".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }
                  Yogini? yoginiData =
                      controller.dashaTableData.value.data?.yogini?[index];
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        yoginiData?.dashaName ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Text(
                        getDashaFormattedDate(yoginiData?.startDate),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle12(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // controller.isSubDasha.value = true;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getDashaFormattedDate(yoginiData?.endDate),
                                  style: AppTextStyle.textStyle12(),
                                ),
                                /* const Icon(
                                  Icons.chevron_right,
                                  size: 12,
                                ) */
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList()),
            // SizedBox(
            //   height: 20.h,
            // ),
            // Text(
            //   "rashiChart".tr,
            //   style:
            //   AppTextStyle.textStyle16(fontColor: appColors.textColor),
            // ),
            // SizedBox(
            //   height: 15.h,
            // ),
            // SvgPicture.string(
            //   controller.lagnaChart.value.data?.svg ?? '',
            // ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      );
    });
  }

  getDashaFormattedDate(String? date) {
    return date != null
        ? Utils.dateToString(DateFormat("dd-MM-yyyy").parse(date),
            format: "dd-MMM-yyyy")
        : '';
  }
}
