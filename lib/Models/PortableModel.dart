// To parse this JSON data, do
//
//     final portableModels = portableModelsFromJson(jsonString);

import 'dart:convert';

PortableModels portableModelsFromJson(String str) => PortableModels.fromJson(json.decode(str));

String portableModelsToJson(PortableModels data) => json.encode(data.toJson());

class PortableModels {
    PortableModels({
        this.data,
        this.status,
        this.message,
    });

    List<PortableData> data;
    String status;
    String message;

    factory PortableModels.fromJson(Map<String, dynamic> json) => PortableModels(
        data: List<PortableData>.from(json["data"].map((x) => PortableData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class PortableData {
    PortableData({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory PortableData.fromJson(Map<String, dynamic> json) => PortableData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
