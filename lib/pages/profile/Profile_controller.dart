import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';
import '../../gen/assets.gen.dart';

class ProfilePageController extends GetxController {

  changeLanguagePopup(BuildContext context) async {
    await openBottomSheet(context,
      functionalityWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                Text(
                  'Choose Your App Language',
                  style: AppTextStyle.textStyle20(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  height: 270.h,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 30.h,
                      crossAxisSpacing: 30.h,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => LanguageWidget(index: index),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: AppColors.lightYellow,
                  minWidth: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: const StadiumBorder(),
                  child: Text(
                    'Set Language',
                    style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600,fontColor: AppColors.brownColour),


                  ),
                ),
              ],
            ),
          ),
        ],
      ),);
  }

  var profileList = <ProfileOptionModelClass>[
    ProfileOptionModelClass(
        "Bank Details",
        Assets.images.icBankDetailNew.svg(width: 30.h, height: 30.h),
        '/bankDetailsUI'),
    ProfileOptionModelClass("upload story",
        Assets.images.icUploadStory.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass("Upload your photo",
        Assets.images.icUploadPhoto.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass("Customer Support",
        Assets.images.icSupportTeam.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass(
        "Choose Language",
        Assets.images.icLanguages.svg(width: 30.h, height: 30.h),
        '/languagePopup'),
    ProfileOptionModelClass(
        "F&Q", Assets.images.icFaqImg.svg(width: 30.h, height: 30.h), ''),
    ProfileOptionModelClass(
        "Price Change",
        Assets.images.icPriceChangeNew.svg(width: 30.h, height: 30.h),
        '/priceChangeReqUI'),
    ProfileOptionModelClass(
        "Number Change",
        Assets.images.icNumChanges.svg(width: 30.h, height: 30.h),
        '/numberChangeReqUI'),
    ProfileOptionModelClass(
        "Blocked user",
        Assets.images.icBlockUserNew.svg(width: 30.h, height: 30.h),
        '/blockedUser'),
  ].obs;





}

class ProfileOptionModelClass {
  String? name;
  Widget? widget;
  String? nav;

  ProfileOptionModelClass(this.name, this.widget, this.nav);
}
