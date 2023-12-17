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
        ),
        Positioned(
          top: -50,
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 50,
            child: CustomImageWidget(
              imageUrl: widget.astologerImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget grid() {
    // final Data data = widget.details.data ?? Data();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 64 - 16),
            Text(widget.astologerName),
            const SizedBox(height: 8),
            Text(widget.astologerSpeciality),
            const SizedBox(height: 8),
            Text(widget.waitTime),
            const SizedBox(height: 8),
            const Divider(),
            SizedBox(
              height: Get.height / 3,
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  final WaitListModel item = widget.list[index];
                  return listTile(item: item);
                },
              ),
            ),
            const Divider(),
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
      leading: CircleAvatar(
        child: CustomImageWidget(imageUrl: item.avatar),
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

    return CircleAvatar(
      backgroundColor: AppColors.white,
      child: Image.asset(returnString),
    );
  }

  Widget exitWidget() {
    return widget.hasMyIdInWaitList
        ? Column(
            children: <Widget>[
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onExitWaitList,
                child: const Text("Exit Waitlist"),
              ),
              const SizedBox(height: 8),
            ],
          )
        : const SizedBox();
  }
}
