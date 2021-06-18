// To parse this JSON data, do
//
//     final sendMessageChat = sendMessageChatFromJson(jsonString);

import 'dart:convert';

SendMessageChat sendMessageChatFromJson(String str) => SendMessageChat.fromJson(json.decode(str));

String sendMessageChatToJson(SendMessageChat data) => json.encode(data.toJson());

class SendMessageChat {
    Data data;
    String status;
    String message;

    SendMessageChat({
        this.data,
        this.status,
        this.message,
    });

    factory SendMessageChat.fromJson(Map<String, dynamic> json) => SendMessageChat(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    int id;
    int conversationId;
    String messageType;
    String messagePosition;
    SenderData senderData;
    String message;
    String createdAt;

    Data({
        this.id,
        this.conversationId,
        this.messageType,
        this.messagePosition,
        this.senderData,
        this.message,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        conversationId: json["conversation_id"],
        messageType: json["message_type"],
        messagePosition: json["message_position"],
        senderData: SenderData.fromJson(json["sender_data"]),
        message: json["message"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "message_type": messageType,
        "message_position": messagePosition,
        "sender_data": senderData.toJson(),
        "message": message,
        "created_at": createdAt,
    };
}

class SenderData {
    int id;
    String username;
    String profileImage;

    SenderData({
        this.id,
        this.username,
        this.profileImage,
    });

    factory SenderData.fromJson(Map<String, dynamic> json) => SenderData(
        id: json["id"],
        username: json["username"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_image": profileImage,
    };
}
