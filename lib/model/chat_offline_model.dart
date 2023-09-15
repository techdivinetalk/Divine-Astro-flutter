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
  int? time;
  int? type;
  int? orderId;

  ChatMessage(
      {this.id,
      this.receiverId,
      this.senderId,
      this.message,
      this.time,
      this.msgType,
      this.orderId,
      this.awsUrl,
      this.base64Image,
      this.downloadedPath,
      this.kundliId,
      this.kundliName,
      this.kundliDateTime,
      this.kundliPlace,
      this.gender,
      this.type});

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    message = json['message'];
    time = json['time'];
    type = json['type'];
    msgType = json['msgType'];
    awsUrl = json['awsUrl'];
    base64Image = json['base64Image'];
    kundliId = json['kundli_id'];
    kundliName = json['kundli_name'];
    kundliDateTime = json['kundli_date_time'];
    kundliPlace = json['kundli_place'];
    gender = json['gender'];
    downloadedPath = json['downloadedPath'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['receiver_id'] = receiverId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['time'] = time;
    data['type'] = type;
    data['msgType'] = msgType;
    data['awsUrl'] = awsUrl;
    data['base64Image'] = base64Image;
    data['kundli_id'] = kundliId;
    data['kundli_name'] = kundliName;
    data['kundli_date_time'] = kundliDateTime;
    data['kundli_place'] = kundliPlace;
    data['gender'] = gender;
    data['downloadedPath'] = downloadedPath;
    data['order_id'] = orderId;
    return data;
  }
}
