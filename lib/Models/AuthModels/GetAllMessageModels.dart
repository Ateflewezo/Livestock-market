// To parse this JSON data, do
//
//     final getAllPaiyAds = getAllPaiyAdsFromJson(jsonString);

import 'dart:convert';

GetAllPaiyAds getAllPaiyAdsFromJson(String str) => GetAllPaiyAds.fromJson(json.decode(str));

String getAllPaiyAdsToJson(GetAllPaiyAds data) => json.encode(data.toJson());

class GetAllPaiyAds {
    GetAllPaiyAds({
        this.data,
    });

    List<Datum> data;

    factory GetAllPaiyAds.fromJson(Map<String, dynamic> json) => GetAllPaiyAds(
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.adId,
        this.title,
        this.imageUrl1,
        this.url,
    });

    int adId;
    String title;
    String imageUrl1;
    String url;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        adId: json["adID"] == null ? null : json["adID"],
        title: json["title"] == null ? null : json["title"],
        imageUrl1: json["imageUrl1"] == null ? null : json["imageUrl1"],
        url: json["url"] == null ? null : json["url"],
    );

    Map<String, dynamic> toJson() => {
        "adID": adId == null ? null : adId,
        "title": title == null ? null : title,
        "imageUrl1": imageUrl1 == null ? null : imageUrl1,
        "url": url == null ? null : url,
    };
}
