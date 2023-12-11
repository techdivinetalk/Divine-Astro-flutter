class ChatMessagesOffline {
  List<ChatMessage>? chatMessages;

  ChatMessagesOffline({
    this.chatMessages,
  });

  factory ChatMessagesOffline.fromOfflineJson(Map<String, dynamic> json) =>
      ChatMessagesOffline(
          chatMessages: json['data'] == null
              ? []
              : List<ChatMessage>.from(
              json["data"].map((x) => ChatMessage.fromOfflineJson(x))));

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (chatMessages != null) {
      data['data'] = chatMessages!.map((v) => v.toOfflineJson()).toList();
    }
    return data;
  }
}

class ChatMessage {
  int? id;
  int? receiverId;
  int? senderId;
  int? orderId;
  String? message;
  String? msgType;
  String? awsUrl;
  String? base64Image;
  String? downloadedPath;
  String? kundliId;
  String? kundliName;
  String? kundliDateTime;
  String? kundliPlace;
  String? gender;
  String? title;
  int? time;
  int? type;
  String? userType;

  ChatMessage(
      {this.id,
        this.receiverId,
        this.senderId,
        this.orderId,
        this.message,
        this.time,
        this.msgType,
        this.awsUrl,
        this.base64Image,
        this.downloadedPath,
        this.kundliId,
        this.kundliName,
        this.kundliDateTime,
        this.kundliPlace,
        this.gender,
        this.title,
        this.type,
        this.userType,
      });

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['chatMessageId'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    orderId = json['orderId'];
    message = json['message'];
    time = json['time'];
    type = json['type'];
    msgType = json['msgType'];
    awsUrl = json['awsUrl'];
    base64Image = json['base64Image'];
    downloadedPath = json['kundliId'];
    kundliName = json['kundliName'];
    kundliDateTime = json['kundliDateTime'];
    kundliPlace = json['kundliPlace'];
    kundliId = json['kundliId'];
    gender = json['gender'];
    title = json['title'];
    userType = json['userType'];
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatMessageId'] = id;
    data['receiverId'] = receiverId;
    data['senderId'] = senderId;
    data['orderId'] = orderId;
    data['message'] = message;
    data['time'] = time;
    data['type'] = type;
    data['msgType'] = msgType;
    data['awsUrl'] = awsUrl;
    data['base64Image'] = base64Image;
    data['downloadedPath'] = downloadedPath;
    data['kundliId'] = kundliId;
    data['kundliName'] = kundliName;
    data['kundliDateTime'] = kundliDateTime;
    data['kundliPlace'] = kundliPlace;
    data['gender'] = gender;
    data['title'] = title;
    data['userType'] = userType;
    return data;
  }
}
