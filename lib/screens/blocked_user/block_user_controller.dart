import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/res_blocked_customers.dart';
import '../../repository/user_repository.dart';

class BlockUserController extends GetxController {
  BlockUserController(this.userRepository);
  final UserRepository userRepository;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  void onInit() {
    super.onInit();
    debugPrint("");
    // getBlockedCustomerList();
  }

  getBlockedCustomerList() async {
    Map<String, dynamic> params = {"role_id": 7};
    try {
      ResBlockedCustomers data =
          await userRepository.getBlockedCustomerList(params);
      debugPrint("Data $data");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }
}
