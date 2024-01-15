import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class AstroWaitListWidget extends StatefulWidget {
  const AstroWaitListWidget({
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
    required this.model,
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
  final WaitListModel model;

  @override
  State<AstroWaitListWidget> createState() => _AstroWaitListWidgetState();
}

class _AstroWaitListWidgetState extends State<AstroWaitListWidget> {
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
          // height: Get.height / 2.24,
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
        children: <Widget>[
          const SizedBox(height: 32),
          widget.list.length >= 3
              ? SizedBox(height: Get.height / 3, child: listViewForWaitList())
              : listViewForWaitList(),
          const SizedBox(height: 16),
          listViewForNextInLine(),
          const SizedBox(height: 16),
          exitWidget(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget listViewForWaitList() {
    return widget.list.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Waitlist",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length - 1,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    final WaitListModel item = widget.list[index + 1];
                    return listTile(item: item);
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget listViewForNextInLine() {
    return widget.list.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Next In Line",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  final WaitListModel item = widget.list[index];
                  return listTile(item: item);
                },
              ),
            ],
          )
        : const SizedBox();
  }

  Widget listTile({required WaitListModel item}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CustomImageWidget(
            imageUrl: item.avatar,
            rounded: true,
            typeEnum: TypeEnum.user,
          ),
        ),
        title: Text(item.userName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            callTypeIcon(callType: item.callType),
            const SizedBox(width: 16),
            Text(
              getTotalWaitTime(
                int.parse(item.totalTime),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
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

  Widget exitWidget() {
    return widget.model.isEngaded && widget.model.id == widget.myUserId
        ? const SizedBox()
        : widget.isHost
            ? CommonButton(
                buttonCallback: widget.onAccept,
                buttonText: "Accept",
              )
            : widget.hasMyIdInWaitList
                ? TextButton(
                    onPressed: widget.onExitWaitList,
                    child: const Text(
                      "Exit Waitlist",
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox();
  }

  String getTotalWaitTime(totalMinutes) {
    String time = "";
    Duration duration = Duration(minutes: totalMinutes);
    String formattedTime = formatDuration(duration);
    time = formattedTime;
    return time;
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${_twoDigits(hours)}H ${_twoDigits(minutes)}M ${_twoDigits(seconds)}S';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }
}