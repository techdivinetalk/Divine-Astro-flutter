import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const List<String> _list = [
  'Law Earning',
  'Health Issues',
  'Better Opportunity',
  'Personal Reason',
  'Other',
];

class NewRegstrationScreen extends StatelessWidget {
  const NewRegstrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarSmall1(context, "Resignation".tr),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors().greyColor2)
            ),
            child: CustomDropdown<String>(
              // decoration: CustomDropdownDecoration(
              //   expandedBorder: Border.all(color: AppColors().blackColor),
              // ),
              hintText: 'Select job role',
              items: _list,
              initialItem: _list[0],
              onChanged: (value) {
                print('changing value to: $value');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Having Issues?',
                    style: AppTextStyle.textStyle14(),
                      // Single tapped.
                  ),
                  TextSpan(
                      text: ' Call Now!',
                    style: AppTextStyle.textStyle14(
                      fontColor: AppColors().red,
                    ),

                        // Double tapped.
                  ),
                  TextSpan(
                    text: ' Long press',
                      // Long Pressed.
                  ),
                ],
              ),
            ),
          )
        ],
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
