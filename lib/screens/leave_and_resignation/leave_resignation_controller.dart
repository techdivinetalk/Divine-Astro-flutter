import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../repository/user_repository.dart';

class LeaveAndResignationController extends GetxController {
  LeaveAndResignationController(this.userRepository);
  final UserRepository userRepository;

  TabController? tabbarController;
  int initialPage = 0;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
