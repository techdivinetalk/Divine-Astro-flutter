import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/user_repository.dart';

class ScheduleTrainingController extends GetxController {
  UserRepository userRepository = UserRepository();
  // List of time slots with enabled/disabled status
  List<Map<String, dynamic>> times = [
    {"time": "09:00 AM", "isEnabled": true},
    {"time": "11:00 AM", "isEnabled": false},
    {"time": "01:00 PM", "isEnabled": true},
    {"time": "03:00 PM", "isEnabled": true},
  ];
  List<Map<String, dynamic>> times2 = [
    {"time": "05:00 PM", "isEnabled": true},
    {"time": "06:00 PM", "isEnabled": true},
    {"time": "07:00 PM", "isEnabled": false},
    {"time": "08:00 PM", "isEnabled": true},
  ];
  var selectedTime;
}
