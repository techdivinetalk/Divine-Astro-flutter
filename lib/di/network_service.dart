import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
/// This class checks if device has internet connectivity or not
///
///

class NetworkService extends GetxService {
  final StreamController<bool?> _onInternetConnected =
      StreamController.broadcast();

  Stream<bool?> get internetConnectionStream => _onInternetConnected.stream;

  Connectivity connectivity = Connectivity();

  bool? _isInternetConnected;

  Future<NetworkService> init() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    await _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      // if (Constants.isTestingMode) {
      //   debugPrint("test_result: ${result.toString()}");
      //
      //   if (result == ConnectivityResult.wifi ||
      //       result == ConnectivityResult.mobile) {
      //     toast("ON");
      //   } else {
      //     toast("OFF");
      //   }
      // }
      _checkStatus(result);
    });
    return this;
  }

  Future<bool?> isConnected() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return await _checkStatus(result);
  }

  Future<bool?> _checkStatus(ConnectivityResult result) async {
    bool? isInternet = false;
    switch (result) {
      case ConnectivityResult.wifi:
        isInternet = true;
        break;
      case ConnectivityResult.mobile:
        isInternet = true;
        break;
      case ConnectivityResult.none:
        isInternet = false;
        break;
      default:
        isInternet = false;
        break;
    }
    if (isInternet) isInternet = await _updateConnectionStatus();
    if (_isInternetConnected == null || _isInternetConnected != isInternet) {
      _isInternetConnected = isInternet;
      _onInternetConnected.sink.add(isInternet);
    }
    debugPrint("test_isInternet: $isInternet");
    return isInternet;
  }

  Future<bool?> _updateConnectionStatus() async {
    bool? isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  disposeStream() {
    _onInternetConnected.close();
  }
}
