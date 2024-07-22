import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';
import '../../../../model/internal/kp_data_model.dart';
import '../../../../tarotCard/widget/custom_image_view.dart';
import '../kundli_detail_controller.dart';

class KpUI extends StatelessWidget {
  final KundliDetailController controller;

  const KpUI({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              crossFadeState: controller.kpTableData.value.data == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const KundliLoading(),
                ],
              ),
              firstChild: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AnimatedCrossFade(
                    //   duration: const Duration(milliseconds: 200),
                    //   crossFadeState:
                    //       controller.chalitChart.value.data?.svg == null
                    //           ? CrossFadeState.showSecond
                    //           : CrossFadeState.showFirst,
                    //   secondChild: const SizedBox.shrink(),
                    //   firstChild: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text("bhavChalitChart".tr,
                    //           style: AppTextStyle.textStyle20(
                    //               fontWeight: FontWeight.w500,
                    //               fontColor: appColors.textColor)),
                    //       SizedBox(height: 15.h),
                    //       controller.chalitChart.value.data?.svg != null
                    //           ? Center(
                    //               child: CustomImageView(
                    //                 // height: 40,
                    //                 // width: 40,
                    //                 imagePath:
                    //                     "${controller.preference.getAmazonUrl()}/${controller.chalitChart.value.data!.svg}",
                    //                 radius: BorderRadius.circular(10),
                    //                 placeHolder:
                    //                     "assets/images/default_profile.png",
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             )
                    //
                    //           // SvgPicture.string(
                    //           //     controller.moonChart.value.data?.svg ?? '',
                    //           //   )
                    //           : SizedBox(),
                    //       SizedBox(height: 15.h),
                    //     ],
                    //   ),
                    // ),
                    Visibility(
                        visible: (controller
                                .kpTableData.value.data?.planets?.isNotEmpty ??
                            false),
                        child: planetsWidget(controller.kpTableData)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Visibility(
                        visible: (controller
                                .kpTableData.value.data?.cusps?.isNotEmpty ??
                            false),
                        child: cuspsWidget(controller.kpTableData)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cuspsWidget(Rx<KpDataModel> kpTableData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("cusps".tr,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500, fontColor: appColors.textColor)),
        SizedBox(
          height: 20.h,
        ),
        Table(
            border: const TableBorder(
              verticalInside: BorderSide(
                  width: 1, color: Colors.grey, style: BorderStyle.solid),
            ),
            children: List.generate(
                kpTableData.value.data?.cusps?.length ?? 0 + 1, (index) {
              if (index == 0) {
                return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'cusp'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'degree'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'sign'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'SignLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'starLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'subLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                    ]);
              }
              Cusp? cupsData = kpTableData.value.data?.cusps?[index];
              return TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    "${cupsData?.houseId ?? ""}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    cupsData?.cuspFullDegree.toString() ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    cupsData?.sign ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    cupsData?.signLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    cupsData?.nakshatraLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    cupsData?.subLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]);
            }).toList()),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  Widget planetsWidget(Rx<KpDataModel> kpTableData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("planets".tr,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500, fontColor: appColors.textColor)),
        SizedBox(
          height: 20.h,
        ),
        Table(
            border: const TableBorder(
              verticalInside: BorderSide(
                  width: 1, color: Colors.grey, style: BorderStyle.solid),
            ),
            children: List.generate(
                kpTableData.value.data?.planets?.length ?? 0 + 1, (index) {
              if (index == 0) {
                return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          "planet".tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          "cusp".tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'sign'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'SignLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'starLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'subLord'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                    ]);
              }
              Planet? planetData = kpTableData.value.data?.planets?[index];
              return TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    "${planetData?.planetId ?? ""}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    "${planetData?.charan ?? 0}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    planetData?.sign ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    planetData?.signLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    planetData?.nakshatraLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    planetData?.subLord ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]);
            }).toList()),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  Widget rulingPlanetsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("rulingPlanets".tr,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500, fontColor: appColors.textColor)),
        SizedBox(
          height: 15.h,
        ),
        //Title
        Row(
          children: [
            Expanded(
              child: Container(
                  height: 70.h,
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
                      "--",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.brownColour,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Container(
                  height: 70.h,
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
                      "Sign\nLord",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.brownColour,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Container(
                  height: 70.h,
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
                      "Star\nLord",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.brownColour,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Container(
                  height: 70.h,
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
                      "Sub\nLord",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle16(
                          fontColor: appColors.brownColour,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        //Ans
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Mo",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mo",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mo",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mo",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        //sub ans
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Asc",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mars",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Jupiter",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mars",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle12(
                      fontColor: appColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(thickness: 0.9, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Day Lord",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: appColors.darkBlue),
              ),
              Container(
                height: 40.h,
                width: 1.7,
                color: Colors.grey.withOpacity(0.4),
              ),
              // const VerticalDivider(
              //   color: Colors.black,
              //   thickness: 2,
              //   indent: 20,
              //   endIndent: 0,
              //   width: 10,
              // ),
              Text(
                "Day Lord",
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: appColors.darkBlue),
              ),
            ],
          ),
        ),

        const Divider(thickness: 0.9, color: Colors.grey),
      ],
    );
  }
}
