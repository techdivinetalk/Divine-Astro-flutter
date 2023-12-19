import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    required this.imageUrl,
    required this.rounded,
    super.key,
  });

  final String imageUrl;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        rounded ? 50.0 : 0.0,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (BuildContext context, String url) {
          return const CupertinoActivityIndicator();
        },
        errorWidget: (BuildContext context, String url, Object error) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}
