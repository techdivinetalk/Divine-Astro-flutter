class AgreementModel {
  final Status? status;
  final AgreementData? data;

  AgreementModel({
    this.status,
    this.data,
  });

  AgreementModel.fromJson(Map<String, dynamic> json)
      : status = (json['status'] as Map<String, dynamic>?) != null
            ? Status.fromJson(json['status'] as Map<String, dynamic>)
            : null,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? AgreementData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'status': status?.toJson(), 'data': data?.toJson()};
}

class Status {
  final int? code;
  final String? message;

  Status({
    this.code,
    this.message,
  });

  Status.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {'code': code, 'message': message};
}

class AgreementData {
  final String? pdfLink;
  final String? imageLink;
  final String? signLink;

  AgreementData({
    this.pdfLink,
    this.imageLink,
    this.signLink,
  });

  AgreementData.fromJson(Map<String, dynamic> json)
      : pdfLink = json['pdfLink'] as String?,
        imageLink = json['ImageLink'] as String?,
        signLink = json['SignLink'] as String?;

  Map<String, dynamic> toJson() => {
        'pdfLink': pdfLink,
        'ImageLink': imageLink,
        'SignLink': signLink,
      };
}
