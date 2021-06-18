// To parse this JSON data, do
//
//     final contatctUsModel = contatctUsModelFromJson(jsonString);

import 'dart:convert';

ContatctUsModel contatctUsModelFromJson(String str) => ContatctUsModel.fromJson(json.decode(str));

String contatctUsModelToJson(ContatctUsModel data) => json.encode(data.toJson());

class ContatctUsModel {
    ContatctUsModel({
        this.data,
    });

    Data data;

    factory ContatctUsModel.fromJson(Map<String, dynamic> json) => ContatctUsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.mobile1,
        this.mobile2,
        this.email,
    });

    String mobile1;
    String mobile2;
    String email;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        mobile1: json["mobile1"] == null ? null : json["mobile1"],
        mobile2: json["mobile2"] == null ? null : json["mobile2"],
        email: json["email"] == null ? null : json["email"],
    );

    Map<String, dynamic> toJson() => {
        "mobile1": mobile1 == null ? null : mobile1,
        "mobile2": mobile2 == null ? null : mobile2,
        "email": email == null ? null : email,
    };
}


// To parse this JSON data, do
//
//     final aboutUs = aboutUsFromJson(jsonString);


AboutUs aboutUsFromJson(String str) => AboutUs.fromJson(json.decode(str));

String aboutUsToJson(AboutUs data) => json.encode(data.toJson());

class AboutUs {
    AboutUs({
        this.data,
    });

    AboutUsData data;

    factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
        data: json["data"] == null ? null : AboutUsData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
    };
}

class AboutUsData {
    AboutUsData({
        this.about,
    });

    String about;

    factory AboutUsData.fromJson(Map<String, dynamic> json) => AboutUsData(
        about: json["about"] == null ? null : json["about"],
    );

    Map<String, dynamic> toJson() => {
        "about": about == null ? null : about,
    };
}
