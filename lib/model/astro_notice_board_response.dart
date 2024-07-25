class AstroNoticeBoardResponse {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  AstroNoticeBoardResponse(
      {this.data, this.success, this.statusCode, this.message});

  AstroNoticeBoardResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  NoticeBoard? noticeBoard;

  Data({this.noticeBoard});

  Data.fromJson(Map<String, dynamic> json) {
    noticeBoard = json['notice_board'] != null
        ? new NoticeBoard.fromJson(json['notice_board'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.noticeBoard != null) {
      data['notice_board'] = this.noticeBoard!.toJson();
    }
    return data;
  }
}

class NoticeBoard {
  int? id;
  String? title;
  String? description;
  String? createdAt;

  NoticeBoard({this.id, this.title, this.description, this.createdAt});

  NoticeBoard.fromJson(Map<String, dynamic> json) {
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
