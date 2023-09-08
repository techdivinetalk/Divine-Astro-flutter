class ReqCommonChatParams {
  int? orderId;
  int? queueId;
  int? acceptOrReject;
  int? isTimeout;

  ReqCommonChatParams(
      {this.orderId, this.queueId, this.acceptOrReject, this.isTimeout});

  ReqCommonChatParams.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    queueId = json['queue_id'];
    acceptOrReject = json['accept_or_reject'];
    isTimeout = json['is_timeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['queue_id'] = queueId;
    data['accept_or_reject'] = acceptOrReject;
    data['is_timeout'] = isTimeout;
    return data;
  }
}
