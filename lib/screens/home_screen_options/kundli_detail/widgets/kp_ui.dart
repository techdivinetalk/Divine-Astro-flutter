import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';
import '../../../../model/internal/kp_data_model.dart';
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
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 40.h),
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.kpTableData.value.data == null
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
              firstChild: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: controller.chalitChart.value.data?.svg == null
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      secondChild: const SizedBox.shrink(),
                      firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("bhavChalitChart".tr,
                        style: AppTextStyle.textStyle20(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.appYellowColour)),
                    SizedBox(height: 15.h),
                    SvgPicture.string(
                      controller.chalitChart.value.data?.svg ?? '',
                    ),
                          SizedBox(height: 15.h),
                        ],
                    ),
                    ),
                    Visibility(
                        visible: (controller.kpTableData.value.data?.planets?.isNotEmpty ?? false),
                        child: planetsWidget(controller.kpTableData)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Visibility(
                        visible: (controller.kpTableData.value.data?.cusps?.isNotEmpty ?? false),
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
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
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
                          'Cusp',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Degree',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sign',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sign\nLord',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Star\nLord',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sub\nLord',
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
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
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
                          'Planet',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Cusp',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sign',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sign\nLord',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Star\nLord',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'Sub\nLord',
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
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
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
                          fontColor: AppColors.brownColour,
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
                          fontColor: AppColors.brownColour,
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
                          fontColor: AppColors.brownColour,
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
                          fontColor: AppColors.brownColour,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                      fontColor: AppColors.darkBlue,
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
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
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
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
            ],
          ),
        ),

        const Divider(thickness: 0.9, color: Colors.grey),
      ],
    );
  }
}
