// To parse this JSON data, do
//
//     final getReasonModels = getReasonModelsFromJson(jsonString);

import 'dart:convert';

GetReasonModels getReasonModelsFromJson(String str) => GetReasonModels.fromJson(json.decode(str));

String getReasonModelsToJson(GetReasonModels data) => json.encode(data.toJson());

class GetReasonModels {
    List<Datum> data;
    String status;
    String message;

    GetReasonModels({
        this.data,
        this.status,
        this.message,
    });

    factory GetReasonModels.fromJson(Map<String, dynamic> json) => GetReasonModels(
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
    String reason;

    Datum({
        this.id,
        this.reason,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reason": reason,
    };
}
