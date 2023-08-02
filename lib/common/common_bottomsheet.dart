import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';

Future openBottomSheet(BuildContext context,
    {required String title,
    required String btnTitle,
    required Widget functionalityWidget}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: Colors.white),
                color: AppColors.white.withOpacity(0.20)),
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
            border: Border.all(color: const Color(0xFFFCB742), width: 2),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Material(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0E2339),
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20),
              functionalityWidget,
              const SizedBox(height: 20),
              MaterialButton(
                  height: 50,
                  minWidth: MediaQuery.sizeOf(context).width * 0.75,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  color: const Color(0xFFFDD48E),
                  child: Text(
                    btnTitle,
                    style: const TextStyle(color: Color(0xFF5F3C08)),
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ),
  );
}

Future openDateOrTimePicker(BuildContext context,
    {required String title,
    required String btnTitle,
    required String pickerStyle,
    required bool looping}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: Colors.white),
                color: AppColors.white.withOpacity(0.20)),
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
            border: Border.all(color: const Color(0xFFFCB742), width: 2),
            color: Colors.white,
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
                    color: const Color(0xFFFCB742),
                  )),
              const SizedBox(height: 20),
              Material(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0E2339),
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  lastDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  dateFormat: pickerStyle == "DateCalendar"
                      ? "MMM/dd/yyyy"
                      : "MM/dd/yyyy",
                  // pickerType: pickerStyle,
                  // looping: looping,
                  onChange: (DateTime newDate, _) {
                    //  _selectedDate = newDate;
                    debugPrint("$newDate");
                  },
                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 180,
                    itemHeight: 44,
                    backgroundColor: Colors.white,
                    itemTextStyle: const TextStyle(
                        color: Color(0xFF0E2339),
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    dividerColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                  height: 50,
                  minWidth: MediaQuery.sizeOf(context).width * 0.75,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  color: const Color(0xFFFDD48E),
                  child: Text(
                    btnTitle,
                    style: const TextStyle(color: Color(0xFF5F3C08)),
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ),
  );
}
