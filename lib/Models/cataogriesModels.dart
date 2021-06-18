// To parse this JSON data, do
//
//     final adsSubCataModels = adsSubCataModelsFromJson(jsonString);

import 'dart:convert';

AdsSubCataModels adsSubCataModelsFromJson(String str) => AdsSubCataModels.fromJson(json.decode(str));

String adsSubCataModelsToJson(AdsSubCataModels data) => json.encode(data.toJson());

class AdsSubCataModels {
    List<DataModels> data;
    String status;
    String message;

    AdsSubCataModels({
        this.data,
        this.status,
        this.message,
    });

    factory AdsSubCataModels.fromJson(Map<String, dynamic> json) => AdsSubCataModels(
        data: List<DataModels>.from(json["data"].map((x) => DataModels.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class DataModels {
    int id;
    String name;
    List<Subcategory> subcategories;

    DataModels({
        this.id,
        this.name,
        this.subcategories,
    });

    factory DataModels.fromJson(Map<String, dynamic> json) => DataModels(
        id: json["id"],
        name: json["name"],
        subcategories: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    };
}

class Subcategory {
    int id;
    String name;
    int cateogoryId;
    String cateogoryName;

    Subcategory({
        this.id,
        this.name,
        this.cateogoryId,
        this.cateogoryName,
    });

    factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        name: json["name"],
        cateogoryId: json["cateogory_id"],
        cateogoryName: json["cateogory_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cateogory_id": cateogoryId,
        "cateogory_name": cateogoryName,
    };
}
