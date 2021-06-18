// To parse this JSON data, do
//
//     final commissionModels = commissionModelsFromJson(jsonString);

import 'dart:convert';

CommissionModels commissionModelsFromJson(String str) => CommissionModels.fromJson(json.decode(str));

String commissionModelsToJson(CommissionModels data) => json.encode(data.toJson());

class CommissionModels {
    CommissionModels({
        this.data,
        this.status,
        this.message,
    });

    Data data;
    String status;
    String message;

    factory CommissionModels.fromJson(Map<String, dynamic> json) => CommissionModels(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    Data({
        this.commission,
        this.banksAccounts,
    });

    int commission;
    List<BanksAccount> banksAccounts;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        commission: json["commission"],
        banksAccounts: List<BanksAccount>.from(json["banks_accounts"].map((x) => BanksAccount.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "commission": commission,
        "banks_accounts": List<dynamic>.from(banksAccounts.map((x) => x.toJson())),
    };
}

class BanksAccount {
    BanksAccount({
        this.id,
        this.ibanNumber,
        this.accountName,
        this.accountNumber,
        this.image,
    });

    int id;
    String ibanNumber;
    String accountName;
    String accountNumber;
    String image;

    factory BanksAccount.fromJson(Map<String, dynamic> json) => BanksAccount(
        id: json["id"],
        ibanNumber: json["iban_number"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "iban_number": ibanNumber,
        "account_name": accountName,
        "account_number": accountNumber,
        "image": image,
    };
}
