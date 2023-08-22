import 'dart:convert';

ReferAstrologerResponse referAstrologerResponseFromJson(String str) =>
    ReferAstrologerResponse.fromJson(json.decode(str));

String referAstrologerResponseToJson(ReferAstrologerResponse data) =>
    json.encode(data.toJson());

class ReferAstrologerResponse {
  Status? status;
  Data? data;

  ReferAstrologerResponse({
    this.status,
    this.data,
  });

  ReferAstrologerResponse copyWith({
    Status? status,
    Data? data,
  }) =>
      ReferAstrologerResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory ReferAstrologerResponse.fromJson(Map<String, dynamic> json) =>
      ReferAstrologerResponse(
        status: _getStatus(json),
        data: _getData(json),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };

  static Status? _getStatus(Map<String, dynamic> json) {
    if (json["status"] != null) {
      return Status.fromJson(json["status"]);
    }
    return null;
  }

  static Data? _getData(Map<String, dynamic> json) {
    if (json["data"] != null) {
      return Data.fromJson(json["data"]);
    }
    return null;
  }
}

class Data {
  String? uuid;
  bool? experience;
  bool? alternativeNumber;
  bool? gender;
  bool? leadSource;
  bool? verificationCode;
  int? leadBySource;
  bool? isActive;
  bool? isDeleted;
  int? id;
  String? firstName;
  String? email;
  String? contactNumber;
  String? segment;
  String? notes;
  int? rm;
  String? owner;
  int? leadProcessStatus;
  String? updatedAt;
  String? createdAt;

  Data({
    this.uuid,
    this.experience,
    this.alternativeNumber,
    this.gender,
    this.leadSource,
    this.verificationCode,
    this.leadBySource,
    this.isActive,
    this.isDeleted,
    this.id,
    this.firstName,
    this.email,
    this.contactNumber,
    this.segment,
    this.notes,
    this.rm,
    this.owner,
    this.leadProcessStatus,
    this.updatedAt,
    this.createdAt,
  });

  Data copyWith({
    String? uuid,
    bool? experience,
    bool? alternativeNumber,
    bool? gender,
    bool? leadSource,
    bool? verificationCode,
    int? leadBySource,
    bool? isActive,
    bool? isDeleted,
    int? id,
    String? firstName,
    String? email,
    String? contactNumber,
    String? segment,
    String? notes,
    int? rm,
    String? owner,
    int? leadProcessStatus,
    String? updatedAt,
    String? createdAt,
  }) =>
      Data(
        uuid: uuid ?? this.uuid,
        experience: experience ?? this.experience,
        alternativeNumber: alternativeNumber ?? this.alternativeNumber,
        gender: gender ?? this.gender,
        leadSource: leadSource ?? this.leadSource,
        verificationCode: verificationCode ?? this.verificationCode,
        leadBySource: leadBySource ?? this.leadBySource,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        email: email ?? this.email,
        contactNumber: contactNumber ?? this.contactNumber,
        segment: segment ?? this.segment,
        notes: notes ?? this.notes,
        rm: rm ?? this.rm,
        owner: owner ?? this.owner,
        leadProcessStatus: leadProcessStatus ?? this.leadProcessStatus,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        uuid: json["uuid"],
        experience: json["experience"],
        alternativeNumber: json["alternativeNumber"],
        gender: json["gender"],
        leadSource: json["leadSource"],
        verificationCode: json["verificationCode"],
        leadBySource: json["leadBySource"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        id: json["id"],
        firstName: json["firstName"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        segment: json["segment"],
        notes: json["notes"],
        rm: json["rm"],
        owner: json["owner"],
        leadProcessStatus: json["leadProcessStatus"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "experience": experience,
        "alternativeNumber": alternativeNumber,
        "gender": gender,
        "leadSource": leadSource,
        "verificationCode": verificationCode,
        "leadBySource": leadBySource,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "id": id,
        "firstName": firstName,
        "email": email,
        "contactNumber": contactNumber,
        "segment": segment,
        "notes": notes,
        "rm": rm,
        "owner": owner,
        "leadProcessStatus": leadProcessStatus,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
      };
}

class Status {
  int? code;
  String? message;

  Status({
    this.code,
    this.message,
  });

  Status copyWith({
    int? code,
    String? message,
  }) =>
      Status(
        code: code ?? this.code,
        message: message ?? this.message,
      );

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
