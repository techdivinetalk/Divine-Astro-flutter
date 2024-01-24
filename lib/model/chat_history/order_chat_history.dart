class ChatMessage {
  final int id;
  final int orderId;
  final int memberId;
  final int roleId;
  final int customerId;
  final int msgSequence;
  final int msgType;
  final String message;
  final dynamic multiImage; // Change the type accordingly
  final String msgTime;
  final String createdAt;
  final String updatedAt;
  final int msgSendBy;
  final dynamic isSuspicious; // Change the type accordingly
  final int isEmailSent;
  final dynamic kundliId; // Change the type accordingly
  final dynamic seenStatus; // Change the type accordingly
  final dynamic base64Image; // Change the type accordingly
  final dynamic deletedAt; // Change the type accordingly
  final dynamic chatMsgId; // Change the type accordingly

  ChatMessage({
    required this.id,
    required this.orderId,
    required this.memberId,
    required this.roleId,
    required this.customerId,
    required this.msgSequence,
    required this.msgType,
    required this.message,
    required this.multiImage,
    required this.msgTime,
    required this.createdAt,
    required this.updatedAt,
    required this.msgSendBy,
    required this.isSuspicious,
    required this.isEmailSent,
    required this.kundliId,
    required this.seenStatus,
    required this.base64Image,
    required this.deletedAt,
    required this.chatMsgId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      orderId: json['order_id'],
      memberId: json['member_id'],
      roleId: json['role_id'],
      customerId: json['customer_id'],
      msgSequence: json['msg_sequence'],
      msgType: json['msg_type'],
      message: json['message'],
      multiImage: json['multiimage'],
      msgTime: json['msg_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      msgSendBy: json['msg_send_by'],
      isSuspicious: json['is_suspicious'],
      isEmailSent: json['is_email_sent'],
      kundliId: json['kundli_id'],
      seenStatus: json['seen_status'],
      base64Image: json['base64image'],
      deletedAt: json['deleted_at'],
      chatMsgId: json['chat_msg_id'],
    );
  }
}

class ChatHistoryResponse {
  final List<ChatMessage> data;
  final bool success;
  final int statusCode;
  final String message;

  ChatHistoryResponse({
    required this.data,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      data: List<ChatMessage>.from(json['data'].map((message) => ChatMessage.fromJson(message))),
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }
}