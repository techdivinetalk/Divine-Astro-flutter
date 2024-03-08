import 'package:divine_astrologer/repository/wallet_page_repository.dart';
import 'package:get/get.dart';
import 'wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletController());
  }
}
