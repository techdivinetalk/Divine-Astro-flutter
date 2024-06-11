import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';

class CustomProductListModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<CustomProductData>? data;

  CustomProductListModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  CustomProductListModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => CustomProductData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'success' : success,
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

