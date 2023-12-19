import "dart:developer";

import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class CustomLottieWidget extends StatelessWidget {
  const CustomLottieWidget({
    required this.path,
    required this.fit,
    required this.height,
    required this.width,
    required this.repeat,
    required this.onLoaded,
    super.key,
  });

  final String path;
  final BoxFit fit;
  final double height;
  final double width;
  final bool repeat;
  final void Function(LottieComposition) onLoaded;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      path,
      fit: fit,
      height: height,
      width: width,
      repeat: repeat,
      frameRate: FrameRate.max,
      options: LottieOptions(),
      delegates: const LottieDelegates(),
      onWarning: log,
      alignment: Alignment.center,
      onLoaded: onLoaded,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return const Center(
          child: Icon(Icons.error),
        );
      },
    );
  }
}
