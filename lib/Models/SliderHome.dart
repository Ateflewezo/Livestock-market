// To parse this JSON data, do
//
//     final sliderHome = sliderHomeFromJson(jsonString);

import 'dart:convert';

SliderHome sliderHomeFromJson(String str) => SliderHome.fromJson(json.decode(str));

String sliderHomeToJson(SliderHome data) => json.encode(data.toJson());

class SliderHome {
    SliderHome({
        this.data,
        this.status,
        this.message,
    });

    List<Datum> data;
    String status;
    String message;

    factory SliderHome.fromJson(Map<String, dynamic> json) => SliderHome(
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
        this.image,
    });

    int id;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["Image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "Image": image,
    };
}
