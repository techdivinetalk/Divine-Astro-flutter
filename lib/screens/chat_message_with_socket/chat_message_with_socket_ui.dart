import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_message_with_socket_controller.dart';

class ChatMessageWithSocketUI extends GetView<ChatMessageWithSocketController> {
  const ChatMessageWithSocketUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
        return Container();
      }),
    );
  }
}
