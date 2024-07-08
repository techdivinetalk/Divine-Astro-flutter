import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../maintenance_msg.dart';

final MessageController messageController = Get.find<MessageController>();

void serverUnderMaintenancePopup(String message) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    print("🤑🤑🤑🤑🤑🤑🤑🤑🤑🤑");
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      // Prevents closing the popup by tapping outside
      builder: (BuildContext context) {
        return PopScope(
          canPop:false,
          child: AlertDialog(
            title: const Text('Notification'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                  SystemNavigator.pop(); // Close the app
                },
              ),
            ],
          ),
        );
      },
    );
  });
}