class ResAstroChatListener {
  int? customerId;
  int? astroId;
  String? astroImage;
  String? astroName;
  String? chatMessage;
  String? customeName;
  String? customerImage;
  int? extraTalktime;
  int? isRechargeContinue;
  int? isTimeout;
  int? ivrTime;
  int? notification;
  int? orderId;
  String? orderType;
  int? queueId;
  int? status;

  ResAstroChatListener(
      {this.customerId,
      this.astroId,
      this.astroImage,
      this.astroName,
      this.chatMessage,
      this.customeName,
      this.customerImage,
      this.extraTalktime,
      this.isRechargeContinue,
      this.isTimeout,
      this.ivrTime,
      this.notification,
      this.orderId,
      this.orderType,
      this.queueId,
      this.status});

  ResAstroChatListener.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    astroId = json['astroId'];
    astroImage = json['astroImage'];
    astroName = json['astroName'];
    chatMessage = json['chat_message'];
    customeName = json['custome_name'];
    customerImage = json['customer_image'];
    extraTalktime = json['extra_talktime'];
    isRechargeContinue = json['is_recharge_continue'];
    isTimeout = json['is_timeout'];
    ivrTime = json['ivr_time'];
    notification = json['notification'];
    orderId = json['orderId'];
    orderType = json['orderType'];
    queueId = json['queue_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['astroId'] = astroId;
    data['astroImage'] = astroImage;
    data['astroName'] = astroName;
    data['chat_message'] = chatMessage;
    data['custome_name'] = customeName;
    data['customer_image'] = customerImage;
    data['extra_talktime'] = extraTalktime;
    data['is_recharge_continue'] = isRechargeContinue;
    data['is_timeout'] = isTimeout;
    data['ivr_time'] = ivrTime;
    data['notification'] = notification;
    data['orderId'] = orderId;
    data['orderType'] = orderType;
    data['queue_id'] = queueId;
    data['status'] = status;
    return data;
  }
}
