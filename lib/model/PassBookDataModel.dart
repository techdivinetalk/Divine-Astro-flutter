/// success : true
/// status_code : 200
/// data : "<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\" style=\"width: 100%; border-collapse: collapse;\">\n                    <thead>\n                        <tr style=\"background-color: #f2f2f2;\">\n                            <th>Date</th>\n                            <th>Total Amount (INR)</th>\n                            <th>Deduction (TDS+PG) (INR)</th>\n                            <th>Payable Amount (INR)</th>\n                        </tr>\n                    </thead>\n                    <tbody></tbody></table>"
/// message : "Passbook Detail Fetch SuccuessFully"

class PassBookDataModel {
  PassBookDataModel({
    bool? success,
    num? statusCode,
    String? data,
    String? message,
  }) {
    _success = success;
    _statusCode = statusCode;
    _data = data;
    _message = message;
  }

  PassBookDataModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['status_code'];
    _data = json['data'];
    _message = json['message'];
  }
  bool? _success;
  num? _statusCode;
  String? _data;
  String? _message;
  PassBookDataModel copyWith({
    bool? success,
    num? statusCode,
    String? data,
    String? message,
  }) =>
      PassBookDataModel(
        success: success ?? _success,
        statusCode: statusCode ?? _statusCode,
        data: data ?? _data,
        message: message ?? _message,
      );
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['status_code'] = _statusCode;
    map['data'] = _data;
    map['message'] = _message;
    return map;
  }
}
