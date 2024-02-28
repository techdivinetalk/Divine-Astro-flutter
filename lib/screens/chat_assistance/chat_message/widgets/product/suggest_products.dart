import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/appbar.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/custom_text_field.dart';
import '../../../../../common/routes.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../model/shop_model_response.dart';
import '../../../../../repository/shop_repository.dart';
import '../../../../../utils/load_image.dart';
import 'suggestProducts_controller.dart';


class SuggestProducts extends GetView<SuggestProductController> {
  const SuggestProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SuggestProductController(ShopRepository()));
    return GetBuilder<SuggestProductController>(
      builder: (controller) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: Obx(
              () => Container(
                color: appColors.guideColor,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    child: controller.isSearchEnable.value
                        ? searchWidget(const Color(0XFFFDD48E))
                        : commonAppbar(
                            title: "divineShop".tr,
                            trailingWidget: Row(children: [
                              // CustomButton(
                              //     onTap: () => Get.toNamed(RouteName.wallet),
                              //     radius: 10.r,
                              //     border: Border.all(color: appColors.darkBlue),
                              //     child: CustomText('₹${walletBalance.value}')),
                              SizedBox(width: 10.w),
                              InkWell(
                                  onTap: () {
                                    controller.isSearchEnable.value = true;
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Assets.images.icSearch.svg(
                                          colorFilter: ColorFilter.mode(
                                              appColors.darkBlue,
                                              BlendMode.srcIn))))
                            ]))),
              ),
            ),
          ),
          body: Obx(
            () => Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: controller.shopList.isEmpty
                        ? Center(
                            child:
                                SvgPicture.asset('assets/svg/Group 129525.svg'))
                        : GridView.builder(
                            itemCount: controller.searchShopList.isNotEmpty
                                ? controller.searchShopList.length
                                : controller.shopList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 25.h,
                                    childAspectRatio: 0.60,
                                    mainAxisSpacing: 30.h),
                            itemBuilder: (BuildContext context, int index) {
                              Shop item = (controller.searchShopList.isNotEmpty
                                  ? controller.searchShopList
                                  : controller.shopList)[index];
                              return InkWell(
                                onTap: () async {
                                  if(index == 0){
                                     Get.toNamed(
                                      RouteName.poojaDharamMainScreen,
                                     arguments: {  "customerId":controller.customerId.value,}
                                    );
                                  }else{
                                  Get.toNamed(
                                      RouteName.chatAssistProductSubPage,
                                      arguments: {
                                        "shodId": item.id,
                                        "productName": item.shopName,
                                        "customerId":controller.customerId.value,
                                      });}
                                },
                                child: Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 3.0,
                                        offset: const Offset(0.0, 3.0),
                                      ),
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
                                        child: LoadImage(
                                          boxFit: BoxFit.cover,
                                          imageModel: ImageModel(
                                            imagePath:
                                                '${controller.pref.getBaseImageURL()}/${item?.shopImage}',
                                            loadingIndicator: const SizedBox(
                                              child: CircularProgressIndicator(
                                                color: Color(0XFFFDD48E),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        item.shopName ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: appColors.darkBlue,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: appColors.brown,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Explore Now",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                                color: appColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchWidget(Color backgroundColor) {
    final searchController = TextEditingController();
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SizedBox(
          height: AppBar().preferredSize.height,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.isSearchEnable.value = false;
                  controller.searchShopList.clear();
                  //  controller.loadInit.value = false;
                  //   controller.webController.loadRequest(Uri.parse(controller.initWebURL));
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Expanded(
                  child: Card(
                      child: CustomTextField(
                autoFocus: true,
                align: TextAlignVertical.center,
                height: 40,
                onChanged: (value) {
                  controller.getSearchList(value);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                controller: searchController,
                inputBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.sp)),
                prefixIcon: null,
                suffixIcon: InkWell(
                    onTap: () {
                      //controller.getSearchList();
                    },
                    child: Assets.images.searchIcon.svg()),
                hintText: '${'search'.tr}...',
                suffixIconPadding: 0,
              ))),
              SizedBox(width: 20.w)
            ],
          ),
        ),
      ),
    );
  }
}
