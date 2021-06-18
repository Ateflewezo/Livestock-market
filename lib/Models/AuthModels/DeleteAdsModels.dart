// To parse this JSON data, do
//
//     final deleteAdsModels = deleteAdsModelsFromJson(jsonString);

import 'dart:convert';

DeleteAdsModels deleteAdsModelsFromJson(String str) => DeleteAdsModels.fromJson(json.decode(str));

String deleteAdsModelsToJson(DeleteAdsModels data) => json.encode(data.toJson());

class DeleteAdsModels {
    String data;
    String status;
    String message;

    DeleteAdsModels({
        this.data,
        this.status,
        this.message,
    });

    factory DeleteAdsModels.fromJson(Map<String, dynamic> json) => DeleteAdsModels(
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
