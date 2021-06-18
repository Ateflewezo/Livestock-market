// To parse this JSON data, do
//
//     final myAdsModels = myAdsModelsFromJson(jsonString);

import 'dart:convert';

MyAdsModels myAdsModelsFromJson(String str) => MyAdsModels.fromJson(json.decode(str));

String myAdsModelsToJson(MyAdsModels data) => json.encode(data.toJson());

class MyAdsModels {
    List<MyAdsDetails> data;
    String status;
    String message;

    MyAdsModels({
        this.data,
        this.status,
        this.message,
    });

    factory MyAdsModels.fromJson(Map<String, dynamic> json) => MyAdsModels(
        data: List<MyAdsDetails>.from(json["data"].map((x) => MyAdsDetails.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class MyAdsDetails {
    int id;
    String name;
    String image;
    String type;
    int viewsNum;
    int likeCount;
    UserData userData;

    MyAdsDetails({
        this.id,
        this.name,
        this.image,
        this.type,
        this.viewsNum,
        this.likeCount,
        this.userData,
    });

    factory MyAdsDetails.fromJson(Map<String, dynamic> json) => MyAdsDetails(
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
