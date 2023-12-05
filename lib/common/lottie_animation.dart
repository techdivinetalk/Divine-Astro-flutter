import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../gen/assets.gen.dart';

class ExclamationMark extends StatelessWidget {
  const ExclamationMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Assets.lottie.exclamationMark.lottie(
        width: 100,
        height: 100,
        repeat: true,
        frameRate: FrameRate(60),
        animate: true,
      ),
    );
  }
}
