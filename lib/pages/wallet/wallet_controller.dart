import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/wallet/wallet_model.dart';
import 'package:divine_astrologer/repository/wallet_page_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {

  final WalletListRepo walletRepository = Get.put(WalletListRepo());
  Rx<PayoutDetails> walletListRepo = PayoutDetails().obs;
  Loading loading = Loading.initial;
 // RxInt orderList = 7.obs;

 /* ScrollController orderScrollController = ScrollController();
  ScrollController amountScrollController = ScrollController();
  List<String> amountTypeList = [
    "availableBalance".tr,
    "pgCharges".tr,
    "subTotal".tr,
    "tds".tr,
    "totalAmount".tr
  ];*/

  @override
  void onInit() {
    super.onInit();
    getWalletDetailsApi();
  }


  getWalletDetailsApi() async {
    loading = Loading.loading;
    update();
    try {
      PayoutDetails response = await walletRepository.walletPayOutDetails();
      walletListRepo.value = response;
      print("Walet Data:: ${walletListRepo.value.toJson()}");
      loading = Loading.loaded;
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
      loading = Loading.loaded;
    }
    update();
  }
}
