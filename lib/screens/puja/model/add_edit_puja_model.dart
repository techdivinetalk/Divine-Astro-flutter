import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';

class AddEditPujaModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final PujaListingData? data;

  AddEditPujaModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  AddEditPujaModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String,dynamic>?) != null ? PujaListingData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'status_code' : statusCode,
    'message' : message,
    'data' : data?.toJson()
  };
}

