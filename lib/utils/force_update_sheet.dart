import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateSheet extends StatelessWidget {
  const ForceUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(48),
            ),
          ),
          child: Column(
            children: [
              Assets.images.updateSvg.svg(),
              Text(
                "New Version is Available!",
                style: AppTextStyle.textStyle20(
                  fontColor: appColors.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "We recommend you to update your Divine App to the latest version to continue using the services.",
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14(
                  fontColor: appColors.lightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  urlLuncher(url:Uri.parse(ApiProvider.playStoreLiveUrl));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.guideColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    "Update Now",
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> urlLuncher({Uri? url}) async {
    if (!await launchUrl(url!)) {
      throw Exception('Could not launch $url');
    }
  }
}
