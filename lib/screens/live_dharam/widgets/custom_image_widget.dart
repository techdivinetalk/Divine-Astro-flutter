import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

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
                child: cachedNetworkImage(),
              ),
            ),
          )
        : cachedNetworkImage();
  }

  Widget cachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (BuildContext context, String url) {
        return const CupertinoActivityIndicator();
      },
      errorWidget: (BuildContext context, String url, Object error) {
        return const Icon(Icons.error);
      },
      memCacheWidth: 100,
      memCacheHeight: 100,
      maxHeightDiskCache: 100,
      maxWidthDiskCache: 100,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
    );
  }
}
