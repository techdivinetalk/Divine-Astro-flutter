import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/save_remedies_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
import '../../../firebase_service/firebase_service.dart';
import '../../../model/res_login.dart';
import '../../../model/res_product_detail.dart';
import '../../../repository/shop_repository.dart';

class CategoryDetailController extends GetxController {
  final ShopRepository shopRepository;
  CategoryDetailController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  Products? productDetail;
  SaveRemediesResponse? saveRemediesResponse;
  RxBool productListSync = false.obs;
  RxBool isLoading = false.obs;
  int? productId;
  int? customerId;
  int? orderId;
  RxBool isChatAssist = false.obs;
  RxBool isSentMessage = false.obs;
  int? shopId;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      print("Get.arguments value ${Get.arguments}");
      productId = int.parse( Get.arguments["productId"].toString());
      customerId = int.parse( Get.arguments["customerId"].toString());
      isSentMessage( Get.arguments["isSentMessage"]);
      isSentMessage.value
          ? null
          : isChatAssist(Get.arguments["isChatAssist"] ?? false);
      isSentMessage.value
          ? null
          : isChatAssist.value
              ? null
              : orderId = Get.arguments["orderId"];

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
      isLoading.value = true;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    productListSync.value = true;
  }

  suggestRemedy() async {
    Map<String, dynamic> params = {
      "product_id": productId,
      "shop_id": shopId,
      "order_id": orderId
    };
    try {
      var response = await shopRepository.saveRemedies(params);
      saveRemediesResponse = response;
      Get.offNamedUntil(
          RouteName.orderHistory, ModalRoute.withName(RouteName.dashboard));
      isLoading.value = true;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  saveRemedyForChatAssist() async {
    Map<String, dynamic> params = {
      "product_id": productId,
      "shop_id": shopId,
      "order_id":AppFirebaseService().orderData.value["orderId"],
      "customer_id":AppFirebaseService().orderData.value["userId"] == null ? null: int.parse(AppFirebaseService().orderData.value["userId"]),
    };
    print('save remedy called $params}');
    try {
      var response = await shopRepository.saveRemediesForChatAssist(params);
      saveRemediesResponse = response;
      // Get.offNamedUntil(RouteName.orderHistory, ModalRoute.withName(RouteName.dashboard));
      isLoading.value = true;
      Get.back();
      Get.back();
      Get.back();
      Get.back(result: {
        'isPooja':false,
        'saveRemedies': saveRemediesResponse,
        'product_detail': productDetail
      });
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  int selectedQuantity = 1;
  incrementQuantity() {
    selectedQuantity++;
    update();
  }

  decrementQuantity() {
    if (selectedQuantity > 1) {
      selectedQuantity--;
      update();
    }
  }
}
