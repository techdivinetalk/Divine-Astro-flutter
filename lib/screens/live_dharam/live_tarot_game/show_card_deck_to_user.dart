import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ShowCardDeckToUser extends StatefulWidget {
  const ShowCardDeckToUser({
    required this.onClose,
    required this.onSelect,
    required this.userName,
    super.key,
  });

  final void Function() onClose;
  final void Function(int value) onSelect;
  final String userName;

  @override
  State<ShowCardDeckToUser> createState() => _ShowCardDeckToUserState();
}

class _ShowCardDeckToUserState extends State<ShowCardDeckToUser> {
  final List<int> numList = [1, 3, 5];
  int? value;

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
          // height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: appColors.yellow),
            color: appColors.white.withOpacity(0.2),
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
          Text(
            "Show Card Deck to User",
            style: TextStyle(fontSize: 20, color: appColors.white),
          ),
          // const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: numList.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                groupValue: value,
                onChanged: (ind) => setState(() => value = ind),
                title: Text(
                  "Ask user to choose ${numList[index]} cards",
                  style: TextStyle(color: appColors.white),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                toggleable: true,
                activeColor: appColors.yellow,
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: appColors.white),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: ListTile(
              title: Text(
                widget.userName,
                style: TextStyle(fontSize: 20, color: appColors.white),
              ),
              subtitle: Text(
                "05 M 30 S",
                style: TextStyle(color: appColors.white),
              ),
              trailing: SizedBox(height: 50, width: 100, child: button()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all(
          value == null ? appColors.grey : appColors.yellow,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
      onPressed: () {
        if (value != null) {
          widget.onSelect(numList[value ?? 0]);
        } else {}
      },
      child: Text(
        'Send',
        style: TextStyle(
          color: value == null ? appColors.white : appColors.black,
        ),
      ),
    );
  }
}
