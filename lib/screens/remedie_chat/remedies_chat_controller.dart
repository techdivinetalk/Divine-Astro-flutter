import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RemediesChatController extends GetxController {
  final UserRepository repository;
  RemediesChatController(this.repository);
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxBool chatEnded = false.obs;
  RxList templates = ["Add", "Welcome Message", "Welcome Message"].obs;
  RxList messages = [
    {
      "id": 1,
      "sent_by": "RB",
      "from": "another",
      "message":
          "Thank you for placing an order with us! Please note that this order is non-refundable, as your free will can influence the spell's effectiveness. We cannot guarantee any specific date or timeframe for results to manifest. Please confirm if you would like to proceed. Within 24 hours, the healer will provide you with an auspicious date, time, and mode of communication to initiate the spell through this chat.",
      "time": DateTime.now(),
    },
    {
      "id": 1,
      "sent_by": "RB",
      "from": "me",
      "message": "Hi",
      "time": DateTime.now(),
    },
    {
      "id": 1,
      "sent_by": "RB",
      "from": "another",
      "message": "Hello",
      "time": DateTime.now(),
    },
    {
      "id": 1,
      "sent_by": "RB",
      "from": "another",
      "message":
          "Thank you for placing an order with us! Please note that this order is non-refundable, as your free will can influence the spell's effectiveness. We cannot guarantee any specific date or timeframe for results to manifest. Please confirm if you would like to proceed. Within 24 hours, the healer will provide you with an auspicious date, time, and mode of communication to initiate the spell through this chat.",
      "time": DateTime.now(),
    },
    {
      "id": 1,
      "sent_by": "RB",
      "from": "me",
      "message": "Hi",
      "time": DateTime.now(),
    },
    {
      "id": 1,
      "sent_by": "RB",
      "from": "another",
      "message": "Hello",
      "time": DateTime.now(),
    },
  ].obs;
}
