import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';
import 'new_registration_controller.dart';

class NewRegstrationScreen extends GetView<NewRegistrationController> {
  NewRegstrationScreen({super.key});

  List<String> _list = [
    'Law Earning',
    'Health Issues',
    'Better Opportunity',
    'Personal Reason',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRegistrationController>(
      init: NewRegistrationController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: appbarSmall1(context, "Resignation".tr),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  onChanged: (value) {
                    controller.selectedValue(value);
                    print("S====> ${controller.selectedValue.value}");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 16, left: 16),
                child: TextFormField(
                  maxLines: 3, // Adjust the number of lines as needed
                  decoration: InputDecoration(
                    hintText: "Reason here.....",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Having Issues? ',
                        style: AppTextStyle.textStyle14(),
                        // Single tapped.
                      ),
                      TextSpan(
                        text: 'Call Now!',
                        style: AppTextStyle.textStyle14(
                          fontColor: AppColors().red,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Obx(
                () => controller.showRichText.value
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
                                onTap: () {
                                  controller.showRichText(false);
                                },
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop(true);
                                    controller.showRichText(true);
                                    Get.toNamed(RouteName.profileUi);

                                  });
                                  return AlertDialog(
                                    alignment: Alignment.center,
                                    icon: SvgPicture.asset(
                                        "assets/svg/righticon.svg"),
                                    title: Text('Resignation Submitted',
                                        style: AppTextStyle.textStyle16()),
                                    content: Text(
                                      'Our support team will get in touch\nwith you soon.',
                                      style: AppTextStyle.textStyle14(
                                        fontWeight: FontWeight.w400,
                                        fontColor: AppColors().greyColor2,
                                      ).copyWith(fontFamily: "Metropolis"),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              );
                            },
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
              )
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

// MyDropDown(
//   shape: RoundedRectangleBorder(
//       side: const BorderSide(color: colorBlack, width: 1),
//       borderRadius: constants.borderRadius),
//   color: colorBgLight,
//   borderWidth: 0.0,
//   icon: const Icon(
//     Icons.keyboard_arrow_down_rounded,
//     size: 30,
//     color: colorBlack,
//   ),
//   hintText: 'Select Subject',
//   defaultValue:  controller.selectedSubject.value,
//   style: AppTextStyle.smallText.copyWith(
//       color: Colors.black45, fontWeight: FontWeight.bold),
//   onChange: (value) {
//     controller.selectedSubject(value);
//   },
//   array: _list,
// ),
