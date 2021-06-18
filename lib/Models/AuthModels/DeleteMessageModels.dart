// To parse this JSON data, do
//
//     final deleteMessage = deleteMessageFromJson(jsonString);

import 'dart:convert';

DeleteMessage deleteMessageFromJson(String str) => DeleteMessage.fromJson(json.decode(str));

String deleteMessageToJson(DeleteMessage data) => json.encode(data.toJson());

class DeleteMessage {
    String data;
    String status;
    String message;

    DeleteMessage({
        this.data,
        this.status,
        this.message,
    });

    factory DeleteMessage.fromJson(Map<String, dynamic> json) => DeleteMessage(
        data: json["data"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "status": status,
        "message": message,
    };
}
