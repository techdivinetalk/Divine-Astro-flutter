import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../model/astrologer_gift_response.dart';
import '../screens/live_dharam/widgets/custom_image_widget.dart';

class AskForGiftBottomSheet extends StatefulWidget {
  const AskForGiftBottomSheet({
    super.key,
    required this.customerName,
    required this.giftList,
    required this.onSelect,
  });

  final String customerName;
  final List<GiftData> giftList;
  final void Function(GiftData item, num quantity) onSelect;

  @override
  State<AskForGiftBottomSheet> createState() => _AskForGiftState();
}

class _AskForGiftState extends State<AskForGiftBottomSheet> {
  Rx<num> quantity = 1.obs;

  Rx<num> amount = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
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
                  border: Border.all(color: appColors.white),
                  color: appColors.transparent),
              child:  Icon(
                Icons.close_rounded,
                color: appColors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 600,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(50.0)),
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 32.h),
                  Text(
                    'Ask Gift From ${widget.customerName}',
                    style: AppTextStyle.textStyle20(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20.h),
                  const Divider(),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      quantityWidget(),
                      amountWidget(),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Expanded(child: grid()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget grid() {
    return DynamicHeightGridView(
      itemCount: widget.giftList.length,
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 3, crossAxisSpacing: 20.h, mainAxisSpacing: 15.h),
      crossAxisCount: 3,
      builder: (BuildContext context, int index) {
        final GiftData item = widget.giftList[index];
        return InkWell(
          onTap: () {
            widget.onSelect(item, quantity.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 64,
                  width: 64,
                  child: CustomImageWidget(
                    imageUrl: item.fullGiftImage,
                    rounded: true,
                    // added by divine-dharam  
                    typeEnum: TypeEnum.gift,
                    //
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.giftName}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle16(fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 4),
                Text(
                    "₹${item.giftPrice}",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400)
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget quantityWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
         Text(
          "Quantity:",
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600)
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: appColors.yellow),
            color: appColors.white.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              button(
                onTap: () {
                  debugPrint('quan1: $quantity');
                  if (quantity.value > 1) {
                    quantity(quantity.value - 1);
                    debugPrint('quan2: $quantity');
                  } else {}
                },
                iconData: Icons.remove,
              ),
              const SizedBox(width: 8),
              Obx( () =>
                 Text(
                  quantity.toString(),
                    style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600)
                ),
              ),
              const SizedBox(width: 8),
              button(
                onTap: () {
                  debugPrint('quan1: $quantity');
                  quantity(quantity.value + 1);
                  debugPrint('quan2: $quantity');
                },
                iconData: Icons.add,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget amountWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
         Text(
          "Amount:",
            style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600)
        ),
        const SizedBox(width: 8),
        Text(
          "₹ $amount",
            style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600)
        ),
      ],
    );
  }

  Widget button({required void Function() onTap, required IconData iconData}) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      child: Container(
        height: 24,
        width: 24,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          color: appColors.yellow,
        ),
        child: Icon(iconData),
      ),
    );
  }
}
