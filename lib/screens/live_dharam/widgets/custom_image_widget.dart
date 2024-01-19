import "package:cached_network_image/cached_network_image.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

enum TypeEnum { user, gift }

class CustomImageWidget extends StatelessWidget {
  CustomImageWidget({
    required this.imageUrl,
    required this.rounded,
    required this.typeEnum,
    super.key,
  });

  final String imageUrl;
  final bool rounded;
  final TypeEnum typeEnum;

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

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
    final bool condition1 = imageUrl == "${_pref.getAmazonUrl()}";
    final bool condition2 = imageUrl == "${_pref.getAmazonUrl()}/";
    final bool condition3 =
        imageUrl == "https://divinenew-prod.s3.ap-south-1.amazonaws.com";
    final bool condition4 =
        imageUrl == "https://divinenew-prod.s3.ap-south-1.amazonaws.com/";
    Widget widget = const SizedBox();
    switch (typeEnum) {
      case TypeEnum.user:
        widget = GetUtils.isURL(imageUrl)
            ? (condition1 || condition2)
                ? assetImage()
                : cachedNetworkImage()
            : assetImage();
        break;
      case TypeEnum.gift:
        widget = GetUtils.isURL(imageUrl)
            ? (condition1 || condition2 || condition3 || condition4)
                ? assetImage()
                : cachedNetworkImage()
            : assetImage();
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
          placeholder: (BuildContext context, String url) {
            return assetImage();
          },
          errorWidget: (BuildContext context, String url, Object error) {
            return assetImage();
          },
          memCacheWidth: 100,
          memCacheHeight: 100,
          maxHeightDiskCache: 100,
          maxWidthDiskCache: 100,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: false,
          errorListener: (e) => print("errorListener: $e"),
        );
        break;
      case TypeEnum.gift:
        widget = CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          placeholder: (BuildContext context, String url) {
            return assetImage();
          },
          errorWidget: (BuildContext context, String url, Object error) {
            return assetImage();
          },
          memCacheWidth: 100,
          memCacheHeight: 100,
          maxHeightDiskCache: 100,
          maxWidthDiskCache: 100,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: false,
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
