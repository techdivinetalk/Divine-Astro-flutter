import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      // width: width?.w,
      // height: height?.h,
      fit: fit ?? BoxFit.contain,
      imageUrl: url!,
      imageBuilder: (context, imageProvider) => Container(
        width: height,
        height: width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        width: height,
        height: width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Image.asset("assets/images/default.png", fit: BoxFit.cover),
      ),
    );
  }
}
