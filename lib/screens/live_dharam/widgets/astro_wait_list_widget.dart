import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_timer_countdown/flutter_timer_countdown.dart";
import "package:get/get.dart";
import "package:velocity_x/velocity_x.dart";

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
    required this.isInCall,
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
  final bool? isInCall;
  final void Function() onAccept;
  final void Function() onReject;
  final WaitListModel model;

  @override
  State<AstroWaitListWidget> createState() => _AstroWaitListWidgetState();
}

class _AstroWaitListWidgetState extends State<AstroWaitListWidget> {
  var newWaitListModels;
  @override
  Widget build(BuildContext context) {
    widget.list.sort((a, b) => a.startTime.compareTo(b.startTime));
    newWaitListModels = widget.list;
    for(int i =0;i < newWaitListModels.length;i++){
      print("newWaitListModels");
      print(newWaitListModels[i].startTime);
    }
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
          // height: Get.height / 2.24,
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
        children: <Widget>[
          const SizedBox(height: 32),


          listViewForNextInLine(),
          const SizedBox(height: 16),
          (newWaitListModels.length - 1) >= 3
              ? SizedBox(height: Get.height / 3, child: listViewForWaitList())
              : listViewForWaitList(),
          const SizedBox(height: 16),
          exitWidget(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget listViewForWaitList() {
    return newWaitListModels.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Waitlist",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              (newWaitListModels.length - 1) >= 3
                  ? Expanded(child: commonListView())
                  : commonListView(),
            ],
          )
        : const SizedBox();
  }

  Widget commonListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: newWaitListModels.length - 1,
      physics: const ScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        final WaitListModel item = newWaitListModels[index + 1];
        print("newWaitListModels1");
        print(item.startTime);
        return listTile(item: item);
      },
    );
  }

  Widget listViewForNextInLine() {
    return newWaitListModels.length > 0
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Next In Line",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          physics: const ScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            final WaitListModel item = newWaitListModels[index];
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
              getTotalWaitTime(item),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // newTimerWidget(item),
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
        ? !widget.isInCall! ? CommonButton(
      buttonCallback: widget.onAccept,
      buttonText: "Accept",
    ) :SizedBox()
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

  String getTotalWaitTime(WaitListModel item) {
    // final String source = item.totalTime;
    // final int epoch = int.parse(source);
    // final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    // final String formattedTime =
    //     "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    // return formattedTime;
    return item.totalMin > 1 ? "${item.totalMin} mins" : "${item.totalMin} min";
  }

// Widget newTimerWidget(WaitListModel item) {
//   final String source = item.totalTime;
//   final int epoch = int.parse(source);
//   final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
//   return TimerCountdown(
//     format: CountDownTimerFormat.hoursMinutesSeconds,
//     enableDescriptions: false,
//     spacerWidth: 4,
//     colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
//     timeTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
//     onTick: (Duration duration) async {},
//     endTime: dateTime,
//     onEnd: () {},
//   );
// }

// String getTotalWaitTime(totalMinutes) {
//   String time = "";
//   Duration duration = Duration(minutes: totalMinutes);
//   String formattedTime = formatDuration(duration);
//   time = formattedTime;
//   return time;
// }

// String formatDuration(Duration duration) {
//   int hours = duration.inHours;
//   int minutes = duration.inMinutes % 60;
//   int seconds = duration.inSeconds % 60;
//   return '${_twoDigits(hours)}H ${_twoDigits(minutes)}M ${_twoDigits(seconds)}S';
// }

// String _twoDigits(int n) {
//   if (n >= 10) {
//     return '$n';
//   } else {
//     return '0$n';
//   }
// }
}