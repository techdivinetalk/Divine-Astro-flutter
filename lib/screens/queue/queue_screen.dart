import 'package:divine_astrologer/screens/queue/queue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QueueScreen extends GetView<QueueController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QueueController>(
      assignId: true,
      init: QueueController(),
      builder: (controller) {
        return const Scaffold();
      },
    );
  }
}
