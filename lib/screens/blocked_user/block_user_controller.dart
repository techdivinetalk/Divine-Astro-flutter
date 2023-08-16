import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/res_blocked_customers.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';

class BlockUserController extends GetxController {
  BlockUserController(this.userRepository);
  final UserRepository userRepository;
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  RxBool blockedUserDataSync = false.obs;
  ResBlockedCustomers? blockedUserData;

  @override
  void onInit() {
    super.onInit();

    userData = preferenceService.getUserDetail();
    getBlockedCustomerList();
  }

  getBlockedCustomerList() async {
    Map<String, dynamic> params = {"role_id": userData?.roleId ?? 0};
    try {
      blockedUserData = await userRepository.getBlockedCustomerList(params);
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    blockedUserDataSync.value = true;
  }

  unblockUser({required num customerId}) async {
    Map<String, dynamic> params = {
      "role_id": userData?.roleId ?? 0,
      "customer_id": customerId,
      "is_block": 0
    };
    try {
      ResBlockedCustomers response =
          await userRepository.blockUnblockCustomer(params);

      Get.back();
      CustomException(response.message ?? "");
      getBlockedCustomerList();
    } catch (error) {
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
    blockedUserDataSync.value = true;
  }
}
