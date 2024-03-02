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
    required this.data,
    required this.onSelect,
    required this.onLeave,
    required this.onFollowAndLeave,
    super.key,
  });

  final void Function() onClose;
  final Map<dynamic, dynamic> data;
  final void Function(dynamic item) onSelect;
  final void Function() onLeave;
  final void Function() onFollowAndLeave;

  @override
  State<ShowAllAvailAstroWidget> createState() =>
      _ShowAllAvailAstroWidgetState();
}

class _ShowAllAvailAstroWidgetState extends State<ShowAllAvailAstroWidget> {
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
          child:  Icon(Icons.close, color: appColors.white),
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
          height: Get.height / 2,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white,
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
      itemCount: widget.data.length,
      crossAxisCount: 4,
      builder: (BuildContext context, int index) {
        final dynamic item = widget.data.values.elementAt(index);
        final String id = item["id"];
        final String name = item["name"];
        final String image = item["image"];
        final bool isAvailable = item["isAvailable"];
        final int isEngaged = item["isEngaged"];
        return InkWell(
          onTap: () {
            widget.onSelect(id);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: appColors.guideColor, width: 4),
                    color: appColors.guideColor.withOpacity(0.2),
                  ),
                  child: CustomImageWidget(
                    imageUrl: image,
                    rounded: true,
                    typeEnum: TypeEnum.user,
                  ),
                ),
                Positioned(
                  bottom: -5,
                  child: liveStack(),
                ),
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
        border: Border.all(color: appColors.white),
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
