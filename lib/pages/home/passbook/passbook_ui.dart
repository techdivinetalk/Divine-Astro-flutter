import 'package:divine_astrologer/pages/home/passbook/htmlWidget.dart';
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectWidget("Monthly", context, controller),
                    const SizedBox(
                      width: 10,
                    ),
                    selectWidget("Weekly", context, controller),
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
                const SizedBox(
                  height: 10,
                ),
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
                // Container(
                //   child: Html(
                //     data:
                //         '<figure class="table"><table style="background-color:rgb(255, 255, 255);border:2px solid rgb(0, 0, 0);"><tbody><tr><th><strong>NAME</strong></th><th>DATE</th><th>DD</th></tr><tr><th>PETER</th><th>2020</th><th>SDSD</th></tr><tr><th>SAM</th><th>2021</th><th>SSS</th></tr></tbody></table></figure>',
                //     style: {
                //       "table": Style(
                //         backgroundColor: Colors.white,
                //       ),
                //       "tr": Style(border: Border.all(color: Colors.black)),
                //       "th": Style(border: Border.all(color: Colors.black)),
                //       "td": Style(border: Border.all(color: Colors.black)),
                //     },
                //   ),
                // ),
                controller.passBookDataModel == null
                    ? Container()
                    : controller.isLoading.value == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 100,
                            width: 299,
                            child: Webview(
                              html: controller.passBookDataModel!.data,
                            ),
                          )
                // : Padding(
                //     padding: const EdgeInsets.only(
                //         left: 10, bottom: 5, right: 10),
                //     child: Align(
                //       alignment: Alignment.topLeft,
                //       child: Container(
                //         // height: 300,
                //         // width: MediaQuery.of(context).size.width * 0.9,
                //         // color: Colors.black,
                //         child: SingleChildScrollView(
                //           child: Html(
                //             data:  "",
                //             onLinkTap: (url, attributes, element) {
                //               launchUrl(Uri.parse(url ?? ''));
                //             },
                //             shrinkWrap: true,
                //             style: {
                //               "table": Style(
                //                 height: Height.auto(),
                //                 width: Width.auto(),
                //               ),
                //               "tr": Style(
                //                 height: Height.auto(),
                //                 width: Width.auto(),
                //               ),
                //               "th": Style(
                //                 padding: HtmlPaddings.all(6),
                //                 height: Height.auto(),
                //                 border: const Border(
                //                   left: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                   bottom: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                   top: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                 ),
                //               ),
                //               "td": Style(
                //                 padding: HtmlPaddings.all(6),
                //                 height: Height.auto(),
                //                 border: const Border(
                //                   left: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                   bottom: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                   top: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                   right: BorderSide(
                //                       color: Colors.black, width: 0.5),
                //                 ),
                //               ),
                //               "col": Style(
                //                 height: Height.auto(),
                //                 width: Width.auto(),
                //               ),
                //             },
                //             extensions: [
                //               TagWrapExtension(
                //                   tagsToWrap: {'table'},
                //                   builder: (child) {
                //                     return SingleChildScrollView(
                //                       scrollDirection: Axis.horizontal,
                //                       child: child,
                //                     );
                //                   }),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
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
      onTap: () {
        if (controller.selectedDaysData == null) {
          Fluttertoast.showToast(msg: "Please select Days type");
        } else {
          controller.selectEarningType(title);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
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
        height: 40,
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
      required this.buttonTitle})
      : super(key: key);

  final String buttonTitle;
  final DateTime? initialDate;
  final bool looping;
  final Function(String) onConfirm, onChange;

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
                  initialDate: initialDate,
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
