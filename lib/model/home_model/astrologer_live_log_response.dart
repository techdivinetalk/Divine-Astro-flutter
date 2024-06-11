class AstrologerLiveLogResponse {
  final List<LiveLogModel>? data;
  final bool? success;
  final int? statusCode;
  final String? message;

  AstrologerLiveLogResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  AstrologerLiveLogResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)
            ?.map(
                (dynamic e) => LiveLogModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'success': success,
        'status_code': statusCode,
        'message': message
      };
}

class LiveLogModel {
  final int? id;
  final int? astrologerId;
  dynamic checkIn;
  dynamic checkOut;
  final int? type;
  dynamic hours;
  dynamic createdAt;
  final String? updatedAt;
  final int? roleId;

  LiveLogModel({
    this.id,
    this.astrologerId,
    this.checkIn,
    this.checkOut,
    this.type,
    this.hours,
    this.createdAt,
    this.updatedAt,
    this.roleId,
  });

  LiveLogModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        astrologerId = json['astrologer_id'] as int?,
        checkIn = json['check_in'] == null ? "" : json['check_in'].toString(),
        checkOut =
            json['check_out'] == null ? "" : json['check_out'].toString(),
        type = json['type'] as int?,
        hours = json['hours'] == null ? "" : json['hours'].toString(),
        createdAt =
            json['created_at'] == null ? "" : json['created_at'].toString(),
        updatedAt = json['updated_at'] as String?,
        roleId = json['role_id'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'astrologer_id': astrologerId,
        'check_in': checkIn,
        'check_out': checkOut,
        'type': type,
        'hours': hours,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'role_id': roleId
      };
}
