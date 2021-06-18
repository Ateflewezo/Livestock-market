// To parse this JSON data, do
//
//     final codeForgetPasswordModels = codeForgetPasswordModelsFromJson(jsonString);

import 'dart:convert';

CodeForgetPasswordModels codeForgetPasswordModelsFromJson(String str) => CodeForgetPasswordModels.fromJson(json.decode(str));

String codeForgetPasswordModelsToJson(CodeForgetPasswordModels data) => json.encode(data.toJson());

class CodeForgetPasswordModels {
    Data data;
    String type;
    String status;
    String message;

    CodeForgetPasswordModels({
        this.data,
        this.type,
        this.status,
        this.message,
    });

    factory CodeForgetPasswordModels.fromJson(Map<String, dynamic> json) => CodeForgetPasswordModels(
        data: Data.fromJson(json["data"]),
        type: json["type"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "type": type,
        "status": status,
        "message": message,
    };
}

class Data {
    int id;
    String type;
    String fullName;
    String mobile;
    String email;
    String gender;
    String address;
    String image;
    String active;
    String notificationToggle;
    String jwt;
    List<Ad> ads;
    List<dynamic> rates;

    Data({
        this.id,
        this.type,
        this.fullName,
        this.mobile,
        this.email,
        this.gender,
        this.address,
        this.image,
        this.active,
        this.notificationToggle,
        this.jwt,
        this.ads,
        this.rates,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        type: json["type"],
        fullName: json["full_name"],
        mobile: json["mobile"],
        email: json["email"],
        gender: json["gender"],
        address: json["address"],
        image: json["image"],
        active: json["active"],
        notificationToggle: json["notification_toggle"],
        jwt: json["jwt"],
        ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
        rates: List<dynamic>.from(json["rates"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "full_name": fullName,
        "mobile": mobile,
        "email": email,
        "gender": gender,
        "address": address,
        "image": image,
        "active": active,
        "notification_toggle": notificationToggle,
        "jwt": jwt,
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x)),
    };
}

class Ad {
    int id;
    String name;
    String image;
    String type;
    int viewsNum;
    int likeCount;
    UserData userData;

    Ad({
        this.id,
        this.name,
        this.image,
        this.type,
        this.viewsNum,
        this.likeCount,
        this.userData,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        viewsNum: json["views_num"],
        likeCount: json["like_count"],
        userData: UserData.fromJson(json["user_data"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "views_num": viewsNum,
        "like_count": likeCount,
        "user_data": userData.toJson(),
    };
}

class UserData {
    int id;
    String fullName;
    String mobile;
    String image;

    UserData({
        this.id,
        this.fullName,
        this.mobile,
        this.image,
    });

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        fullName: json["full_name"],
        mobile: json["mobile"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "mobile": mobile,
        "image": image,
    };
}
