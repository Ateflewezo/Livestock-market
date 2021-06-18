// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    OrderDetailsModel({
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
        this.comments,
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
    List<Comment> comments;

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        adId: json["adID"],
        title: json["title"],
        description: json["description"],
        isPact: json["isPact"],
        isPaid: json["isPaid"],
        userId: json["userId"],
        cityId: json["cityID"],
        cityName: json["cityName"],
        lang: json["lang"],
        lat: json["lat"],
        userPhone: json["userPhone"],
        categoryName: json["categoryName"],
        categoryId: json["categoryID"],
        km: json["km"],
        pageNo: json["pageNo"],
        isFav: json["isFav"],
        search: json["search"],
        imageUrl1: json["imageUrl1"],
        imageUrl2: json["imageUrl2"],
        imageUrl3: json["imageUrl3"],
        imageUrl4: json["imageUrl4"],
        imageUrl5: json["imageUrl5"],
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
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
        "lat": lat,
        "userPhone": userPhone,
        "categoryName": categoryName,
        "categoryID": categoryId,
        "km": km,
        "pageNo": pageNo,
        "isFav": isFav,
        "search": search,
        "imageUrl1": imageUrl1,
        "imageUrl2": imageUrl2,
        "imageUrl3": imageUrl3,
        "imageUrl4": imageUrl4,
        "imageUrl5": imageUrl5,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    };
}

class Comment {
    Comment({
        this.commentId,
        this.name,
        this.commentText,
        this.date,
        this.userId,
        this.advId,
    });

    int commentId;
    String name;
    String commentText;
    DateTime date;
    String userId;
    int advId;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["commentID"],
        name: json["name"],
        commentText: json["commentText"],
        date: DateTime.parse(json["date"]),
        userId: json["userId"],
        advId: json["advID"],
    );

    Map<String, dynamic> toJson() => {
        "commentID": commentId,
        "name": name,
        "commentText": commentText,
        "date": date.toIso8601String(),
        "userId": userId,
        "advID": advId,
    };
}
