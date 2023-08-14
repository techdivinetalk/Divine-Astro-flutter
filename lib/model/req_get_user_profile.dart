class ReqGetUserProfile {
  String? roleId;

  ReqGetUserProfile({this.roleId});

  ReqGetUserProfile.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    return data;
  }
}
