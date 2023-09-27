import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'date_picker/date_picker_widget.dart';

Future openBottomSheet(BuildContext context,
    {String? title, String? btnTitle, required Widget functionalityWidget}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
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
                border: Border.all(color: AppColors.darkBlue),
                color: AppColors.darkBlue),
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.white,
          ),
          child: Column(
            children: [
              if (title != null) const SizedBox(height: 10),
              if (title != null)
                Text(
                  title,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
                ),
              const SizedBox(height: 10),
              SizedBox(
                  width: ScreenUtil().screenWidth, child: functionalityWidget),
              const SizedBox(height: 20),
              if (btnTitle != null)
                MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.sizeOf(context).width * 0.75,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Get.back();
                    },
                    color: AppColors.lightYellow,
                    child: Text(
                      btnTitle,
                      style: const TextStyle(color: AppColors.brownColour),
                    )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    ),
  );
}

String dateToString(DateTime now, {String format = 'dd MMMM yyyy'}) {
  return DateFormat(format).format(now);
}

selectDateOrTime(
  BuildContext context, {
  required String title,
  required String btnTitle,
  required String pickerStyle,
  required Function(String datetime) onChange,
  required Function(String datetime) onConfirm,
  Function(String datetime)? onClickOkay,
  required bool looping,
  DateTime? lastDate,
  DateTime? initialDate,
  bool? futureDate,
}) {
  DateTime updateDateTime = DateTime.now();
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
                border: Border.all(color: AppColors.darkBlue),
                color: AppColors.darkBlue),
            child: Assets.images.icClose.svg(height: 12.h, width: 12.h),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            border: Border.all(color: AppColors.white, width: 2),
            color: AppColors.white,
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
                    color: AppColors.darkBlue,
                  )),
              const SizedBox(height: 20),
              Material(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  initialDate: initialDate ?? DateTime.now(),
                  lastDate: lastDate ?? DateTime.now(),
                  firstDate: (futureDate ?? false)
                      ? DateTime.now()
                      : DateTime(DateTime.now().year - 100),
                  dateFormat: pickerStyle == "DateCalendar"
                      ? "MMM/dd/yyyy"
                      : "MM/dd/yyyy",
                  pickerType: pickerStyle,
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {
                    updateDateTime = newDate;
                    if (pickerStyle == "DateCalendar") {
                      onConfirm(dateToString(newDate));
                      // debugPrint(Utils.dateToString(newDate));
                    } else {
                      onConfirm(dateToString(newDate, format: "h:mm a"));
                      // debugPrint(Utils.dateToString(newDate, format: "h:mm a"));
                    }
                  },
                  onChange: (DateTime newDate, _) {
                    updateDateTime = newDate;
                    if (pickerStyle == "DateCalendar") {
                      onChange(dateToString(newDate));
                    } else {
                      onChange(dateToString(newDate, format: "h:mm a"));
                    }

                    // debugPrint("$newDate");
                  },
                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 180,
                    itemHeight: 44,
                    backgroundColor: AppColors.white,
                    itemTextStyle: const TextStyle(
                        color: AppColors.darkBlue,
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
                    if (!(futureDate ?? false)) {
                      Navigator.pop(context);
                    }
                    if (onClickOkay != null) {
                      if (pickerStyle == "DateCalendar") {
                        onClickOkay(dateToString(updateDateTime));
                      } else {
                        onClickOkay(
                            dateToString(updateDateTime, format: "h:mm a"));
                      }
                    }
                    // Get.back();
                  },
                  color: AppColors.appYellowColour,
                  child: Text(
                    btnTitle,
                    style: const TextStyle(color: AppColors.brownColour),
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ),
  );
}
