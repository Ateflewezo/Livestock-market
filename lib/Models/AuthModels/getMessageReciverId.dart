


// To parse this JSON data, do
//
//     final getAllMessageReciverIdChatModel = getAllMessageReciverIdChatModelFromJson(jsonString);

import 'dart:convert';

GetAllMessageReciverIdChatModel getAllMessageReciverIdChatModelFromJson(String str) => GetAllMessageReciverIdChatModel.fromJson(json.decode(str));

String getAllMessageReciverIdChatModelToJson(GetAllMessageReciverIdChatModel data) => json.encode(data.toJson());

class GetAllMessageReciverIdChatModel {
    String status;
    String message;
    Data data;

    GetAllMessageReciverIdChatModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllMessageReciverIdChatModel.fromJson(Map<String, dynamic> json) => GetAllMessageReciverIdChatModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Receiver receiver;
    List<Message> messages;

    Data({
        this.receiver,
        this.messages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        receiver: Receiver.fromJson(json["receiver"]),
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "receiver": receiver.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}

class Message {
    int id;
    int conversationId;
    String messageType;
    String messagePosition;
    SenderData senderData;
    String message;
    String createdAt;

    Message({
        this.id,
        this.conversationId,
        this.messageType,
        this.messagePosition,
        this.senderData,
        this.message,
        this.createdAt,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
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

class Receiver {
    int id;
    String fullName;
    String image;

    Receiver({
        this.id,
        this.fullName,
        this.image,
    });

    factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["id"],
        fullName: json["full_name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "image": image,
    };
}
