import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../model/res_product_list.dart';
import '../../../repository/shop_repository.dart';

class SuggestRemediesSubController extends GetxController {
  final ShopRepository shopRepository;
  SuggestRemediesSubController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  ProductData? productList;
  RxBool productListSync = false.obs;
  int shopId = 10;

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
      shopId = Get.arguments;
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
        Get.snackbar("Error", error.toString()).show();
      }
    }
    productListSync.value = true;
  }
}
