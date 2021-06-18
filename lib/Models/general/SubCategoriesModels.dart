// To parse this JSON data, do
//
//     final sUbCategoryModels = sUbCategoryModelsFromJson(jsonString);

import 'dart:convert';

SUbCategoryModels sUbCategoryModelsFromJson(String str) => SUbCategoryModels.fromJson(json.decode(str));

String sUbCategoryModelsToJson(SUbCategoryModels data) => json.encode(data.toJson());

class SUbCategoryModels {
    List<Datum> data;
    String status;
    String message;

    SUbCategoryModels({
        this.data,
        this.status,
        this.message,
    });

    factory SUbCategoryModels.fromJson(Map<String, dynamic> json) => SUbCategoryModels(
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
    String name;

    Datum({
        this.id,
        this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
