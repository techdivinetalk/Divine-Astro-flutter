import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class WaitListWidget extends StatefulWidget {
  const WaitListWidget({
    required this.onClose,
    required this.waitTime,
    required this.myUserId,
    required this.list,
    required this.hasMyIdInWaitList,
    required this.onExitWaitList,
    required this.astologerName,
    required this.astologerImage,
    required this.astologerSpeciality,
    required this.isHost,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  final void Function() onClose;
  final String waitTime;
  final String myUserId;
  final List<WaitListModel> list;
  final bool hasMyIdInWaitList;
  final void Function() onExitWaitList;
  final String astologerName;
  final String astologerImage;
  final String astologerSpeciality;
  final bool isHost;
  final void Function() onAccept;
  final void Function() onReject;

  @override
  State<WaitListWidget> createState() => _WaitListWidgetState();
}

class _WaitListWidgetState extends State<WaitListWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[top(), const SizedBox(height: 64), bottom()],
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
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: Get.height / 2.24,
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
        ),
        Positioned(
          top: -50,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 100,
            width: 100,
            child: CustomImageWidget(
              imageUrl: widget.astologerImage,
              rounded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget grid() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 64 - 16),
            Text(
              widget.astologerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.astologerSpeciality,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/live_mini_hourglass.png"),
                const SizedBox(width: 4),
                const Text("Wait Time - "),
                const SizedBox(width: 4),
                Text(widget.waitTime),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            SizedBox(
              height: Get.height / 3.0,
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  final WaitListModel item = widget.list[index];
                  return listTile(item: item);
                },
              ),
            ),
            exitWidget(),
          ],
        ),
      ),
    );
  }

  Widget listTile({required WaitListModel item}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 50,
        width: 50,
        child: CustomImageWidget(imageUrl: item.avatar, rounded: true),
      ),
      title: Text(item.userName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          callTypeIcon(callType: item.callType),
          const SizedBox(width: 16),
          Text(item.totalTime),
        ],
      ),
    );
  }

  Widget callTypeIcon({required String callType}) {
    String returnString = "assets/images/live_call_video.png";
    switch (callType) {
      case "video":
        returnString = "assets/images/live_call_video.png";
        break;
      case "audio":
        returnString = "assets/images/live_call_audio.png";
        break;
      case "private":
        returnString = "assets/images/live_call_private.png";
        break;
    }
    return Image.asset(returnString);
  }

  // Widget exitWidget() {
  //   return widget.isHost
  //       ? Column(
  //           children: <Widget>[
  //             const SizedBox(height: 8),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: TextButton(
  //                     onPressed: widget.onReject,
  //                     child: const Text(
  //                       "Reject",
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: TextButton(
  //                     onPressed: widget.onAccept,
  //                     child: const Text(
  //                       "Accept",
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 8),
  //           ],
  //         )
  //       : widget.hasMyIdInWaitList
  //           ? Column(
  //               children: <Widget>[
  //                 const SizedBox(height: 8),
  //                 TextButton(
  //                   onPressed: widget.onExitWaitList,
  //                   child: const Text(
  //                     "Exit Waitlist",
  //                     style: TextStyle(
  //                       color: Colors.red,
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: Colors.red,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //               ],
  //             )
  //           : const SizedBox();
  // }

  Widget exitWidget() {
    return widget.hasMyIdInWaitList
        ? Column(
            children: <Widget>[
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onExitWaitList,
                child: const Text(
                  "Exit Waitlist",
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          )
        : const SizedBox();
  }
}
