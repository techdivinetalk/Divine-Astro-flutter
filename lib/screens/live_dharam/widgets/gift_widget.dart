import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class GiftWidget extends StatefulWidget {
  const GiftWidget({
    required this.onClose,
    required this.list,
    required this.onSelect,
    super.key,
  });

  final void Function() onClose;
  final List<CustomGiftModel> list;
  final void Function(CustomGiftModel item, num quantity) onSelect;

  @override
  State<GiftWidget> createState() => _GiftWidgetState();
}

class _GiftWidgetState extends State<GiftWidget> {
  Rx<num> quantity = 1.obs;
  Rx<num> amount = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[top(), const SizedBox(height: 16), bottom()],
      ),
    );
  }

  Widget top() {
    return InkWell(
      onTap: widget.onClose,
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: AppColors.white),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: const Icon(Icons.close, color: AppColors.white),
        ),
      ),
    );
  }

  Widget bottom() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.appYellowColour),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Obx(
                () {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[quantityWidget(), amountWidget()],
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: grid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quantityWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Quantity:",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: AppColors.appYellowColour),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              button(
                onTap: () {
                  if (quantity.value > 1) {
                    quantity(quantity.value - 1);
                  } else {}
                },
                iconData: Icons.remove,
              ),
              const SizedBox(width: 8),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 8),
              button(
                onTap: () {
                  quantity(quantity.value + 1);
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
        const Text(
          "Amount:",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "₹ $amount",
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.appYellowColour,
          ),
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.appYellowColour,
        ),
        child: Icon(iconData),
      ),
    );
  }

  Widget grid() {
    return DynamicHeightGridView(
      itemCount: widget.list.length,
      crossAxisCount: 4,
      builder: (BuildContext context, int index) {
        final CustomGiftModel item = widget.list[index];
        return InkWell(
          onTap: () {
            final CustomGiftModel returnItem = item;
            widget.onSelect(returnItem, quantity.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomImageWidget(imageUrl: item.giftImage, rounded: false),
                const SizedBox(height: 8),
                Text(
                  "₹${item.giftPrice}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
