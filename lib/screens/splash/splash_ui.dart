import 'package:divine_astrologer/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashUI extends GetView<SplashController> {
  const SplashUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Image.asset(
        "assets/images/splash_bg.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
