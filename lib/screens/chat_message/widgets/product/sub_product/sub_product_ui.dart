import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/screens/chat_message/widgets/product/sub_product/sub_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../common/appbar.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/custom_text_field.dart';
import '../../../../../gen/assets.gen.dart';

class SubProductUi extends GetView<SubProductController> {
  const SubProductUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColors.white,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: Obx(() {
            return AnimatedContainer(
              duration: Duration(milliseconds: 100),
              child: controller.isSearchEnable.value
                  ? searchWidget(const Color(0XFFFDD48E))
                  : commonAppbar(
                      title: controller.productName.value ?? '',
                      trailingWidget: InkWell(
                        onTap: () {
                          controller.isSearchEnable.value = true;
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Assets.images.icSearch.svg(
                                colorFilter: ColorFilter.mode(
                                    appColors.darkBlue, BlendMode.srcIn))),
                      )),
            );
          }),
        ),
        body: Column(
          children: [
            Obx(() => controller.productListSync.value == true
                ? controller.productList?.products?.isEmpty ?? true
                    ? Center(
                        child: SvgPicture.asset('assets/svg/Group 129525.svg'))
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: GridView.builder(
                              itemCount: controller.searchProductList.isNotEmpty
                                  ? controller.searchProductList.length
                                  : controller.productList?.products?.length ??
                                      0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 25.h,
                                      childAspectRatio: 0.70,
                                      mainAxisSpacing: 30.h),
                              itemBuilder: (BuildContext context, int index) {
                                var item = (controller
                                        .searchProductList.isNotEmpty
                                    ? controller.searchProductList
                                    : controller.productList?.products)?[index];
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(RouteName.categoryDetail,
                                        arguments: {
                                          "productId": item?.id,
                                          "isChatAssist": true,
                                          "isSentMessage": false,
                                          "customerId":controller.customerId.value
                                        });
                                  },
                                  child: Container(
                                    // width: 300,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${controller.preferenceService.getBaseImageURL()}/${item?.prodImage}",
                                            fit: BoxFit.fill,
                                            errorWidget:
                                                (context, url, error) => Assets
                                                    .images.defaultProfile
                                                    .image(),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(item?.prodName ?? "",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: appColors.blackColor,
                                              )),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text("₹ ${item?.productPriceInr}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: appColors.lightGrey,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                : const SizedBox())
          ],
        ));
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
                  controller.searchProductList.clear();
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
