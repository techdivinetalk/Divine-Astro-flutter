import 'dart:convert';

ReferAstrologerRequest referAstrologerModelFromJson(String str) =>
    ReferAstrologerRequest.fromJson(json.decode(str));

String referAstrologerModelToJson(ReferAstrologerRequest data) =>
    json.encode(data.toJson());

class ReferAstrologerRequest {
  String? firstName;
  String? email;
  String? contactNumber;
  String? segment;
  String? notes;
  String? experience;
  String? skills;
  String? userId;
  String? isCustApp;
  int? referBy;

  ReferAstrologerRequest({
    this.firstName,
    this.email,
    this.contactNumber,
    this.segment,
    this.notes,
    this.experience,
    this.skills,
    this.userId,
    this.isCustApp,
    this.referBy,
  });

  ReferAstrologerRequest copyWith({
    String? firstName,
    String? email,
    String? contactNumber,
    String? segment,
    String? notes,
    String? experience,
    String? skills,
    String? userId,
    String? isCustApp,
  }) =>
      ReferAstrologerRequest(
        firstName: firstName ?? this.firstName,
        email: email ?? this.email,
        contactNumber: contactNumber ?? this.contactNumber,
        segment: segment ?? this.segment,
        notes: notes ?? this.notes,
        experience: experience ?? this.experience,
        skills: skills ?? this.skills,
        userId: userId ?? this.userId,
        isCustApp: isCustApp ?? this.isCustApp,
        referBy: referBy ?? this.referBy,
      );

  factory ReferAstrologerRequest.fromJson(Map<String, dynamic> json) =>
      ReferAstrologerRequest(
        firstName: json["firstName"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        segment: json["segment"],
        notes: json["notes"],
        experience: json["experience"],
        skills: json["skills"],
        userId: json["userId"],
        isCustApp: json["isCustApp"],
        referBy: json["referBy"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "email": email,
        "contactNumber": contactNumber,
        "segment": segment,
        "notes": notes,
        "experience": experience,
        "skills": skills,
        "userId": userId,
        "isCustApp": isCustApp,
        "referBy": referBy,
      };

  String toPrettyJson() => JsonEncoder.withIndent(" " * 4).convert(toJson());
}
