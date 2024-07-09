import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../repository/user_repository.dart';

class SupportController extends GetxController {
  SupportController(this.userRepository);
  final UserRepository userRepository;

  List<Map<String, dynamic>> tickets = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Map<String, dynamic> data = {
    //   "id": "1",
    //   "title": "How to earn more money?",
    //   "date_time": "20 December 1989, 04:32 AM",
    //   "status": "Closed",
    // };
    List<Map<String, dynamic>> t = [
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Closed",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Open",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Pending",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Closed",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Open",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Pending",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Closed",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Open",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Pending",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Closed",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Open",
      },
      {
        "id": "1",
        "title": "How to earn more money?",
        "date_time": "20 December 1989, 04:32 AM",
        "status": "Pending",
      },
    ];

    tickets = t;
  }
}
