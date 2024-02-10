import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../pages/profile/profile_page_controller.dart';
import '../../../../repository/user_repository.dart';

class LanguageBottomSheetWidget extends StatelessWidget {
  const LanguageBottomSheetWidget({
    Key? key,
    this.onChangedLanguage,
  }) : super(key: key);

  final void Function()? onChangedLanguage;

  @override
  Widget build(BuildContext context) {
    Get.put(ProfilePageController(Get.put(UserRepository())));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: appColors.white, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                color: appColors.white.withOpacity(0.1)),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
            color: appColors.white,
          ),
          child: Column(
            children: [
              Text(
                'chooseYourAppLanguage'.tr,
                style: AppTextStyle.textStyle20(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 32.h),
              GetBuilder<ProfilePageController>(builder: (controller) {
                return SizedBox(
                  child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 30.h,
                        crossAxisSpacing: 30.h,
                      ),
                      itemCount: controller.languageList.length,
                      itemBuilder: (context, index) {
                        ChangeLanguageModelClass item =
                            controller.languageList[index];
                        return GetBuilder<ProfilePageController>(
                            id: "set_language",
                            builder: (controller) {
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedLanguageData(item);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: item.isSelected
                                          ? Border.all(
                                              width: 1, color: Colors.grey)
                                          : Border.all(
                                              width: 0, color: Colors.white)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          item.colors!.withOpacity(0),
                                          item.colors!.withOpacity(0.2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.languagesMain.toString(),
                                              style: AppTextStyle.textStyle20(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              item.languages.toString(),
                                              style: AppTextStyle.textStyle16(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                );
              }),
              SizedBox(height: 30.h),
              GetBuilder<ProfilePageController>(
                  id: "set_lang",
                  builder: (controller1) {
                    return InkWell(
                      onTap: () {
                        controller1.getSelectedLanguage();
                        onChangedLanguage!();
                        Get.back();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: appColors.lightYellow,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Center(
                            child: Text(
                              'okay'.tr,
                              style: AppTextStyle.textStyle16(
                                  fontWeight: FontWeight.w600,
                                  fontColor: appColors.brownColour),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
