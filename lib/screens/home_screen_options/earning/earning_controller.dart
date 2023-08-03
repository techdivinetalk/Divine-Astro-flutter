import 'package:divine_astrologer/common/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class YourEarningController extends GetxController {
  ScrollController earningScrollController = ScrollController();
  List<String> earningList = [
    AppString.totalEarning,
    AppString.chatEarning,
    AppString.callEarning,
    AppString.reportEarning,
    AppString.suggestedRemediesEarning
  ];
  List<SvgPicture> earningImgList = [
    Assets.images.icCalc.svg(),
    Assets.images.icChat.svg(),
    Assets.images.icCall.svg(),
    Assets.images.icReport.svg(),
    Assets.images.icEcommerce.svg(),
  ];
}
