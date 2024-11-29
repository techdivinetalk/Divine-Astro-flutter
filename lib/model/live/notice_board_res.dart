class NoticeBoardRes {
  List<NoticeBoardResData>? data;
  bool? success;
  int? statusCode;
  String? message;

  NoticeBoardRes({this.data, this.success, this.statusCode, this.message});

  NoticeBoardRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NoticeBoardResData>[];
      json['data'].forEach((v) {
        data!.add(new NoticeBoardResData.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class NoticeBoardResData {
  int? id;
  String? title;
  String? description;
  String? createdAt;

  NoticeBoardResData({this.id, this.title, this.description, this.createdAt});

  NoticeBoardResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }
}
