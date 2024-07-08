import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_socket/app_socket.dart';

class FirebaseNetworkService extends GetxService {
  final StreamController<bool?> _onDatabaseConnected =
      StreamController.broadcast();

  Stream<bool?> get databaseConnectionStream => _onDatabaseConnected.stream;

  Future<FirebaseNetworkService> init() async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    firebaseDatabase.ref().child(".info/connected").onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      _onDatabaseConnected.sink.add(connected);
      if (connected) {
        debugPrint("You are Connected.");
        AppSocket().socketConnect();

      } else {
        debugPrint("You DisConnected");
      }
    });

    return this;
  }
}
