// To parse this JSON data, do
//
//     final adsDetailsModels = adsDetailsModelsFromJson(jsonString);

import 'dart:convert';

AdsDetailsModels adsDetailsModelsFromJson(String str) =>
    AdsDetailsModels.fromJson(json.decode(str));

String adsDetailsModelsToJson(AdsDetailsModels data) =>
    json.encode(data.toJson());

class AdsDetailsModels {
  Data data;
  String status;
  String message;

  AdsDetailsModels({
    this.data,
    this.status,
    this.message,
  });

  factory AdsDetailsModels.fromJson(Map<String, dynamic> json) =>
      AdsDetailsModels(
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
  String passing_by;
  String code;
  int rateAvg;
  int accepted;
  int viewsNum;
  int likeCount;
  String createdAt;
  int isFav;
  UserData userData;
String price;
  List<ImageX> images;
  List<Rate> rates;
  List<SimilarDatum> similarData;

  Data({
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
    this.address,
    this.endLat,
    this.endLng,
    this.endAddress,
    this.code,
    this.rateAvg,
    this.accepted,
    this.price,
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
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        endLat: json["end_lat"],
        passing_by: json['passing_by'],
        endLng: json["end_lng"],
        endAddress: json["end_address"],
        code: json["code"],
        price: json['price'],
        rateAvg: json["rate_avg"],
        accepted: json["accepted"],
        viewsNum: json["views_num"],
        likeCount: json["like_count"],
        createdAt: json["created_at"],
        isFav: json["is_fav"],
        userData: UserData.fromJson(json["user_data"]),
        images:
            List<ImageX>.from(json["images"].map((x) => ImageX.fromJson(x))),
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
        similarData: List<SimilarDatum>.from(
            json["similar_data"].map((x) => SimilarDatum.fromJson(x))),
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
        "code": code,
        "rate_avg": rateAvg,
        "accepted": accepted,
        "views_num": viewsNum,
        "like_count": likeCount,
        "created_at": createdAt,
        "is_fav": isFav,

        "user_data": userData.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
        "similar_data": List<dynamic>.from(similarData.map((x) => x.toJson())),
      };
}

class ImageX {
  int id;
  String image;

  ImageX({
    this.id,
    this.image,
  });

  factory ImageX.fromJson(Map<String, dynamic> json) => ImageX(
        id: json["id"],
        image: json["Image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Image": image,
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

class SimilarDatum {
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


  SimilarDatum({
    this.id,
    this.type,
    this.userId,
    this.name,
    this.description,
    this.mobile,
    this.whatsApp,
    this.image,
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

  factory SimilarDatum.fromJson(Map<String, dynamic> json) => SimilarDatum(
        id: json["id"],
        type: json["type"],
        userId: json["user_id"],
        name: json["name"],
        image:json['image'],
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
