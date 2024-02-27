import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../common/app_exception.dart';
import '../../../../../di/shared_preference_service.dart';
import '../../../../../model/res_login.dart';
import '../../../../../model/res_product_list.dart';
import '../../../../../repository/shop_repository.dart';

class SubProductController extends GetxController {
  final ShopRepository shopRepository;
  SubProductController(this.shopRepository);
  UserData? userData;
  RxString productName = ("suggestRemedies".tr).obs;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  ProductData? productList;
  var searchProductList = <Products>[].obs;
  RxBool productListSync = false.obs;
  int shopId = 10;
  RxInt customerId = 0.obs;
  int? orderId;

  RxBool isSearchEnable = RxBool(false);

  var item = [
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      shopId = Get.arguments["shodId"];
      // orderId = Get.arguments["orderId"];
      customerId(Get.arguments["customerId"]);
      productName(Get.arguments["productName"]);
      userData = preferenceService.getUserDetail();
      getProductList();
    }
  }

  getProductList() async {
    Map<String, dynamic> params = {"shop_id": shopId};
    try {
      var response = await shopRepository.getProductList(params);
      productList = response.data;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    productListSync.value = true;
  }

  void getSearchList(String query) {
    if (query.isNotEmpty) {
      List<Products> searchResult = productList?.products
              ?.where((product) =>
                  product.prodName
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false)
              .toList() ??
          [];
      searchProductList.assignAll(searchResult);
    } else {
      searchProductList.clear();
    }
  }
}
