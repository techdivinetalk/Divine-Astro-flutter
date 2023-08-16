import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../model/res_product_list.dart';
import '../../../repository/shop_repository.dart';

class FinalRemediesSubController extends GetxController {
  final ShopRepository shopRepository;
  FinalRemediesSubController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  ProductData? productList;
  RxBool productListSync = false.obs;
  var item = [
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
  ];

  @override
  void onInit() {
    super.onInit();
    userData = preferenceService.getUserDetail();
    getProductList();
  }

  getProductList() async {
    Map<String, dynamic> params = {"shop_id": 10};
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
