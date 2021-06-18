// To parse this JSON data, do
//
//     final registerCodeModels = registerCodeModelsFromJson(jsonString);

import 'dart:convert';

RegisterCodeModels registerCodeModelsFromJson(String str) => RegisterCodeModels.fromJson(json.decode(str));

String registerCodeModelsToJson(RegisterCodeModels data) => json.encode(data.toJson());

class RegisterCodeModels {
    RegisterCodeModels({
        this.key,
        this.data,
        this.msg,
    });

    int key;
    Data data;
    String msg;

    factory RegisterCodeModels.fromJson(Map<String, dynamic> json) => RegisterCodeModels(
        key: json["key"],
        data: Data.fromJson(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "data": data.toJson(),
        "msg": msg,
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
    String lat;
    dynamic lng;
    dynamic address;
    String lang;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userName: json["user_name"],
        email: json["email"],
        cityId: json["cityID"],
        phone: json["phone"],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        lang: json["lang"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "email": email,
        "cityID": cityId,
        "phone": phone,
        "lat": lat,
        "lng": lng,
        "address": address,
        "lang": lang,
    };
}
