// class BaseModel {
//   String? status;
//   int? statusCode;
//   Data? data;
//   String? message;

//   BaseModel({this.status, this.statusCode, this.data, this.message});

//   BaseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     statusCode = json['statusCode'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['statusCode'] = statusCode;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = message;
//     return data;
//   }
// }

// class Data {
//   List<String>? email;

//   Data({this.email});

//   Data.fromJson(Map<String, dynamic> json) {
//     email = json['email'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['email'] = email;
//     return data;
//   }
// }
