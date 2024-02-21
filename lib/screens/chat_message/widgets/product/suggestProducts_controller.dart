import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/res_get_shop.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/app_exception.dart';
import '../../../../common/colors.dart';
import '../../../../common/common_functions.dart';
import '../../../../model/shop_model_response.dart';
import '../../../../repository/shop_repository.dart';
import '../../../../repository/user_repository.dart';
import '../../../../utils/enum.dart';

class SuggestProductController extends GetxController{
  final ShopRepository shopRepository;
  SuggestProductController(this.shopRepository);

  var shopList = <Shop>[].obs;
  var searchShopList = <Shop>[].obs;
  var imageUrl = "";

  Loading loading = Loading.initial;
  RxBool isSearchEnable = RxBool(false);
  int? orderId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      orderId = Get.arguments;
    }
    userData = preferenceService.getUserDetail();
    getShopList();
  }

  getShopList() async {
    Map<String, dynamic> params = {};
    try {
      ResGetShop data = await shopRepository.getShopData(params);
      print ('Shop Data :: $data');
      if (data.data!.shops != null && data.data!.shops!.isNotEmpty) {
        shopList.addAll(data.data!.shops as Iterable<Shop>);
        log("Shop-->${jsonEncode(data.data)}");
      }
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }


  void getSearchList(String query) {
    if (query.isNotEmpty) {
      List<Shop> searchResult =
      shopList.where((shop) => shop.shopName!.toLowerCase().contains(query.toLowerCase())).toList();
      searchShopList.assignAll(searchResult);
    } else {
      searchShopList.clear();
    }
  }
}