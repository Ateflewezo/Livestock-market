// To parse this JSON data, do
//
//     final filtterModels = filtterModelsFromJson(jsonString);

import 'dart:convert';

FiltterModels filtterModelsFromJson(String str) => FiltterModels.fromJson(json.decode(str));

String filtterModelsToJson(FiltterModels data) => json.encode(data.toJson());

class FiltterModels {
    List<Datum> data;
    String status;
    String message;

    FiltterModels({
        this.data,
        this.status,
        this.message,
    });

    factory FiltterModels.fromJson(Map<String, dynamic> json) => FiltterModels(
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
    String image;
    String type;
    int viewsNum;
    int likeCount;
    UserData userData;

    Datum({
        this.id,
        this.name,
        this.image,
        this.type,
        this.viewsNum,
        this.likeCount,
        this.userData,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
