// To parse this JSON data, do
//
//     final rateModels = rateModelsFromJson(jsonString);

import 'dart:convert';

RateModels rateModelsFromJson(String str) => RateModels.fromJson(json.decode(str));

String rateModelsToJson(RateModels data) => json.encode(data.toJson());

class RateModels {
    dynamic data;
    String status;
    String message;

    RateModels({
        this.data,
        this.status,
        this.message,
    });

    factory RateModels.fromJson(Map<String, dynamic> json) => RateModels(
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
