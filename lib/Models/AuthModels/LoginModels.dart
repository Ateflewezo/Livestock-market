// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.key,
        this.data,
        this.token,
        this.expiration,
        this.status,
        this.msg,
    });

    int key;
    Data data;
    String token;
    DateTime expiration;
    bool status;
    String msg;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        key: json["key"],
        data: Data.fromJson(json["data"]),
        token: json["token"],
        expiration: DateTime.parse(json["expiration"]),
        status: json["status"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "data": data.toJson(),
        "token": token,
        "expiration": expiration.toIso8601String(),
        "status": status,
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
