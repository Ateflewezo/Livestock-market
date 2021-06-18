// To parse this JSON data, do
//
//     final favModel = favModelFromJson(jsonString);

import 'dart:convert';

List<FavModel> favModelFromJson(String str) =>
    List<FavModel>.from(json.decode(str).map((x) => FavModel.fromJson(x)));

String favModelToJson(List<FavModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavModel {
  FavModel({
    this.adId,
    this.title,
    this.description,
    this.cityName,
    this.categoryName,
    this.imageUrl1,
    this.isFav
  });

  int adId;
  String title;
  String description;
  String cityName;
  String categoryName;
  String imageUrl1;
  bool isFav;

  factory FavModel.fromJson(Map<String, dynamic> json) => FavModel(
        adId: json["adID"] == null ? null : json["adID"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        cityName: json["cityName"] == null ? null : json["cityName"],
        categoryName:
            json["categoryName"] == null ? null : json["categoryName"],
        imageUrl1: json["imageUrl1"] == null ? null : json["imageUrl1"],
        isFav: true
      );

  Map<String, dynamic> toJson() => {
        "adID": adId == null ? null : adId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "cityName": cityName == null ? null : cityName,
        "categoryName": categoryName == null ? null : categoryName,
        "imageUrl1": imageUrl1 == null ? null : imageUrl1,
      };
}
