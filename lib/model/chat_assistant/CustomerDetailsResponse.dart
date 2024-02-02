class CustomerDetailsResponse {
  final List<ConsultationData> data;
  final bool success;
  final int statusCode;
  final String message;

  CustomerDetailsResponse({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsResponse(
      data: List<ConsultationData>.from(json['data'].map((x) => ConsultationData.fromJson(x))),
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }
}

class ConsultationData {
  final int userId;
  final int astrologerId;
  final int totalConsultation;
  final String lastConsulted;
  final int customerId;
  final String customerName;
  final int customerNo;
  final String customerImage;
  final String customerEmail;
  final String daySinceLastConsulted;

  ConsultationData({
    required this.userId,
    required this.astrologerId,
    required this.totalConsultation,
    required this.lastConsulted,
    required this.customerId,
    required this.customerName,
    required this.customerNo,
    required this.customerImage,
    required this.customerEmail,
    required this.daySinceLastConsulted,
  });

  factory ConsultationData.fromJson(Map<String, dynamic> json) {
    return ConsultationData(
      userId: json['user_id'],
      astrologerId: json['astrologer_id'],
      totalConsultation: json['total_consulation'],
      lastConsulted: json['last_consulted'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerNo: json['customer_no'],
      customerImage: json['customer_image'],
      customerEmail: json['customer_email'],
      daySinceLastConsulted: json['day_since_last_consulted'],
    );
  }
}
