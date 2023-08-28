class ChatList {
  int? chatId;
  String? chatName;
  String? profileImage;
  List<ChatMessage>? chatMessages;

  ChatList({
    this.chatId,
    this.chatName,
    this.profileImage,
    this.chatMessages,
  });

  ChatList.fromOfflineJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    chatName = json['chatName'];
    profileImage = json['profileImage'];
    json['data'].forEach((v) {
      chatMessages!.add(ChatMessage.fromOfflineJson(v));
    });
  }

  Map<String, dynamic> toOfflineJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['chatName'] = chatName;
    data['profileImage'] = profileImage;
    if (chatMessages != null) {
      data['data'] = chatMessages!.map((v) => v.toOfflineJson()).toList();
    }
    return data;
  }
}

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
  int? time;
  int? type;

  ChatMessage(
      {this.id,
      this.receiverId,
      this.senderId,
      this.message,
      this.time,
      this.msgType,
      this.awsUrl,
      this.base64Image,
      this.downloadedPath,
      this.type});

  ChatMessage.fromOfflineJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['ChatMessage_id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    message = json['message'];
    time = json['time'];
    type = json['type'];
    msgType = json['msgType'];
    awsUrl = json['awsUrl'];
    base64Image = json['base64Image'];
    downloadedPath = json['downloadedPath'];
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
    data['downloadedPath'] = downloadedPath;

    return data;
  }
}