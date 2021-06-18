// To parse this JSON data, do
//
//     final allCountryModels = allCountryModelsFromJson(jsonString);

import 'dart:convert';

AllCountryModels allCountryModelsFromJson(String str) => AllCountryModels.fromJson(json.decode(str));

String allCountryModelsToJson(AllCountryModels data) => json.encode(data.toJson());

class AllCountryModels {
    List<CountriesData> data;
    String status;
    String message;

    AllCountryModels({
        this.data,
        this.status,
        this.message,
    });

    factory AllCountryModels.fromJson(Map<String, dynamic> json) => AllCountryModels(
        data: List<CountriesData>.from(json["data"].map((x) => CountriesData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class CountriesData {
    int id;
    String name;
    List<City> cities;

    CountriesData({
        this.id,
        this.name,
        this.cities,
    });

    factory CountriesData.fromJson(Map<String, dynamic> json) => CountriesData(
        id: json["id"],
        name: json["name"],
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
    };
}

class City {
    int id;
    String name;
    int countryId;
    String countryName;

    City({
        this.id,
        this.name,
        this.countryId,
        this.countryName,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
        countryName: json["country_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
        "country_name": countryName,
    };
}
