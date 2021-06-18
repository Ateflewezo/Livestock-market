// To parse this JSON data, do
//
//     final notificationsModels = notificationsModelsFromJson(jsonString);

import 'dart:convert';

NotificationsModels notificationsModelsFromJson(String str) => NotificationsModels.fromJson(json.decode(str));

String notificationsModelsToJson(NotificationsModels data) => json.encode(data.toJson());

class NotificationsModels {
    List<Datum> data;
    String status;
    String message;

    NotificationsModels({
        this.data,
        this.status,
        this.message,
    });

    factory NotificationsModels.fromJson(Map<String, dynamic> json) => NotificationsModels(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Datum {
    int id;
    String type;
    int userId;
    String value;
    int isSeen;
    DateTime createdAt;
    String ago;

    Datum({
        this.id,
        this.type,
        this.userId,
        this.value,
        this.isSeen,
        this.createdAt,
        this.ago,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        userId: json["user_id"],
        value: json["value"],
        isSeen: json["is_seen"],
        createdAt: DateTime.parse(json["created_at"]),
        ago: json["ago"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "user_id": userId,
        "value": value,
        "is_seen": isSeen,
        "created_at": createdAt.toIso8601String(),
        "ago": ago,
    };
}
