import 'dart:async';
import 'package:get/get.dart';

class ProgressService extends GetxService {
  var showProgress = false.obs;

  Future<ProgressService> init() async{
    return this;
  }

  showProgressDialog(bool show) {
    showProgress.value = show;
  }
}