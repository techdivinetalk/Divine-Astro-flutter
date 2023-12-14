import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    required this.imageUrl,
    super.key,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (BuildContext context, String url) {
        return const CircularProgressIndicator();
      },
      errorWidget: (BuildContext context, String url, Object error) {
        return const Icon(Icons.error);
      },
    );
  }
}
