// To parse this JSON data, do
//
//     final allCategoryModels = allCategoryModelsFromJson(jsonString);

import 'dart:convert';

AllCategoryModels allCategoryModelsFromJson(String str) =>
    AllCategoryModels.fromJson(json.decode(str));

String allCategoryModelsToJson(AllCategoryModels data) =>
    json.encode(data.toJson());

class AllCategoryModels {
  List<Datum> data;
  String status;
  String message;

  AllCategoryModels({
    this.data,
    this.status,
    this.message,
  });

  factory AllCategoryModels.fromJson(Map<String, dynamic> json) =>
      AllCategoryModels(
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

  Datum({
    this.id,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// To parse this JSON data, do
//
//     final allCategoryModel = allCategoryModelFromJson(jsonString);

// import 'dart:convert';

AllCategoryModel allCategoryModelFromJson(String str) =>
    AllCategoryModel.fromJson(json.decode(str));

String allCategoryModelToJson(AllCategoryModel data) =>
    json.encode(data.toJson());

class AllCategoryModel {
  AllCategoryModel({
    this.advertisments,
    this.cities,
    this.categories,
    this.pageNo,
  });

  List<Advertisment> advertisments;
  List<City> cities;
  List<Category> categories;
   int pageNo;
  factory AllCategoryModel.fromJson(Map<String, dynamic> json) =>
      AllCategoryModel(
        advertisments: List<Advertisment>.from(
            json["advertisments"].map((x) => Advertisment.fromJson(x))),
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
            pageNo: json["pageNo"]
      );

  Map<String, dynamic> toJson() => {
        "advertisments":
            List<dynamic>.from(advertisments.map((x) => x.toJson())),
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "pageNo" :pageNo,
      };
}

class Advertisment {
  Advertisment({
    this.adId,
    this.title,
    this.description,
    this.isPact,
    this.isPaid,
    this.userId,
    this.cityId,
    this.cityName,
    this.lang,
    this.lat,
    this.userPhone,
    this.categoryName,
    this.categoryId,
    this.isFav,
    this.km,
    this.pageNo,
    this.search,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.imageUrl4,
    this.imageUrl5,
  });

  int adId;
  String title;
  dynamic description;
  bool isPact;
  bool isPaid;
  dynamic userId;
  int cityId;
  String cityName;
  double lang;
  double lat;
  dynamic userPhone;
  String categoryName;
  int categoryId;
  int km;
  int pageNo;
  bool isFav;
  dynamic search;
  String imageUrl1;
  String imageUrl2;
  String imageUrl3;
  String imageUrl4;
  String imageUrl5;

  factory Advertisment.fromJson(Map<String, dynamic> json) => Advertisment(
        adId: json["adID"],
        title: json["title"],
        description: json["description"],
        isPact: json["isPact"],
        isPaid: json["isPaid"],
        userId: json["userId"],
        isFav: json['isFav'],
        cityId: json["cityID"],
        cityName: json["cityName"],
        lang: json["lang"].toDouble(),
        lat: json["lat"].toDouble(),
        userPhone: json["userPhone"],
        categoryName: json["categoryName"],
        categoryId: json["categoryID"],
        km: json["km"],
        pageNo: json["pageNo"],
        search: json["search"],
        imageUrl1: json["imageUrl1"],
        imageUrl2: json["imageUrl2"],
        imageUrl3: json["imageUrl3"],
        imageUrl4: json["imageUrl4"],
        imageUrl5: json["imageUrl5"],
      );

  Map<String, dynamic> toJson() => {
        "adID": adId,
        "title": title,
        "description": description,
        "isPact": isPact,
        "isPaid": isPaid,
        "userId": userId,
        "cityID": cityId,
        "cityName": cityName,
        "lang": lang,
        "isFav":isFav,
        "lat": lat,
        "userPhone": userPhone,
        "categoryName": categoryName,
        "categoryID": categoryId,
        "km": km,
        "pageNo": pageNo,
        "search": search,
        "imageUrl1": imageUrl1,
        "imageUrl2": imageUrl2,
        "imageUrl3": imageUrl3,
        "imageUrl4": imageUrl4,
        "imageUrl5": imageUrl5,
      };
}

class Category {
  Category({
    this.categoryId,
    this.categoryName,
    this.advertisments,
  });

  int categoryId;
  String categoryName;
  dynamic advertisments;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryID"],
        categoryName: json["categoryName"],
        advertisments: json["advertisments"],
      );

  Map<String, dynamic> toJson() => {
        "categoryID": categoryId,
        "categoryName": categoryName,
        "advertisments": advertisments,
      };
}

class City {
  City({
    this.cityId,
    this.cityName,
    this.langtude,
    this.lantitude,
    this.users,
    this.advertisments,
  });

  int cityId;
  String cityName;
  String langtude;
  String lantitude;
  dynamic users;
  dynamic advertisments;

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json["cityID"],
        cityName: json["cityName"],
        langtude: json["langtude"],
        lantitude: json["lantitude"],
        users: json["users"],
        advertisments: json["advertisments"],
      );

  Map<String, dynamic> toJson() => {
        "cityID": cityId,
        "cityName": cityName,
        "langtude": langtude,
        "lantitude": lantitude,
        "users": users,
        "advertisments": advertisments,
      };
}
