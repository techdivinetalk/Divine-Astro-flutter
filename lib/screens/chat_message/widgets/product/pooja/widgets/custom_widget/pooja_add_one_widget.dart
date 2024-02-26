import "dart:ui";

import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../../../../common/colors.dart";
import "../../pooja_dharam/get_pooja_addones_response.dart";
import "pooja_common_list.dart";
import "pooja_custom_button.dart";

class PoojaAddOneWidget extends StatefulWidget {
  PoojaAddOneWidget({
    required this.onClose,
    required this.addOnesList,
    super.key,
  });

  final void Function() onClose;
  final List<GetPoojaAddOnesResponseData> addOnesList;

  @override
  State<PoojaAddOneWidget> createState() => _PoojaAddOneWidgetState();
}

class _PoojaAddOneWidgetState extends State<PoojaAddOneWidget> {
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
          height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.guideColor),
            color: appColors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Select Add-Ons",
                  style: TextStyle(
                    color: appColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: grid()),
                const SizedBox(height: 16),
                PoojaCustomButton(
                  height: 64,
                  text: "Add",
                  backgroundColor: appColors.guideColor,
                  fontColor: appColors.black,
                  needCircularBorder: false,
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget grid() {
    return PoojaCommonList(
      list: widget.addOnesList,
      scrollPhysics: const ScrollPhysics(),
      onTap: () => setState(() {}),
    );
  }
}
