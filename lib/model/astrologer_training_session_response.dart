class AstrologerTrainingSessionResponse {
  final List<AstrologerTrainingSessionModel>? data;
  final List<dynamic>? speciality;
  final bool? success;
  final int? statusCode;
  final String? message;

  AstrologerTrainingSessionResponse({
    this.data,
    this.speciality,
    this.success,
    this.statusCode,
    this.message,
  });

  AstrologerTrainingSessionResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)
            ?.map((dynamic e) => AstrologerTrainingSessionModel.fromJson(
                e as Map<String, dynamic>))
            .toList(),
        speciality = json['speciality'] as List?,
        success = json['success'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'success': success,
        'speciality': speciality,
        'status_code': statusCode,
        'message': message
      };
}

class AstrologerTrainingSessionModel {
  final int? id;
  String trainingPurpose;
  String meetingDate;
  dynamic duration;
  String link;
  final int? assignToAll;
  final int? status;
  final int? meetingBy;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final int? meeting_date_epoch;
  final int? meeting_date_end_epoch;
  dynamic isStart;
  final List<dynamic>? astrologerMeeting;

  AstrologerTrainingSessionModel({
    this.id,
    this.trainingPurpose = "",
    this.meetingDate = "",
    this.duration = "",
    this.link = "",
    this.assignToAll,
    this.status,
    this.meetingBy,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.meeting_date_epoch,
    this.meeting_date_end_epoch,
    this.isStart,
    this.astrologerMeeting,
  });

  AstrologerTrainingSessionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        trainingPurpose = json['training_purpose'] ?? "",
        meetingDate = json['meeting_date'] ?? "",
        duration = json['duration'] == null ? "" : json['duration'].toString(),
        link = json['link'] ?? "",
        assignToAll = json['assign_to_all'] as int?,
        status = json['status'] as int?,
        meetingBy = json['meeting_by'] as int?,
        createdBy = json['created_by'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        meeting_date_epoch = json['meeting_date_epoch'] as int?,
        meeting_date_end_epoch = json['meeting_date_end_epoch'] as int?,
        isStart = json['is_start'] == null ? "" : json['is_start'].toString(),
        astrologerMeeting = json['astrologer_meeting'] as List?;
  Map<String, dynamic> toJson() => {
        'id': id,
        'training_purpose': trainingPurpose,
        'meeting_date': meetingDate,
        'duration': duration,
        'link': link,
        'assign_to_all': assignToAll,
        'status': status,
        'meeting_by': meetingBy,
        'created_by': createdBy,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'meeting_date_epoch': meeting_date_epoch,
        'meeting_date_end_epoch': meeting_date_end_epoch,
        'is_start': isStart,
        'astrologer_meeting': astrologerMeeting,
      };
}
