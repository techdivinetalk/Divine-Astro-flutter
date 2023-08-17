import 'package:get/get.dart';

import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../repository/shop_repository.dart';

class FinalRemediesSubController extends GetxController {
  final ShopRepository shopRepository;
  FinalRemediesSubController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  var item = [
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
    ['By Pushpak', "₹15000"],
  ];
}
