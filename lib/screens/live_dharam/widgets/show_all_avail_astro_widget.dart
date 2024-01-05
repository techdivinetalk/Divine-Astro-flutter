import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ShowAllAvailAstroWidget extends StatefulWidget {
  const ShowAllAvailAstroWidget({
    required this.onClose,
    required this.list,
    required this.onSelect,
    required this.onLeave,
    required this.onFollowAndLeave,
    super.key,
  });

  final void Function() onClose;
  final List<dynamic> list;
  final void Function(dynamic item) onSelect;
  final void Function() onLeave;
  final void Function() onFollowAndLeave;

  @override
  State<ShowAllAvailAstroWidget> createState() =>
      _ShowAllAvailAstroWidgetState();
}

class _ShowAllAvailAstroWidgetState extends State<ShowAllAvailAstroWidget> {
  List<String> availAstroList = [
    "https://robohash.org/01",
    "https://robohash.org/02",
    "https://robohash.org/03",
    "https://robohash.org/04",
    "https://robohash.org/05",
    "https://robohash.org/06",
    "https://robohash.org/07",
    "https://robohash.org/08",
    "https://robohash.org/09",
    "https://robohash.org/10",
    "https://robohash.org/01",
    "https://robohash.org/02",
    "https://robohash.org/03",
    "https://robohash.org/04",
    "https://robohash.org/05",
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
          height: Get.height / 2.25,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.yellow),
            color: AppColors.white,
          ),
          child: grid(),
        ),
      ),
    );
  }

  Widget grid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          const Text(
            "Check Other Live Sessions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: dynamicHeightGridView()),
          Row(
            children: <Widget>[
              Expanded(
                child: CommonButtonGrey(
                  buttonText: "Leave",
                  buttonCallback: widget.onLeave,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonButton(
                  buttonText: "Follow & leave",
                  buttonCallback: widget.onFollowAndLeave,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget dynamicHeightGridView() {
    return DynamicHeightGridView(
      itemCount: availAstroList.length,
      crossAxisCount: 4,
      builder: (BuildContext context, int index) {
        final String item = availAstroList[index];
        return InkWell(
          onTap: () {
            widget.onSelect(item);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: AppColors.yellow, width: 4),
                    color: AppColors.yellow.withOpacity(0.2),
                  ),
                  child: CustomImageWidget(imageUrl: item, rounded: true),
                ),
                Positioned(bottom: -5, child: liveStack()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget liveStack() {
    return Container(
      height: 30,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(color: AppColors.white),
        color: const Color(0xFFDEFFE1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: Colors.green, size: 10),
          Text("Live"),
        ],
      ),
    );
  }
}
