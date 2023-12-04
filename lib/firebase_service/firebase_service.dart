import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppFirebaseService {
  AppFirebaseService._privateConstructor();

  static final AppFirebaseService _instance = AppFirebaseService._privateConstructor();

  factory AppFirebaseService() {
    return _instance;
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).set(data);
    } catch (e) {
      debugPrint('Error writing data to the database: $e');
    }
  }

  readData(String path) async {
    try {
      _database.child(path).onValue.listen((event) {
        debugPrint('real time $path ---> ${event.snapshot.value}');
        Map<dynamic, dynamic>? notifications = (event.snapshot.value as Map<dynamic, dynamic>?);
        if (notifications != null) {
          notifications.forEach((key, value) {
            _showLocalNotification(value);
          });
        }
      });
    } catch (e) {
      debugPrint('Error reading data from the database: $e');
      return null;
    }
  }

  void _showLocalNotification(Map<dynamic, dynamic>? data) {
    if (data != null) {
      String message = data['message'];

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var android = const AndroidNotificationDetails("DivineAstrologer", "AstrologerNotification",
          importance: Importance.high);
      //    var iOS = IOSNotificationDetails();
      var platform = NotificationDetails(android: android);

      flutterLocalNotificationsPlugin.show(
        0,
        'Notification',
        message,
        platform,
      );
    }
  }
}
