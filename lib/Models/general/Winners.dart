// To parse this JSON data, do
//
//     final winnersShow = winnersShowFromJson(jsonString);

import 'dart:convert';

WinnersShow winnersShowFromJson(String str) => WinnersShow.fromJson(json.decode(str));

String winnersShowToJson(WinnersShow data) => json.encode(data.toJson());

class WinnersShow {
    WinnersShow({
        this.data,
        this.status,
        this.message,
    });

    List<Datum> data;
    String status;
    String message;

    factory WinnersShow.fromJson(Map<String, dynamic> json) => WinnersShow(
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
        this.name,
        this.image,
    });

    int id;
    String name;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
