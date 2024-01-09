import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/utils.dart";

enum TypeEnum { user, gift }

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    required this.imageUrl,
    required this.rounded,
    required this.typeEnum,
    super.key,
  });

  final String imageUrl;
  final bool rounded;
  final TypeEnum typeEnum;

  @override
  Widget build(BuildContext context) {
    return rounded
        ? CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            radius: 50,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(50),
                child: dec(),
              ),
            ),
          )
        : dec();
  }

  Widget dec() {
    Widget widget = const SizedBox();
    switch (typeEnum) {
      case TypeEnum.user:
        widget = GetUtils.isURL(imageUrl) ? cachedNetworkImage() : assetImage();
        break;
      case TypeEnum.gift:
        widget = GetUtils.isURL(imageUrl) ? cachedNetworkImage() : assetImage();
        break;
    }
    return widget;
  }

  Widget cachedNetworkImage() {
    Widget widget = const SizedBox();
    switch (typeEnum) {
      case TypeEnum.user:
        widget = CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          // progressIndicatorBuilder: (context, string, progress) {
          //   // return SizedBox();
          //   return assetImage();
          // },
          placeholder: (BuildContext context, String url) {
            // return const CupertinoActivityIndicator();
            return assetImage();
          },
          errorWidget: (BuildContext context, String url, Object error) {
            // return const Icon(Icons.error);
            return assetImage();
          },
          memCacheWidth: 100,
          memCacheHeight: 100,
          maxHeightDiskCache: 100,
          maxWidthDiskCache: 100,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: true,
          errorListener: (e) => print("errorListener: $e"),
        );
        break;
      case TypeEnum.gift:
        widget = CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          // progressIndicatorBuilder: (context, string, progress) {
          //   // return SizedBox();
          //   return assetImage();
          // },
          placeholder: (BuildContext context, String url) {
            // return const CupertinoActivityIndicator();
            return assetImage();
          },
          errorWidget: (BuildContext context, String url, Object error) {
            // return const Icon(Icons.error);
            return assetImage();
          },
          memCacheWidth: 100,
          memCacheHeight: 100,
          maxHeightDiskCache: 100,
          maxWidthDiskCache: 100,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: true,
          errorListener: (e) => print("errorListener: $e"),
        );
        break;
    }
    return widget;
  }

  Widget assetImage() {
    Widget widget = const SizedBox();
    switch (typeEnum) {
      case TypeEnum.user:
        widget = Image.asset(
          "assets/images/default_profile.png",
          fit: BoxFit.fill,
        );
        break;
      case TypeEnum.gift:
        widget = Image.asset(
          "assets/images/live_new_gift_latest.png",
          fit: BoxFit.fill,
        );
        break;
    }
    return widget;
  }

  Widget networkImage() {
    Widget widget = const SizedBox();
    switch (typeEnum) {
      case TypeEnum.user:
        widget = Image.network(
          imageUrl,
          fit: BoxFit.fill,
        );
        break;
      case TypeEnum.gift:
        widget = Image.network(
          imageUrl,
          fit: BoxFit.fill,
        );
        break;
    }
    return widget;
  }
}
