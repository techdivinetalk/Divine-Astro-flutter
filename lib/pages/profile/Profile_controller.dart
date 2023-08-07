

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';

class ProfilePageController extends GetxController {

  var profileList = <ProfileOptionModelClass>[
    ProfileOptionModelClass("Bank Details", Assets.images.icBankDetailNew.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("upload story", Assets.images.icUploadStory.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Upload your photo", Assets.images.icUploadPhoto.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Customer Support", Assets.images.icSupportTeam.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Choose Language", Assets.images.icLanguages.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("F&Q", Assets.images.icFaqImg.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Price Change", Assets.images.icPriceChangeNew.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Number Change", Assets.images.icNumChanges.svg(width: 30.h,height: 30.h)),
    ProfileOptionModelClass("Blocked user", Assets.images.icBlockUserNew.svg(width: 30.h,height: 30.h)),

  ].obs;

}

class ProfileOptionModelClass {
  String? name;
  Widget? widget;

  ProfileOptionModelClass(this.name, this.widget);
}
