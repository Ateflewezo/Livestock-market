// To parse this JSON data, do
//
//     final createAdvertiseModels = createAdvertiseModelsFromJson(jsonString);

import 'dart:convert';

CreateAdvertiseModels createAdvertiseModelsFromJson(String str) => CreateAdvertiseModels.fromJson(json.decode(str));

String createAdvertiseModelsToJson(CreateAdvertiseModels data) => json.encode(data.toJson());

class CreateAdvertiseModels {
    Data data;
    String status;
    String message;

    CreateAdvertiseModels({
        this.data,
        this.status,
        this.message,
    });

    factory CreateAdvertiseModels.fromJson(Map<String, dynamic> json) => CreateAdvertiseModels(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    int id;
    String type;
    int userId;
    String name;
    String description;
    int subcategoryId;
    dynamic subcategoryName;
    dynamic categoryId;
    dynamic categoryName;
    int countryId;
    int cityId;
    String countryName;
    String cityName;
    String lat;
    String lng;
    String address;
    String period;
    int code;
    int rateAvg;
    int accepted;
    int viewsNum;
    int likeCount;
    String createdAt;
    int isFav;
    UserData userData;
    List<Image> images;
    List<dynamic> rates;
    List<SimilarDatum> similarData;

    Data({
        this.id,
        this.type,
        this.userId,
        this.name,
        this.description,
        this.subcategoryId,
        this.subcategoryName,
        this.categoryId,
        this.categoryName,
        this.countryId,
        this.cityId,
        this.countryName,
        this.cityName,
        this.lat,
        this.lng,
        this.address,
        this.period,
        this.code,
        this.rateAvg,
        this.accepted,
        this.viewsNum,
        this.likeCount,
        this.createdAt,
        this.isFav,
        this.userData,
        this.images,
        this.rates,
        this.similarData,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        type: json["type"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        countryId: json["country_id"],
        cityId: json["city_id"],
        countryName: json["country_name"],
        cityName: json["city_name"],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        period: json["period"],
        code: json["code"],
        rateAvg: json["rate_avg"],
        accepted: json["accepted"],
        viewsNum: json["views_num"],
        likeCount: json["like_count"],
        createdAt: json["created_at"],
        isFav: json["is_fav"],
        userData: UserData.fromJson(json["user_data"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        rates: List<dynamic>.from(json["rates"].map((x) => x)),
        similarData: List<SimilarDatum>.from(json["similar_data"].map((x) => SimilarDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "user_id": userId,
        "name": name,
        "description": description,
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
        "category_id": categoryId,
        "category_name": categoryName,
        "country_id": countryId,
        "city_id": cityId,
        "country_name": countryName,
        "city_name": cityName,
        "lat": lat,
        "lng": lng,
        "address": address,
        "period": period,
        "code": code,
        "rate_avg": rateAvg,
        "accepted": accepted,
        "views_num": viewsNum,
        "like_count": likeCount,
        "created_at": createdAt,
        "is_fav": isFav,
        "user_data": userData.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x)),
        "similar_data": List<dynamic>.from(similarData.map((x) => x.toJson())),
    };
}

class Image {
    int id;
    String image;

    Image({
        this.id,
        this.image,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["Image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Image": image,
    };
}

class SimilarDatum {
    int id;
    String name;
    String image;
    String type;
    int viewsNum;
    int likeCount;
    UserData userData;

    SimilarDatum({
        this.id,
        this.name,
        this.image,
        this.type,
        this.viewsNum,
        this.likeCount,
        this.userData,
    });

    factory SimilarDatum.fromJson(Map<String, dynamic> json) => SimilarDatum(
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
