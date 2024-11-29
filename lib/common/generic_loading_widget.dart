import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GenericLoadingWidget extends StatelessWidget {
  const GenericLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.lottie.loading2.lottie(width: 100.w),
          Text("pleaseWait".tr),
        ],
      ),
    );
  }
}
