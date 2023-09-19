import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../model/res_product_detail.dart';
import '../../../repository/shop_repository.dart';

class CategoryDetailController extends GetxController {
  final ShopRepository shopRepository;
  CategoryDetailController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  ProductDetailData? productDetail;
  RxBool productListSync = false.obs;
  @override
  void onInit() {
    super.onInit();
    getProductDetails();
  }

  getProductDetails() async {
    Map<String, dynamic> params = {"product_id": 56};
    try {
      var response = await shopRepository.getProductDetail(params);
      productDetail = response.data;
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(),color: AppColors.redColor);
      }
    }
    productListSync.value = true;
  }
}
