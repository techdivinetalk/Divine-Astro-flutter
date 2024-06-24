import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../repository/user_repository.dart';

class NewLeaveController extends GetxController {
  NewLeaveController(this.userRepository);

  final UserRepository userRepository;
  RxBool status = false.obs;
}
