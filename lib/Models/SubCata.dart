// To parse this JSON data, do
//
//     final subCataModels = subCataModelsFromJson(jsonString);

import 'dart:convert';

SubCataModels subCataModelsFromJson(String str) => SubCataModels.fromJson(json.decode(str));

String subCataModelsToJson(SubCataModels data) => json.encode(data.toJson());

class SubCataModels {
    List<Datum> data;
    String status;
    String message;

    SubCataModels({
        this.data,
        this.status,
        this.message,
    });

    factory SubCataModels.fromJson(Map<String, dynamic> json) => SubCataModels(
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
