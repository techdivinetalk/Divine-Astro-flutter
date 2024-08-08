import 'package:divine_astrologer/pages/home/passbook/passbook_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/date_picker/date_picker_widget.dart';
import 'htmlWidget.dart';

class PassbookUi extends GetView<PassbooksController> {
  const PassbookUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PassbooksController>(
      assignId: true,
      init: PassbooksController(),
      builder: (controller) {
        return Scaffold(
          appBar: appbarSmall1(context, "Passbook"),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selectDate(
                      controller.startDate == null
                          ? "Start Date"
                          : "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year}",
                      context,
                      controller, () {
                    showCupertinoModalPopup(
                        context: Get.context!,
                        builder: (context) {
                          return selectDateWid(
                            name: "Start Date",
                            looping: true,
                            buttonTitle: "Confirm",
                            initialDate: DateTime.now(),
                            onConfirm: (String value) {
                              controller.setStartDate(value);
                            },
                            onChange: (String value) {
                              controller.setStartDate(value);
                            },
                          );
                        });
                  }),
                  const SizedBox(
                    width: 10,
                  ),
                  selectDate(
                      controller.endDate == null
                          ? "End Date"
                          : "${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}",
                      context,
                      controller, () {
                    showCupertinoModalPopup(
                        context: Get.context!,
                        builder: (context) {
                          return selectDateWid(
                            name: "End Date",
                            looping: true,
                            buttonTitle: "Confirm",
                            initialDate: DateTime.now(),
                            onConfirm: (String value) {
                              controller.setEndDate(value);
                            },
                            onChange: (String value) {
                              controller.setEndDate(value);
                            },
                          );
                        });
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selectTypeWidget("Bonus", context, controller),
                  const SizedBox(
                    width: 10,
                  ),
                  selectTypeWidget("Paid", context, controller),
                  const SizedBox(
                    width: 10,
                  ),
                  selectTypeWidget("Ecomm", context, controller),
                ],
              ),
              controller.isLoading.value == true
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 200),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : controller.passBookDataModel == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 200),
                            Center(
                              child: Text("Please Select Date and wallet type"),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Expanded(
                            child: WebViewPage(
                              url:
                                  controller.passBookDataModel!.data.toString(),
                            ),
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }

  Widget selectWidget(title, context, controller) {
    return InkWell(
      onTap: () {
        controller.selectDaysType(title);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: controller.selectedDaysData == title
              ? appColors.red
              : appColors.grey.withOpacity(0.2),
        ),
        child: title == "Monthly"
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 6, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w600,
                            fontColor: controller.selectedDaysData == title
                                ? appColors.white
                                : appColors.black),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: controller.selectedDaysData == title
                              ? appColors.white
                              : appColors.black),
                    ],
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 6, bottom: 6),
                  child: Text(
                    title,
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: controller.selectedDaysData == title
                            ? appColors.white
                            : appColors.black),
                  ),
                ),
              ),
      ),
    );
  }

  Widget selectTypeWidget(title, context, controller) {
    return InkWell(
      onTap: controller.isLoading.value == true
          ? null
          : () {
              if (controller.startDate == null || controller.endDate == null) {
                Fluttertoast.showToast(msg: "Please select Date");
              } else {
                controller.selectEarningType(title);
              }
            },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: controller.selectedEarningData == title
              ? appColors.red
              : appColors.grey.withOpacity(0.2),
        ),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
            child: Text(
              title,
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w600,
                  fontColor: controller.selectedEarningData == title
                      ? appColors.white
                      : appColors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectDate(title, context, controller, onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          color: appColors.white,
        ),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
            child: Text(
              title,
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w600, fontColor: appColors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

appbarSmall1(BuildContext context, String title,
    {PreferredSizeWidget? bottom, Color? backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors().white,
    bottom: bottom,
    forceMaterialTransparency: true,
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: IconButton(
        visualDensity: const VisualDensity(horizontal: -4),
        constraints: BoxConstraints.loose(Size.zero),
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    titleSpacing: 0,
    title: Text(
      title,
      style: AppTextStyle.textStyle16(),
    ),
    // centerTitle: true,
  );
}

class selectDateWid extends StatelessWidget {
  const selectDateWid(
      {Key? key,
      required this.initialDate,
      required this.looping,
      required this.onConfirm,
      required this.onChange,
      required this.buttonTitle,
      required this.name})
      : super(key: key);

  final String buttonTitle;
  final DateTime? initialDate;
  final bool looping;
  final Function(String) onConfirm, onChange;
  final String name;

  @override
  Widget build(BuildContext context) {
    String pickerStartData = "";
    String pickerEndData = "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: appColors.white),
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              color: appColors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            color: appColors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_sharp,
                    size: 20,
                    color: appColors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: appColors.transparent,
                    child: Text(
                      name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: appColors.darkBlue,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  initialDate: initialDate,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900, 1, 1),
                  dateFormat: "MMM/dd/yyyy",
                  pickerType: "DateCalendar",
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {
                    pickerStartData = newDate.toString();
                    // onConfirmStart(newDate.toString());
                  },
                  onChange: (DateTime newDate, _) {
                    pickerStartData = newDate.toString();

                    // onStartChange(newDate.toString());
                  },
                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 180,
                    itemHeight: 44,
                    backgroundColor: appColors.white,
                    itemTextStyle: TextStyle(
                        color: appColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    dividerColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              MaterialButton(
                height: 50,
                highlightElevation: 0,
                elevation: 0.0,
                minWidth: MediaQuery.sizeOf(context).width * 0.75,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  onConfirm(pickerStartData.toString());
                  onChange(pickerStartData.toString());

                  Get.back();
                },
                color: appColors.guideColor,
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: appColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
