import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageWithSocketController extends GetxController {
  final socket = AppSocket();

  @override
  void onInit() {
    super.onInit();
    socket.startAstroCustumerSocketEvent(orderId: '18');
    socket.isAstroJoinedChat((data) {
      debugPrint('private chat Joined event $data');
    });
  }
}
