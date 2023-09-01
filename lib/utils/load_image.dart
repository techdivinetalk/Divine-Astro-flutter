
import 'package:flutter/material.dart';

class ImageModel {
  const ImageModel({
    required this.imagePath,
    required this.loadingIndicator,
    this.placeHolderPath,
    this.assetImage = false,
  });

  final String imagePath;
  final Widget loadingIndicator;
  final String? placeHolderPath;
  final bool assetImage;
}

class LoadImage extends StatelessWidget {
  const LoadImage({
    Key? key,
    required this.imageModel,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  final ImageModel imageModel;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: getImageProvider(imageModel.assetImage),
      fit: boxFit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return frame == null
            ? Center(child: imageModel.loadingIndicator)
            : child;
      },
      errorBuilder: (context, error, stackTrace) {
        if (imageModel.placeHolderPath != null) {
          return Image.asset(imageModel.placeHolderPath!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  ImageProvider getImageProvider(bool value) {
    if (value) {
      return AssetImage(imageModel.imagePath);
    }
    return NetworkImage(imageModel.imagePath);
  }
}