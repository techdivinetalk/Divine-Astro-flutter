import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../firebase_service/firebase_service.dart';
import 'common_functions.dart';

class GlobalLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        break;
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  void onAppResumed() {
    // Handle app resume event
    debugPrint("App has been resumed.");
    AppFirebaseService().database.child("astrologer/${preferenceService.getUserDetail()!.id}/realTime/TimeManage").set(ServerValue.timestamp);
    // You can add more logic here, e.g., refresh data or restart services
  }

  void onAppInactive() {
    // Handle app inactive event
    debugPrint("App is inactive.");
  }

  void onAppPaused() {
    // Handle app pause event
    debugPrint("App is paused.");
  }

  void onAppDetached() {
    // Handle app detached event
    debugPrint("App is detached.");
  }
}
