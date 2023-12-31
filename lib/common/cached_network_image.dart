import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';

class CachedNetworkPhoto extends StatelessWidget {
  const CachedNetworkPhoto(
      {Key? key, this.url, this.width, this.height, this.fit})
      : super(key: key);
  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width?.w,
      height: height?.h,
      fit: fit ?? BoxFit.contain,
      imageUrl: url ?? "",
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Image.asset(Assets.images.defaultProfile.path),
    );
  }
}
