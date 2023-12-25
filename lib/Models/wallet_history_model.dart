// To parse this JSON data, do
//
//     final walletHistoryModel = walletHistoryModelFromJson(jsonString);

import 'dart:convert';

WalletHistoryModel walletHistoryModelFromJson(String str) =>
    WalletHistoryModel.fromJson(json.decode(str));

String walletHistoryModelToJson(WalletHistoryModel data) =>
    json.encode(data.toJson());

class WalletHistoryModel {
  WalletHistoryModel({
    this.responseMessage,
    this.walletTransactionList,
  });

  String responseMessage;
  List<WalletTransactionList> walletTransactionList;

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) =>
      WalletHistoryModel(
        responseMessage: json["responseMessage"],
        walletTransactionList: List<WalletTransactionList>.from(
            json["walletTransactionList"]
                .map((x) => WalletTransactionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "walletTransactionList":
            List<dynamic>.from(walletTransactionList.map((x) => x.toJson())),
      };
}

class WalletTransactionList {
  WalletTransactionList({
    this.paymentMethodTypeId,
    this.gatewayCode,
    this.transactionDate,
    this.amount,
  });

  String paymentMethodTypeId;
  String gatewayCode;
  DateTime transactionDate;
  String amount;

  factory WalletTransactionList.fromJson(Map<String, dynamic> json) =>
      WalletTransactionList(
        paymentMethodTypeId: json["paymentMethodTypeId"],
        gatewayCode: json["gatewayCode"],
        transactionDate: DateTime.parse(json["transactionDate"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "paymentMethodTypeId": paymentMethodTypeId,
        "gatewayCode": gatewayCode,
        "transactionDate": transactionDate.toIso8601String(),
        "amount": amount,
      };
}
