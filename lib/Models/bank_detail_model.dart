// To parse this JSON data, do
//
//     final bankDetailModel = bankDetailModelFromJson(jsonString);

import 'dart:convert';

BankDetailModel bankDetailModelFromJson(String str) =>
    BankDetailModel.fromJson(json.decode(str));

String bankDetailModelToJson(BankDetailModel data) =>
    json.encode(data.toJson());

class BankDetailModel {
  String partyId;
  ReqData reqData;

  BankDetailModel({
    this.partyId,
    this.reqData,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) =>
      BankDetailModel(
        partyId: json["partyId"],
        reqData: ReqData.fromJson(json["reqData"]),
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "reqData": reqData.toJson(),
      };
}

class ReqData {
  String accountHolderName;
  String accountNumber;
  String bankName;
  String ifscCode;

  ReqData({
    this.accountHolderName,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
  });

  factory ReqData.fromJson(Map<String, dynamic> json) => ReqData(
        accountNumber: json["accountNumber"],
        bankName: json["bankName"],
        ifscCode: json["ifscCode"],
        accountHolderName: json["accountHolderName"],
      );

  Map<String, dynamic> toJson() => {
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "bankName": bankName,
        "ifscCode": ifscCode,
      };
}
