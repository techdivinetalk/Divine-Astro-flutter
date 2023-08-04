import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future openBottomSheet(BuildContext context,
    {String? title, String? btnTitle, required Widget functionalityWidget}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
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
              const SizedBox(height: 20),
              if (title != null) const SizedBox(height: 20),
              if (title != null)
                Text(
                  title,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
                ),
              const SizedBox(height: 20),
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
                      Get.back();
                    },
                    color: const Color(0xFFFDD48E),
                    child: Text(
                      btnTitle,
                      style: const TextStyle(color: Color(0xFF5F3C08)),
                    )),
              const SizedBox(height: 10),
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // const SizedBox(height: 20),
              // Align(
              //     alignment: Alignment.center,
              //     child: Icon(
              //       pickerStyle == "DateCalendar"
              //           ? Icons.calendar_month
              //           : Icons.access_time_rounded,
              //       size: 50,
              //       color: const Color(0xFFFCB742),
              //     )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.icOffline.svg(),
                  const SizedBox(width: 20),
                  Material(
                    child: Text(
                      "You are Offline Now!",
                      style:
                          AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                width: ScreenUtil().screenWidth * 0.8,
                color: AppColors.greyColour,
              ),
              const SizedBox(height: 20),
              Material(
                child: Text(
                  title,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w700),
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
                  color: AppColors.lightYellow,
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
