// To parse this JSON data, do
//
//     final reportingModels = reportingModelsFromJson(jsonString);

import 'dart:convert';

ReportingModels reportingModelsFromJson(String str) => ReportingModels.fromJson(json.decode(str));

String reportingModelsToJson(ReportingModels data) => json.encode(data.toJson());

class ReportingModels {
    String data;
    String status;
    String message;

    ReportingModels({
        this.data,
        this.status,
        this.message,
    });

    factory ReportingModels.fromJson(Map<String, dynamic> json) => ReportingModels(
        data: json["data"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "status": status,
        "message": message,
    };
}
