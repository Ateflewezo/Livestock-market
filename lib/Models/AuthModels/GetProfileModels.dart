// To parse this JSON data, do
//
//     final getProfileModels = getProfileModelsFromJson(jsonString);

import 'dart:convert';

GetProfileModels getProfileModelsFromJson(String str) => GetProfileModels.fromJson(json.decode(str));

String getProfileModelsToJson(GetProfileModels data) => json.encode(data.toJson());

class GetProfileModels {
    GetProfileModels({
        this.key,
        this.data,
    });

    int key;
    Data data;

    factory GetProfileModels.fromJson(Map<String, dynamic> json) => GetProfileModels(
        key: json["key"] == null ? null : json["key"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.userName,
        this.email,
        this.cityId,
        this.phone,
        this.lat,
        this.lng,
        this.address,
        this.lang,
    });

    String id;
    String userName;
    String email;
    int cityId;
    String phone;
    dynamic lat;
    dynamic lng;
    dynamic address;
    dynamic lang;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        userName: json["user_name"] == null ? null : json["user_name"],
        email: json["email"] == null ? null : json["email"],
        cityId: json["cityID"] == null ? null : json["cityID"],
        phone: json["phone"] == null ? null : json["phone"],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        lang: json["lang"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_name": userName == null ? null : userName,
        "email": email == null ? null : email,
        "cityID": cityId == null ? null : cityId,
        "phone": phone == null ? null : phone,
        "lat": lat,
        "lng": lng,
        "address": address,
        "lang": lang,
    };
}
