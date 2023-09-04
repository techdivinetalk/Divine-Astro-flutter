import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../model/performance_model_class.dart';

class RankSystemController extends GetxController {

  List<RankSystem>? rankSystemList = <RankSystem>[];

  var dataImage = [Assets.images.icDiamond.image(height: 21.h, width: 21.h),];

  var systemRankList = <SystemRankModelClass>[
    SystemRankModelClass(
      "90%+",
      "diamond".tr,
      Assets.images.icDiamond.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "89-80%",
      "platinum".tr,
      Assets.images.icPlatinum.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "79-70%",
      "gold".tr,
      Assets.images.icGold.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "69-60%",
      "silver".tr,
      Assets.images.icSilver.image(height: 21.h, width: 21.h),
    ),
    SystemRankModelClass(
      "59-36%",
      "bronze".tr,
      Assets.images.icBronze.image(height: 21.h, width: 21.h),
    ),

    SystemRankModelClass(
      "Less than 35%",
      "unranked".tr,
      null,
    ),
  ].obs;
}

class SystemRankModelClass {
  String? percentage, astrologerRank;
  Image? image;

  SystemRankModelClass(this.percentage, this.astrologerRank, this.image);
}
