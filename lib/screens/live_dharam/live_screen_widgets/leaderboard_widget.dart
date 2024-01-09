import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LeaderBoardWidget extends StatelessWidget {
  const LeaderBoardWidget({
    required this.avatar,
    required this.userName,
    required this.fullGiftImage,
    super.key,
  });

  final String avatar;
  final String userName;
  final String fullGiftImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: Get.width / 3,
      child: Stack(
        children: [
          Image.asset(
            height: 32,
            width: Get.width / 3,
            fit: BoxFit.contain,
            "assets/images/live_leaderboard_crown.png",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 2),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CustomImageWidget(
                    imageUrl: avatar,
                    rounded: true,
                    typeEnum: TypeEnum.user,
                  ),
                ),
                Flexible(
                  child: Align(
                    child: Text(
                      userName,
                      style: const TextStyle(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: fullGiftImage.isNotEmpty,
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CustomImageWidget(
                      imageUrl: fullGiftImage,
                      rounded: false,
                      typeEnum: TypeEnum.gift,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
