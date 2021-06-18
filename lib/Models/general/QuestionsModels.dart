// To parse this JSON data, do
//
//     final questionsModels = questionsModelsFromJson(jsonString);

import 'dart:convert';

QuestionsModels questionsModelsFromJson(String str) => QuestionsModels.fromJson(json.decode(str));

String questionsModelsToJson(QuestionsModels data) => json.encode(data.toJson());

class QuestionsModels {
    List<Datum> data;
    String status;
    String message;

    QuestionsModels({
        this.data,
        this.status,
        this.message,
    });

    factory QuestionsModels.fromJson(Map<String, dynamic> json) => QuestionsModels(
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
    String question;
    String answer;

    Datum({
        this.question,
        this.answer,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        question: json["question"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
    };
}
