import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_get_shop.dart';
import '../../../model/res_login.dart';
import '../../../repository/shop_repository.dart';

class SuggestRemediesSubController extends GetxController {
  final ShopRepository shopRepository;
  SuggestRemediesSubController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  RxBool shopDataSync = false.obs;

  ShopData? shopData;

  var item = [
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
    ['Navgrah Shanti Pooja', "Starting from ₹15000"],
  ];

//API Call
  getShopData() async {
    Map<String, dynamic> params = {
      "role_id": userData?.roleId ?? 0,
      "order_id": 100
    };
    try {
      var response = await shopRepository.getShopData(params);
      shopData = response.data;
      shopDataSync.value = true;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    userData = preferenceService.getUserDetail();
    getShopData();
  }
}
