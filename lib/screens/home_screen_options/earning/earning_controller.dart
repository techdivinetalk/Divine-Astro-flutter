import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class YourEarningController extends GetxController {
  ScrollController earningScrollController = ScrollController();
  List<String> earningList = [
    "totalEarning".tr,
    "chatEarning".tr,
    "callEarning".tr,
    "reportEarning".tr,
    "suggestedRemediesEarning".tr
  ];
  List<SvgPicture> earningImgList = [
    Assets.images.icCalc.svg(),
    Assets.images.icChat.svg(),
    Assets.images.icCall.svg(),
    Assets.images.icReport.svg(),
    Assets.images.icEcommerce.svg(),
  ];
}
