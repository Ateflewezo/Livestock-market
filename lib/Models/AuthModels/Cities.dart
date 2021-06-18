// To parse this JSON data, do
//
//     final allCitiesModels = allCitiesModelsFromJson(jsonString);

import 'dart:convert';

List<AllCitiesModels> allCitiesModelsFromJson(String str) => List<AllCitiesModels>.from(json.decode(str).map((x) => AllCitiesModels.fromJson(x)));

String allCitiesModelsToJson(List<AllCitiesModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllCitiesModels {
    AllCitiesModels({
        this.cityId,
        this.cityName,
    });

    int cityId;
    String cityName;

    factory AllCitiesModels.fromJson(Map<String, dynamic> json) => AllCitiesModels(
        cityId: json["cityID"],
        cityName: json["cityName"],
    );

    Map<String, dynamic> toJson() => {
        "cityID": cityId,
        "cityName": cityName,
    };
}
