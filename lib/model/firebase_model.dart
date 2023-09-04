class FirebaseUserData {
  final String name;
  final String deviceToken;
  final String profileImage;

  RealTime realTime;

  FirebaseUserData(
    this.name,
    this.deviceToken,
    this.profileImage,
    this.realTime,
  );

  FirebaseUserData.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        deviceToken = json['deviceToken'] as String,
        profileImage = json['profileImage'] as String,
        realTime = RealTime.fromJson(json["realTime"]);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name.toString(),
        'deviceToken': deviceToken,
        'profileImage': profileImage,
        "realTime": realTime.toJson(),
      };
}

class RealTime {
  final int isEngagedStatus;
  final int walletBalance;
  final String uniqueId;

  RealTime({
    required this.isEngagedStatus,
    required this.walletBalance,
    required this.uniqueId,
  });

  RealTime.fromJson(Map<dynamic, dynamic> json)
      : isEngagedStatus = json['isEngagedStatus'] as int,
        walletBalance = json['wallet_balance'] as int,
        uniqueId = json['uniqueId'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'isEngagedStatus': isEngagedStatus,
        'wallet_balance': walletBalance,
        'uniqueId': uniqueId,
      };
}
