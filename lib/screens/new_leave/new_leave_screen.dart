import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/new_leave/new_leave_controller.dart';
import 'package:divine_astrologer/screens/new_leave/widgets/select_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewLeaveScreen extends GetView<NewLeaveController> {
  NewLeaveScreen({super.key});

  List<String> _list = [
    'Law Earning',
    'Health Issues',
    'Better Opportunity',
    'Personal Reason',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewLeaveController>(
      init: NewLeaveController(UserRepository()),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: Get.context!,
                          builder: (context) {
                            return showSelectStartAndEndDate(
                              looping: true,
                              buttonTitle: "Confirm",
                              initialStartDate: DateTime.now(),
                              initialEndDate: DateTime.now(),
                              onConfirm: (String) {},
                              onChange: (String) {},
                            );
                          });
                    },
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors().greyColor2)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors().black,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Center(
                                child: Text(
                                  "Start Date",
                                  style: AppTextStyle.textStyle14(
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColors().grey,
                                  ).copyWith(fontFamily: "Poppins"),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: Get.context!,
                          builder: (context) {
                            return showSelectStartAndEndDate(
                              looping: true,
                              buttonTitle: "Confirm",
                              initialStartDate: DateTime.now(),
                              initialEndDate: DateTime.now(),
                              onConfirm: (String) {},
                              onChange: (String) {},
                            );
                          });
                    },
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors().greyColor2)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors().black,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Center(
                                child: Text(
                                  "End Date",
                                  style: AppTextStyle.textStyle14(
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColors().grey,
                                  ).copyWith(fontFamily: "Poppins"),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors().greyColor2)),
                child: CustomDropdown<String>(
                  decoration: CustomDropdownDecoration(
                      headerStyle: AppTextStyle.textStyle16(),
                      listItemStyle: AppTextStyle.textStyle16()),
                  closedHeaderPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  hintText: 'Select job role',
                  items: _list,
                  initialItem: _list[0],
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 16, left: 16),
                child: TextFormField(
                  maxLines: 3, // Adjust the number of lines as needed
                  decoration: InputDecoration(
                    hintText: "Reason here.....",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    hintStyle: AppTextStyle.textStyle16(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors().greyColor2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors().greyColor2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors().greyColor2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors().greyColor2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors().greyColor2),
                    ),
                  ),
                ),
              ),
              Spacer(),
              controller.status.value == false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Resignation Status - ',
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w500,
                                ).copyWith(fontFamily: "Metropolis"),
                                // Single tapped.
                              ),
                              TextSpan(
                                text: 'Pending',
                                style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w500,
                                  fontColor: AppColors().red,
                                ).copyWith(fontFamily: "Metropolis"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 15, bottom: 20),
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors().red)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor: Colors.red.withOpacity(0.5),
                              highlightColor: Colors.transparent,
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  "Cancel Resignation",
                                  style: AppTextStyle.textStyle16(
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColors().red,
                                  ).copyWith(fontFamily: "Metropolis"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors().red)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Colors.red.withOpacity(0.5),
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Center(
                            child: Text(
                              "Submit Resignation",
                              style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors().red,
                              ).copyWith(fontFamily: "Metropolis"),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
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
