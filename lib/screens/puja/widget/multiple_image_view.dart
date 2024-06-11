
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/screens/puja/widget/lottie_widget.dart';
import 'package:divine_astrologer/screens/puja/widget/svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../gen/assets.gen.dart';

class MultipleTypeImageView extends StatelessWidget {

  final String? imageUrlData;
  final double? height;
  final double? width;
  final BorderRadius? radius;
  final Function(int)? onTapOfLottie;
  const MultipleTypeImageView({super.key, this.onTapOfLottie, this.imageUrlData, this.height, this.width, this.radius});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        Widget content;

        String url =  imageUrlData!;
        String imageType;

        const String textJson = ".json";
        const String imageUrl = ".svg";
        const String svgaUrl = ".svga";

        if (url.contains(textJson)) {
          print("is it json ??");
          imageType = 'json';
        } else if (url.contains(svgaUrl)) {
          imageType = 'svga';
        } else if (url.contains(imageUrl)) {
          imageType = 'svg';
        } else {
          // Add more conditions for other image types if needed
          imageType = 'other';
        }

        switch (imageType) {
          case 'json':
            // content = Lottie.network(
            //   url,
            //   fit: BoxFit.cover,
            //   repeat: true,
            //   reverse: false,
            //   animate: true,
            //
            // );
            content = MyLottieWidget(
              borderRadius: radius,
              onTap: onTapOfLottie!,
              url: url,
            );
            break;
          case 'svga':

            content = SvgaPicture(
              image: url,
              reverse: false,
            );
            break;
          case 'svg':
            content = SvgImageBanner(
              imageUrl: url, onTap: () {  }, // Replace with the actual URL
            );
            break;

          default:
            print(url);
            print("urlurlurlurlurlurlurl");
            content = Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r)),
              child: CommonImageView(
                imagePath: url,
                radius: BorderRadius.circular(12.r),
                placeHolder:  Assets.images.defaultProfile.path,
                // placeholderWidget: Container(
                //   color: appColors.guideColor.withOpacity(0.4),
                // ),
              ),
            );
            break;
        }
        return content;
      },
    );
  }
}
