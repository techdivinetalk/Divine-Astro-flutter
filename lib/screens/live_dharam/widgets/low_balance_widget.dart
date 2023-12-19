import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class LowBalanceWidget extends StatefulWidget {
  const LowBalanceWidget({
    required this.onClose,
    super.key,
  });

  final void Function() onClose;

  @override
  State<LowBalanceWidget> createState() => _LowBalanceWidgetState();
}

class _LowBalanceWidgetState extends State<LowBalanceWidget> {
  final List<LowBalanceModel> _list = <LowBalanceModel>[
    LowBalanceModel(title: "₹200", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹2000", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹20000", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹200000", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹200", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹2000", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹20000", subtitle: "10% Extra"),
    LowBalanceModel(title: "₹200000", subtitle: "10% Extra"),
  ];

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
            color: AppColors.white,
          ),
          child: grid(),
        ),
      ),
    );
  }

  Widget grid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            child: Image.asset("assets/images/live_new_wallet.png"),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          const Text("Low Balance!"),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          const Text(
            // ignore: lines_longer_than_80_chars
            "A minimum balance of 5 minutes (₹125) is required to start the consultation with this astrologer.",
          ),
          DynamicHeightGridView(
            shrinkWrap: true,
            itemCount: _list.length,
            crossAxisCount: 4,
            builder: (BuildContext context, int index) {
              final LowBalanceModel item = _list[index];
              return InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 75 + 8,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            border:
                                Border.all(color: AppColors.appYellowColour),
                            color: AppColors.white.withOpacity(0.2),
                          ),
                          child: Center(child: Text(item.title)),
                        ),
                        Container(
                          height: 25,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            border:
                                Border.all(color: AppColors.appYellowColour),
                            color: AppColors.appYellowColour,
                          ),
                          child: Center(child: Text(item.subtitle)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LowBalanceModel {
  LowBalanceModel({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}
