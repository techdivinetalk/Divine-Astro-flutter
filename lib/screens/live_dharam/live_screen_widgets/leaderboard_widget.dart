import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderBoardWidget extends StatelessWidget {
  const LeaderBoardWidget({
    required this.avatar,
    required this.userName,
    required this.fullGiftImage,
    required this.astrologerName,
    super.key,
  });

  final String avatar;
  final String userName;
  final String fullGiftImage;
  final String astrologerName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: fullGiftImage.isEmpty ? Get.width / 2.0 : Get.width / 1.5,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.white,
                    AppColors.yellow,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                border: Border.all(
                  color: AppColors.yellow,
                ),
                color: AppColors.yellow,
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        border: Border.all(
                          color: AppColors.yellow,
                        ),
                        color: AppColors.black.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: CustomImageWidget(
                          imageUrl: avatar,
                          rounded: true,
                          typeEnum: TypeEnum.user,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: fullGiftImage.isEmpty
                          ? [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'is $astrologerName Live Star',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          : [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        border: Border.all(
                          color: AppColors.transparent,
                        ),
                        color: AppColors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: fullGiftImage.isEmpty
                            ? Image.asset(
                                "assets/images/live_new_astro_live_star.png",
                              )
                            : CustomImageWidget(
                                imageUrl: fullGiftImage,
                                rounded: false,
                                typeEnum: TypeEnum.gift,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            child: Image.asset("assets/images/live_seperated_crown.png"),
          )
        ],
      ),
    );
  }
}
