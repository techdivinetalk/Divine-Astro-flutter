import 'dart:convert';


WalletPointResponse walletResponseFromJson(String str) =>
    WalletPointResponse.fromJson(json.decode(str));

String walletResponseToJson(WalletPointResponse data) =>
    json.encode(data.toJson());

class WalletPointResponse {
  final List<WalletPoint> data;
  final bool success;
  final int statusCode;
  final String message;

  WalletPointResponse({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory WalletPointResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'];
    List<WalletPoint> data = jsonData.map((item) => WalletPoint.fromJson(item)).toList();

    return WalletPointResponse(
      data: data,
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'success': success,
      'status_code': statusCode,
      'message': message,
    };
  }
}

class WalletPoint {
  final int id;
  final String title;
  final int point;
  final int sequence;

  WalletPoint({
    required this.id,
    required this.title,
    required this.point,
    required this.sequence,
  });

  factory WalletPoint.fromJson(Map<String, dynamic> json) {
    return WalletPoint(
      id: json['id'] as int,
      title: json['title'] as String,
      point: json['point'] as int,
      sequence: json['sequence'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'point': point,
      'sequence': sequence,
    };
  }
}

