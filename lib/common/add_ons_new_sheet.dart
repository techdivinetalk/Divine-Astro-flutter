import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import '../gen/fonts.gen.dart';
import '../screens/bank_details/widgets.dart';
import '../screens/chat_message/widgets/product/pooja/poojaDetailController.dart';
import 'SvgIconButton.dart';
import 'colors.dart';
import 'custom_widgets.dart';

Future<void> addOnsNewSheet(
    BuildContext context, void Function(String value) onSelect) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => AddOnNewSheets(onSelect: onSelect),
  );
}

class AddOnNewSheets extends StatelessWidget {
  const AddOnNewSheets({Key? key, required this.onSelect}) : super(key: key);

  final void Function(String value) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
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
            padding: EdgeInsets.only(top: 15.h, left: 25.w, right: 25.w),
            height: context.height / 2,
            width: context.width,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/astrologer.png',
                    height: 48.w, width: 48.w),
                Text('Tripti',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: appColors.textColor,
                        fontFamily: FontFamily.metropolis)),
                const SizedBox(height: 5),
                Text('Mangal Dosha Nivaran Pooja',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.textColor,
                        fontFamily: FontFamily.metropolis)),
                const SizedBox(height: 5),
                Text('28th October 2023,  12:15 PM',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: appColors.textColor,
                        fontFamily: FontFamily.metropolis)),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: appColors.textColor.withOpacity(0.1)),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: Material(
                    color: appColors.transparent,
                    child: GetBuilder<PoojaDetailController>(
                      builder: (controller) {
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: controller.model
                              .map(
                                (element) => ProductWidget(
                                  model: element,
                                  onValueChange: (value) {
                                    if (value) {
                                      controller.addItem(element);
                                    } else {
                                      controller.removeItem(element);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
                CustomMaterialButton(
                  buttonName: "Total Amount : ₹499 Confirm",
                  textColor: appColors.brownColour,
                  radius: 10,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget(
      {Key? key, required this.model, required this.onValueChange})
      : super(key: key);

  final PoojaDetailsModel model;
  final void Function(bool value) onValueChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          model.title,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(width: 5.h),
                        CustomText(model.price,
                            fontSize: 16.sp, fontWeight: FontWeight.w600)
                      ],
                    ),
                    Text(
                      'Get blessings of Go and our astrologer by offering them dakshina.',
                      maxLines: 5,
                      style: TextStyle(
                          color: appColors.textColor.withOpacity(0.5),
                          fontFamily: FontFamily.metropolis,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              CustomCheckMaker(
                initialValue: model.isSelected,
                onValueChange: onValueChange,
              ),
            ],
          ),
          Divider(color: appColors.textColor.withOpacity(0.1)),
        ],
      ),
    );
  }
}

class CustomCheckMaker extends StatefulWidget {
  const CustomCheckMaker(
      {Key? key, this.initialValue = false, required this.onValueChange})
      : super(key: key);

  final bool initialValue;
  final void Function(bool value) onValueChange;

  @override
  State<CustomCheckMaker> createState() => _CustomCheckMakerState();
}

class _CustomCheckMakerState extends State<CustomCheckMaker> {
  late bool initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SvgIconButton(
      svg: initialValue
          ? SvgPicture.asset('assets/svg/ic_check.svg')
          : SvgPicture.asset('assets/svg/ic_un_check.svg'),
      onPressed: () {
        setState(() => initialValue = !initialValue);
        widget.onValueChange(initialValue);
      },
    );
  }
}
