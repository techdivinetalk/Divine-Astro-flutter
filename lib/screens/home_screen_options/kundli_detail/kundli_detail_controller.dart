import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class KundliDetailController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<Widget> detailPageImage = [
    Assets.images.icGirlKundli.svg(),
    Assets.images.icWedding.svg(width: 87.w, height: 87.h),
    Assets.images.icMoon.svg(width: 87.w, height: 87.h),
    Assets.images.icSun.svg(width: 87.w, height: 87.h),
    Assets.images.icMars.image(width: 87.w, height: 87.h),
    Assets.images.icSwastika.svg(width: 87.w, height: 87.h),
    Assets.images.icGanesh.svg(width: 87.w, height: 87.h),
    Assets.images.icEye.svg(width: 87.w, height: 87.h),
  ];
}
