import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';


class KpUI extends StatelessWidget {
  const KpUI({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 40.h),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details(
                    title: "bhavChalitChart".tr,
                    details: "Chart"
                    // details: controller.manglikDosh.value.manglikReport == null
                    //     ? ""
                    //     : controller.manglikDosh.value.manglikReport!
                    ),
                SizedBox(
                  height: 20.h,
                ),
                rulingPlanetsWidget(),
                SizedBox(
                  height: 20.h,
                ),
                planetsWidget(),
                SizedBox(
                  height: 20.h,
                ),
                cuspsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cuspsWidget() {
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
            // border: TableBorder.all(color: Colors.grey, width: 1.1),
            border: const TableBorder(
                verticalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid),
                horizontalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid)),
            children: [
              TableRow(
                  // decoration: BoxDecoration(color: Colors.amber),
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
                  ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
            ]),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  Widget planetsWidget() {
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
            // border: TableBorder.all(color: Colors.grey, width: 1.1),
            border: const TableBorder(
                verticalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid),
                horizontalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid)),
            children: [
              TableRow(
                  // decoration: BoxDecoration(color: Colors.amber),
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
                  ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Sun',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Aquarius',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ma',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ke',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Ve',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle10(
                        fontColor: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
            ]),
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

  Widget details({required String title, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
        SizedBox(height: 5.h),
        Text(
          details,
          style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w500,
              fontColor: AppColors.blackColor.withOpacity(.5)),
        ),
        SizedBox(height: 16.h)
      ],
    );
  }
}
