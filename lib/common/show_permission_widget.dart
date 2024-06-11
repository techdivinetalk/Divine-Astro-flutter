import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'colors.dart';
import 'permission_handler.dart';

Future<void> showPermissionDialog({
  required String permissionName,
  required bool isForOverlayPermission,
}) async {
  await showCupertinoModalPopup(
    context: Get.context!,
    barrierColor: appColors.textColor.withOpacity(0.5),
    builder: (BuildContext context) {
      return PermissionDialog(
        permissionName: permissionName,
        isForOverlayPermission: isForOverlayPermission,
      );
    },
  );

  return Future<void>.value();
}