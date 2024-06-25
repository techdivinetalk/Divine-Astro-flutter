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
      required this.onConfirm,
      required this.onChange,
      required this.buttonTitle})
      : super(key: key);

  final String buttonTitle;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool looping;
  final Function(String) onConfirm, onChange;

  @override
  Widget build(BuildContext context) {
    String pickerData = "";
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
                  lastDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  dateFormat: "MM/dd/yyyy",
                  pickerType: "DateCalendar",
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {},
                  onChange: (DateTime newDate, _) {},
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
                  lastDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  dateFormat: "MM/dd/yyyy",
                  pickerType: "DateCalendar",
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {},
                  onChange: (DateTime newDate, _) {},
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
                  Get.back();
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
