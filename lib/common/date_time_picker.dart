import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'colors.dart';
import 'date_picker/date_picker_widget.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker(
      {Key? key,
        required this.pickerStyle,
        required this.initialDate,
        required this.title,
        required this.looping,
        required this.onConfirm,
        required this.onChange,
        required this.buttonTitle})
      : super(key: key);

  final String pickerStyle, title, buttonTitle;
  final DateTime? initialDate;
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
          decoration:  BoxDecoration(
            borderRadius:const BorderRadius.vertical(top: Radius.circular(50.0)),
            color: appColors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.center,
                  child: Icon(
                    pickerStyle == "DateCalendar"
                        ? Icons.calendar_month
                        : Icons.access_time_rounded,
                    size: 50,
                    color: appColors.yellow,
                  )),
              const SizedBox(height: 20),
              Material(
                color: appColors.transparent,
                child: Text(
                  title,
                  style:  TextStyle(
                      fontWeight: FontWeight.w700,
                      color: appColors.darkBlue,
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  initialDate: initialDate,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  dateFormat: pickerStyle == "DateCalendar"
                      ? "MMM/dd/yyyy"
                      : "MM/dd/yyyy",
                  pickerType: pickerStyle,
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {
                    if (pickerStyle == "DateCalendar") {
                      pickerData =
                          Utils.dateToString(newDate, format: "dd MMMM yyyy");
                      onConfirm(pickerData);
                    } else {
                      pickerData =
                          Utils.dateToString(newDate, format: "h:mm a");
                      onConfirm(pickerData);
                    }
                  },
                  onChange: (DateTime newDate, _) {
                    if (pickerStyle == "DateCalendar") {
                      pickerData = Utils.dateToString(newDate);
                      onChange(pickerData);
                    } else {
                      pickerData =
                          Utils.dateToString(newDate, format: "h:mm a");
                      onChange(pickerData);
                    }
                  },
                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 180,
                    itemHeight: 44,
                    backgroundColor: appColors.white,
                    itemTextStyle:  TextStyle(
                        color: appColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    dividerColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                height: 50,
                highlightElevation: 0,
                elevation: 0.0,
                minWidth: MediaQuery.sizeOf(context).width * 0.75,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                onPressed: () {
                  Get.back();
                },
                color: appColors.yellow,
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
