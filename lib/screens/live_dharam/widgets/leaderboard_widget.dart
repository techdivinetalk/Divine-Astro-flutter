import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({
    required this.onClose,
    required this.list,
    super.key,
  });

  final void Function() onClose;
  final List<LeaderboardModel> list;

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
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
            color: AppColors.white.withOpacity(0.2),
          ),
          child: grid(),
        ),
      ),
    );
  }

  Widget grid() {
    return ListView.builder(
      itemCount: widget.list.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        final LeaderboardModel item = widget.list[index];
        return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: AppColors.appYellowColour),
            color: AppColors.white,
          ),
          child: ListTile(
            dense: true,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: AppColors.white,
                  foregroundImage: (index == 0 || index == 1 || index == 2)
                      ? AssetImage(
                          index == 0
                              ? Assets.images.liveFirstMedal.path
                              : index == 1
                                  ? Assets.images.liveSecondMedal.path
                                  : index == 2
                                      ? Assets.images.liveThirdMedal.path
                                      : "",
                        )
                      : null,
                  child: (index != 0 && index != 1 && index != 2)
                      ? Text(index.toString())
                      : null,
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  child: CustomImageWidget(imageUrl: item.avatar),
                ),
              ],
            ),
            title: Text(item.userName),
            subtitle: Text("₹ ${item.amount}"),
          ),
        );
      },
    );
  }
}
