// To parse this JSON data, do
//
//     final profileProviderModels = profileProviderModelsFromJson(jsonString);

import 'dart:convert';


ProfileProviderModels profileProviderModelsFromJson(String str) => ProfileProviderModels.fromJson(json.decode(str));

String profileProviderModelsToJson(ProfileProviderModels data) => json.encode(data.toJson());

class ProfileProviderModels {
    Data data;
    String status;
    String message;

    ProfileProviderModels({
        this.data,
        this.status,
        this.message,
    });

    factory ProfileProviderModels.fromJson(Map<String, dynamic> json) => ProfileProviderModels(
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
    String fullName;
    String mobile;
    String email;
    String gender;
    String address;
    String image;
    String coverImage;
    String active;
    String city;
    String country;
    List<Ad> ads;
    List<Rate> rates;

    Data({
        this.id,
        this.type,
        this.fullName,
        this.mobile,
        this.email,
        this.gender,
        this.address,
        this.image,
        this.coverImage,
        this.active,
        this.city,
        this.country,
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
        coverImage: json["cover_image"],
        active: json["active"],
        city: json["city"],
        country: json["country"],
        ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
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
        "cover_image": coverImage,
        "active": active,
        "city": city,
        "country": country,
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
    };
}

class Ad {
  int id;
  String type;
  int userId;
  String name;
  String description;
  String image;
  String mobile;
  String whatsApp;
  int subcategoryId;
  String subcategoryName;
  int categoryId;
  String categoryName;
  int portableId;
  dynamic portableName;
  int countryId;
  int cityId;
  String countryName;
  String cityName;
  String lat;
  String lng;
  String service_type;
  String address;
  String endLat;
  String endLng;
  String endAddress;
  int period;
  String passing_by;
  String price;
  String code;
  int rateAvg;
  int accepted;
  int viewsNum;
  int likeCount;
  String createdAt;
  dynamic isFav;
  UserData userData;
  List<Rate> rates;
    Ad({
     this.id,
    this.type,
    this.userId,
    this.name,
    this.description,
    this.mobile,
    this.whatsApp,
    this.passing_by,
    this.subcategoryId,
    this.subcategoryName,
    this.service_type,
    this.categoryId,
    this.categoryName,
    this.portableId,
    this.portableName,
    this.countryId,
    this.cityId,
    this.countryName,
    this.cityName,
    this.lat,
    this.lng,
    this.image,
    this.price,
    this.address,
    this.endLat,
    this.endLng,
    this.endAddress,
    this.period,
    this.code,
    this.rateAvg,
    this.accepted,
    this.viewsNum,
    this.likeCount,
    this.createdAt,
    this.isFav,
    this.userData,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        type: json["type"],
        userId: json["user_id"],
        name: json["name"],
        image: json['image'],
        description: json["description"],
        mobile: json["mobile"],
        whatsApp: json["whatsApp"],
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        portableId: json["portable_id"],
        portableName: json["portable_name"],
        countryId: json["country_id"],
        cityId: json["city_id"],
        service_type: json['service_type'],
        countryName: json["country_name"],
        cityName: json["city_name"],
        price: json['price'],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        endLat: json["end_lat"],
        passing_by: json['passing_by'],
        endLng: json["end_lng"],
        endAddress: json["end_address"],
        period: json["period"],
        code: json["code"],
        rateAvg: json["rate_avg"],
        accepted: json["accepted"],
        viewsNum: json["views_num"],
        likeCount: json["like_count"],
        createdAt: json["created_at"],
        isFav: json["is_fav"],
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

class Rate {
    int rate;
    String comment;
    UserData userRateData;

    Rate({
        this.rate,
        this.comment,
        this.userRateData,
    });

    factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        rate: json["rate"],
        comment: json["comment"],
        userRateData: UserData.fromJson(json["user_rate_data"]),
    );

    Map<String, dynamic> toJson() => {
        "rate": rate,
        "comment": comment,
        "user_rate_data": userRateData.toJson(),
    };
}
