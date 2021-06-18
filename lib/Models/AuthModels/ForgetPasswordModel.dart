// To parse this JSON data, do
//
//     final forgetPasswordModel = forgetPasswordModelFromJson(jsonString);

import 'dart:convert';

ForgetPasswordModel forgetPasswordModelFromJson(String str) => ForgetPasswordModel.fromJson(json.decode(str));

String forgetPasswordModelToJson(ForgetPasswordModel data) => json.encode(data.toJson());

class ForgetPasswordModel {
    ForgetPasswordModel({
        this.key,
        this.code,
        this.msg,
        this.status,
    });

    int key;
    Code code;
    String msg;
    String status;

    factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) => ForgetPasswordModel(
        key: json["key"] == null ? null : json["key"],
        code: json["code"] == null ? null : Code.fromJson(json["code"]),
        msg: json["msg"] == null ? null : json["msg"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "code": code == null ? null : code.toJson(),
        "msg": msg == null ? null : msg,
        "status": status == null ? null : status,
    };
}

class Code {
    Code({
        this.code,
        this.userId,
    });

    int code;
    String userId;

    factory Code.fromJson(Map<String, dynamic> json) => Code(
        code: json["code"] == null ? null : json["code"],
        userId: json["user_id"] == null ? null : json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "user_id": userId == null ? null : userId,
    };
}
