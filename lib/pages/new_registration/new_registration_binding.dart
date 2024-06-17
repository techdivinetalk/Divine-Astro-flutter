import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'new_registration_controller.dart';

class RegistrationBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<NewRegistrationController>(() => NewRegistrationController());
  }
}