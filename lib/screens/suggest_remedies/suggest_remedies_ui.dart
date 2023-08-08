import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/appbar.dart';
import '../../common/colors.dart';
import '../../common/strings.dart';
import '../../gen/assets.gen.dart';
import '../side_menu/side_menu_ui.dart';
import 'suggest_remedies_controller.dart';

class SuggestRemediesUI extends GetView<SuggestRemediesController> {
  const SuggestRemediesUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideMenuDrawer(),
        backgroundColor: AppColors.white,
        appBar: commonAppbar(
            title: AppString.suggestRemedy,
            trailingWidget: InkWell(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Assets.images.icSearch.svg(color: AppColors.darkBlue)),
            )),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: GridView.builder(
                    itemCount: controller.item.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 25.h,
                        childAspectRatio: 0.75,
                        mainAxisSpacing: 30.h),
                    itemBuilder: (BuildContext context, int index) {
                      var item = controller.item[index];
                      return InkWell(
                        onTap: (){
                          Get.toNamed(RouteName.suggestRemediesSubUI);
                        },
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 3.0)),
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Assets.images.bgSuggestedRemedy
                                    .image(fit: BoxFit.fill),
                              ),
                              SizedBox(height: 8.h),
                              Text(item.first,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                    color: AppColors.darkBlue,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
