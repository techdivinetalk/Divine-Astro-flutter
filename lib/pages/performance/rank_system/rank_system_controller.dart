import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class RankSystemController extends GetxController {
  var systemRankList = <SystemRankModelClass>[
    SystemRankModelClass(
      "90%+",
      "Diamond",
      Assets.images.icDiamond.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "89-80%",
      "Platinum",
      Assets.images.icPlatinum.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "79-70%",
      "Gold",
      Assets.images.icGold.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "69-60%",
      "Silver",
      Assets.images.icSilver.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "59-36%",
      "Bronze",
      Assets.images.icBronze.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "90%+",
      "Diamond",
      Assets.images.icDiamond.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "Less than 35%",
      "Unranked",
      null,
    ),
  ].obs;
}

class SystemRankModelClass {
  String? percentage, astrologerRank;
  Image? image;

  SystemRankModelClass(this.percentage, this.astrologerRank, this.image);
}
