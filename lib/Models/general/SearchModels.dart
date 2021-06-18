// To parse this JSON data, do
//
//     final searchModels = searchModelsFromJson(jsonString);

import 'dart:convert';

SearchModels searchModelsFromJson(String str) => SearchModels.fromJson(json.decode(str));

String searchModelsToJson(SearchModels data) => json.encode(data.toJson());

class SearchModels {
    List<Datum> data;
    String status;
    String message;

    SearchModels({
        this.data,
        this.status,
        this.message,
    });

    factory SearchModels.fromJson(Map<String, dynamic> json) => SearchModels(
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
    Datum({
        this.id,
        this.name,
        this.serviceType,
        this.description,
        this.countryId,
        this.cityId,
        this.countryName,
        this.cityName,
        this.lat,
        this.lng,
        this.price,
        this.endLat,
        this.endLng,
        this.address,
        this.portableId,
        this.portableName,
        this.endAddress,
        this.mobile,
        this.whatsApp,
        this.image,
        this.type,
        this.viewsNum,
this.is_fav,
        this.likeCount,
        this.createdAt,
        this.userData,
        this.service_type
        
    });

    int id;
    String name;
    String serviceType;
    String description;
    int countryId;
    int cityId;
    String countryName;
    String cityName;
    String lat;
    String lng;
    String endLat;
    String endLng;
    String address;
    int portableId;
    String price;
    dynamic is_fav;
    String portableName;
    String endAddress;
    String mobile;
    String whatsApp;
    String image;
    String type;
    int viewsNum;
    int likeCount;
    String createdAt;
    UserData userData;
    String service_type;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        serviceType: json["service_type"],
        description: json["description"],
        countryId: json["country_id"],
        cityId: json["city_id"],
        countryName: json["country_name"],
        cityName: json["city_name"],
        lat: json["lat"],
        lng: json["lng"],
        endLat: json["end_lat"],
        endLng: json["end_lng"],
        address: json["address"],
        portableId: json["portable_id"],
        portableName: json["portable_name"],
        endAddress: json["end_address"],
        mobile: json["mobile"],
        price: json['price'],
        whatsApp: json["whatsApp"],
        image: json["image"],
        type: json["type"],
        viewsNum: json["views_num"],
        is_fav:  json['is_fav'],
        likeCount: json["like_count"],
        createdAt: json["created_at"],
        userData: UserData.fromJson(json["user_data"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "service_type": serviceType,
        "description": description,
        "country_id": countryId,
        "city_id": cityId,
        "country_name": countryName,
        "city_name": cityName,
        "lat": lat,
        "lng": lng,
        "end_lat": endLat,
        "end_lng": endLng,
        "address": address,
        "portable_id": portableId,
        "portable_name": portableName,
        "end_address": endAddress,
        "mobile": mobile,
        "whatsApp": whatsApp,
        "image": image,
        "type": type,
        "views_num": viewsNum,
        "like_count": likeCount,
        "created_at": createdAt,
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
