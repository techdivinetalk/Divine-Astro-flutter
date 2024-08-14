import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonImageView extends StatelessWidget {
  final String? imagePath;

  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final Widget? placeholderWidget;

  CommonImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.placeholderWidget,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/default_profile.png',
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: BoxFit.cover,
              color: color,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!.replaceAll("file://", "")),
            height: height,
            width: width,
            fit: BoxFit.cover,
            color: color,
          );
        case ImageType.httpSvg:
          return SvgPicture.network(
            imagePath!,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: BoxFit.cover,
            imageUrl: imagePath!,
            color: color,
            placeholder: (context, url) => SizedBox(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) =>
                placeholderWidget ??
                Center(
                  child: placeHolder.contains("images")
                      ? Image.asset(
                          placeHolder,
                          height: height,
                          width: width,
                        )
                      : SvgPicture.asset(
                          placeHolder,
                          // height: height,
                          // width: width,
                          fit: BoxFit.cover,
                        ),
                ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: BoxFit.cover,
            color: color,
          );
      }
    }
    return SizedBox();
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      if (this.endsWith(".svg")) {
        return ImageType.httpSvg;
      } else {
        return ImageType.network;
      }
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown, httpSvg }
