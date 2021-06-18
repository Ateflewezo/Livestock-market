 // To parse this JSON data, do
//
//     final adsDetailsModels = adsDetailsModelsFromJson(jsonString);

import 'dart:convert';

AdsDetailsModels adsDetailsModelsFromJson(String str) => AdsDetailsModels.fromJson(json.decode(str));

String adsDetailsModelsToJson(AdsDetailsModels data) => json.encode(data.toJson());

class AdsDetailsModels {
    AdsDetailsModels({
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
        this.km,
        this.pageNo,
        this.isFav,
        this.search,
        this.imageUrl1,
        this.imageUrl2,
        this.imageUrl3,
        this.imageUrl4,
        this.imageUrl5,
    });

    int adId;
    String title;
    String description;
    bool isPact;
    bool isPaid;
    String userId;
    int cityId;
    String cityName;
    int lang;
    int lat;
    String userPhone;
    String categoryName;
    int categoryId;
    int km;
    int pageNo;
    bool isFav;
    String search;
    String imageUrl1;
    String imageUrl2;
    String imageUrl3;
    String imageUrl4;
    String imageUrl5;

    factory AdsDetailsModels.fromJson(Map<String, dynamic> json) => AdsDetailsModels(
        adId: json["adID"] == null ? null : json["adID"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        isPact: json["isPact"] == null ? null : json["isPact"],
        isPaid: json["isPaid"] == null ? null : json["isPaid"],
        userId: json["userId"] == null ? null : json["userId"],
        cityId: json["cityID"] == null ? null : json["cityID"],
        cityName: json["cityName"] == null ? null : json["cityName"],
        lang: json["lang"] == null ? null : json["lang"],
        lat: json["lat"] == null ? null : json["lat"],
        userPhone: json["userPhone"] == null ? null : json["userPhone"],
        categoryName: json["categoryName"] == null ? null : json["categoryName"],
        categoryId: json["categoryID"] == null ? null : json["categoryID"],
        km: json["km"] == null ? null : json["km"],
        pageNo: json["pageNo"] == null ? null : json["pageNo"],
        isFav: json["isFav"] == null ? null : json["isFav"],
        search: json["search"] == null ? null : json["search"],
        imageUrl1: json["imageUrl1"] == null ? null : json["imageUrl1"],
        imageUrl2: json["imageUrl2"] == null ? null : json["imageUrl2"],
        imageUrl3: json["imageUrl3"] == null ? null : json["imageUrl3"],
        imageUrl4: json["imageUrl4"] == null ? null : json["imageUrl4"],
        imageUrl5: json["imageUrl5"] == null ? null : json["imageUrl5"],
    );

    Map<String, dynamic> toJson() => {
        "adID": adId == null ? null : adId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "isPact": isPact == null ? null : isPact,
        "isPaid": isPaid == null ? null : isPaid,
        "userId": userId == null ? null : userId,
        "cityID": cityId == null ? null : cityId,
        "cityName": cityName == null ? null : cityName,
        "lang": lang == null ? null : lang,
        "lat": lat == null ? null : lat,
        "userPhone": userPhone == null ? null : userPhone,
        "categoryName": categoryName == null ? null : categoryName,
        "categoryID": categoryId == null ? null : categoryId,
        "km": km == null ? null : km,
        "pageNo": pageNo == null ? null : pageNo,
        "isFav": isFav == null ? null : isFav,
        "search": search == null ? null : search,
        "imageUrl1": imageUrl1 == null ? null : imageUrl1,
        "imageUrl2": imageUrl2 == null ? null : imageUrl2,
        "imageUrl3": imageUrl3 == null ? null : imageUrl3,
        "imageUrl4": imageUrl4 == null ? null : imageUrl4,
        "imageUrl5": imageUrl5 == null ? null : imageUrl5,
    };
}
