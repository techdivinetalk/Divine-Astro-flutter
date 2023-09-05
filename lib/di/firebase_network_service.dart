// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseNetworkService extends GetxService {
  final StreamController<bool?> _onDatabaseConnected =
      StreamController.broadcast();

  Stream<bool?> get databaseConnectionStream => _onDatabaseConnected.stream;

  Future<FirebaseNetworkService> init() async {
    // DatabaseReference firebaseDatabase = FirebaseDatabase.instanceFor(
    //         app: Firebase.app(),
    //         databaseURL: "https://divine2-0-uat-default-rtdb.firebaseio.com/")
    //     .ref(".info/connected");

    FirebaseDatabase firebaseDatabase = FirebaseDatabase(
        databaseURL: "https://divine2-0-uat-default-rtdb.firebaseio.com/");

    Stream<DatabaseEvent> infoConnect =
        firebaseDatabase.ref().child(".info/connected").onValue;

    Stream<DatabaseEvent> randomCheck =
        firebaseDatabase.ref().child("astrologer/9/watcher").onValue;

    infoConnect.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      _onDatabaseConnected.sink.add(connected);
      if (connected) {
        debugPrint("You are Connected.");
      } else {
        debugPrint("You DisConnected");
      }
    });
    randomCheck.listen((event) {
      debugPrint("Value has been updated: ${event.snapshot.value}");
    });

    return this;
  }
}
