import 'dart:io';

import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomProductController extends GetxController {
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();

  CustomProductData? customProductData;
  final userRepository = UserRepository();
  String productImageUrl = "";
  String productApiPath = "";
  XFile? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;
  bool isLoading = false;

  addCustomProduct() async {
    isLoading = true;
    update();
    try {
      Map<String, dynamic> body = {
        "prod_name": productName.text,
        "prod_image": productApiPath,
        "product_price": productPrice.text,
      };
      final response = await userRepository.customeEcommerceApi(body);

      if (response.data != null) {
        isLoading = false;
        await Future.delayed(const Duration(milliseconds: 200));
        Get.back();
        update();
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
