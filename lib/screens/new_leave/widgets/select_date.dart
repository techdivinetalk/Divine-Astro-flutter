import 'dart:developer';

import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/date_picker/date_picker_widget.dart';

class showSelectStartAndEndDate extends StatelessWidget {
  const showSelectStartAndEndDate(
      {Key? key,
      required this.initialStartDate,
      required this.initialEndDate,
      required this.looping,
      required this.onConfirmStart,
      required this.onConfirmEnd,
      required this.onStartChange,
      required this.onEndChange,
      required this.buttonTitle})
      : super(key: key);

  final String buttonTitle;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool looping;
  final Function(String) onConfirmStart,
      onConfirmEnd,
      onStartChange,
      onEndChange;

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
                      "Start Date",
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
                  initialDate: initialStartDate,
                  lastDate: DateTime(DateTime.now().year + 100),
                  firstDate: DateTime.now(),
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
                      "End Date",
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DatePickerWidget(
                  initialDate: initialEndDate,
                  lastDate: DateTime(DateTime.now().year + 100),
                  firstDate: DateTime.now(),
                  dateFormat: "MMM/dd/yyyy",
                  pickerType: "DateCalendar",
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {
                    pickerEndData = newDate.toString();
                    // onConfirmEnd(newDate.toString());
                  },
                  onChange: (DateTime newDate, _) {
                    pickerEndData = newDate.toString();
                    // onEndChange(newDate.toString());
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
              const SizedBox(height: 5),
              MaterialButton(
                height: 50,
                highlightElevation: 0,
                elevation: 0.0,
                minWidth: MediaQuery.sizeOf(context).width * 0.75,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  if (DateTime.parse(pickerEndData)
                      .isBefore(DateTime.parse(pickerStartData))) {
                    divineSnackBar(
                        data: "End date can not be previous of start date");
                  } else {
                    log(pickerStartData.toString());
                    onConfirmStart(pickerStartData.toString());
                    onStartChange(pickerStartData.toString());
                    onConfirmEnd(pickerEndData.toString());
                    onEndChange(pickerEndData.toString());
                    Get.back();
                  }
                },
                color: appColors.guideColor,
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: appColors.brown,
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
