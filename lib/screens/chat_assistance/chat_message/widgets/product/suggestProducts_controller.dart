import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_functions.dart';
import '../../../../../di/shared_preference_service.dart';
import '../../../../../model/shop_model_response.dart' as shop;
import '../../../../../repository/shop_repository.dart';
import '../../../../../repository/user_repository.dart';

class SuggestProductController extends GetxController {
  SuggestProductController(this.shopRepository);

  final ShopRepository shopRepository;
  var shopList = <shop.Shop>[].obs;
  var searchShopList = <shop.Shop>[].obs;
  var banner = <Banner>[].obs;
  var imageUrl = "";
  RxInt customerId = 0.obs;
  var pref = Get.find<SharedPreferenceService>();
  var isLoading = false.obs;

  final UserRepository userRepository = Get.put(UserRepository());
  // final FirebaseEvent firebaseEvent = Get.find<FirebaseEvent>();

  RxBool isSearchEnable = RxBool(false);

  @override
  void onReady() {
    imageUrl = pref.getAmazonUrl()!;
    print("image url in suggest Product ${imageUrl}");

    if (Get.arguments != null) {
      customerId(Get.arguments['customerId']);
    }
    getShopList();
    super.onReady();
  }

  getShopList() async {
    isLoading(true);
    Map<String, dynamic> params = {"role_id": 7};
    try {
      shop.ShopModel data = await shopRepository.getShopList(params);
      print('Shop Data :: $data');
      // if (data.data!.banner != null && data.data!.banner!.isNotEmpty) {
      //   banner.addAll(data.data!.banner as Iterable<Banner>);
      // }
      if (data.data!.shops != null && data.data!.shops!.isNotEmpty) {
        shopList.addAll(data.data!.shops as Iterable<shop.Shop>);
        isLoading(false);

        // shopList.removeAt(0);
        log("Shop-->${jsonEncode(data.data)}");
      }
    } catch (error) {
      if (error is AppException) {
        isLoading(false);

        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  void getSearchList(String query) {
    if (query.isNotEmpty) {
      List<shop.Shop> searchResult = shopList
          .where((shop) =>
              shop.shopName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchShopList.assignAll(searchResult);
    } else {
      searchShopList.clear();
    }
  }
}
