import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class GiftWidget extends StatefulWidget {
  const GiftWidget({
    required this.onClose,
    required this.list,
    required this.onSelect,
    required this.isHost,
    required this.walletBalance,
    super.key,
  });

  final void Function() onClose;
  final List<GiftData> list;
  final void Function(GiftData item, num quantity) onSelect;
  final bool isHost;
  final num walletBalance;

  @override
  State<GiftWidget> createState() => _GiftWidgetState();
}

class _GiftWidgetState extends State<GiftWidget> {
  Rx<num> quantity = 1.obs;

  Rx<num> amount = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
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
            border: Border.all(color: appColors.white),
            color: appColors.white.withOpacity(0.2),
          ),
          child: Icon(Icons.close, color: appColors.white),
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
          height: Get.height / 1.5,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white.withOpacity(0.2),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Obx(
                () {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.isHost
                        ? <Widget>[quantityWidget()]
                        : <Widget>[quantityWidget(), amountWidget()],
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
        Text(
          "Quantity:",
          style: TextStyle(
            fontSize: 12,
            color: appColors.white,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white.withOpacity(0.2),
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
              const SizedBox(width: 4),
              Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: appColors.white,
                ),
              ),
              const SizedBox(width: 4),
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
        Text(
          // "Amount:",
          "Wallet Balance:",
          style: TextStyle(
            fontSize: 12,
            color: appColors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          // "₹ $amount",
          "${widget.walletBalance}",
          style: TextStyle(
            fontSize: 12,
            color: appColors.textColor,
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appColors.textColor,
        ),
        child: Icon(iconData),
      ),
    );
  }

  Widget grid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DynamicHeightGridView(
        itemCount: widget.list.length,
        crossAxisCount: 4,
        builder: (BuildContext context, int index) {
          final GiftData item = widget.list[index];
          return InkWell(
            onTap: () {
              widget.onSelect(item, quantity.value);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CustomImageWidget(
                      imageUrl: item.fullGiftImage,
                      rounded: false,
                      typeEnum: TypeEnum.gift,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${item.giftPrice}",
                    style: TextStyle(
                      fontSize: 12,
                      color: appColors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
