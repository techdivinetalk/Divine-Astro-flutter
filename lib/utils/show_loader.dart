import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoader() async {
  return await showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => kDebugMode,
      child: Container(
        color: Colors.black26,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    ),
  );
}
