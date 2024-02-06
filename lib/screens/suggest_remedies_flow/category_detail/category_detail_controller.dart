import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../model/res_product_detail.dart';
import '../../../repository/shop_repository.dart';

class CategoryDetailController extends GetxController {
  final ShopRepository shopRepository;
  CategoryDetailController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();
  Products? productDetail;
  SaveRemediesResponse? saveRemediesResponse;
  RxBool productListSync = false.obs;
  RxBool shopDataSync = false.obs;
  int? productId;
  int? orderId;
  int? shopId;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      productId = Get.arguments["productId"];
      orderId = Get.arguments["orderId"];
      if (productId != null) {
        getProductDetails();
      }
    }
    //getProductDetails();
  }

  getProductDetails() async {
    Map<String, dynamic> params = {"product_id": productId};
    try {
      var response = await shopRepository.getProductDetail(params);
      productDetail = response.data!.products![0];
      shopId = productDetail?.prodShopId;
      shopDataSync.value = true;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
    productListSync.value = true;
  }

  suggestRemedy() async {
    Map<String, dynamic> params = {"product_id": productId, "shop_id": shopId, "order_id": orderId};
    try {
      var response = await shopRepository.saveRemedies(params);
      saveRemediesResponse = response;
      Get.offNamedUntil(RouteName.orderHistory, ModalRoute.withName(RouteName.dashboard));
      shopDataSync.value = true;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  int selectedQuantity = 0;
  incrementQuantity() {
    selectedQuantity++;
    update();
  }

  decrementQuantity() {
    if (selectedQuantity > 0) {
      selectedQuantity--;
      update();
    }
  }
}
