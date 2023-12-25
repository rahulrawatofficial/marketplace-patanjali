// To parse this JSON data, do
//
//     final razorPayModel = razorPayModelFromJson(jsonString);

import 'dart:convert';

RazorPayModel razorPayModelFromJson(String str) =>
    RazorPayModel.fromJson(json.decode(str));

String razorPayModelToJson(RazorPayModel data) => json.encode(data.toJson());

class RazorPayModel {
  String responseMessage;
  ResponseData responseData;
  String orderId;

  RazorPayModel({
    this.responseMessage,
    this.responseData,
    this.orderId,
  });

  factory RazorPayModel.fromJson(Map<String, dynamic> json) => RazorPayModel(
        responseMessage: json["responseMessage"],
        responseData: ResponseData.fromJson(json["responseData"]),
        orderId:json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "responseData": responseData.toJson(),
        "orderId":orderId,
      };
}

class ResponseData {
  String id;
  String entity;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  dynamic offerId;
  String status;
  int attempts;
  List<dynamic> notes;
  int createdAt;

  ResponseData({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.offerId,
    this.status,
    this.attempts,
    this.notes,
    this.createdAt,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        amountDue: json["amount_due"],
        currency: json["currency"],
        receipt: json["receipt"],
        offerId: json["offer_id"],
        status: json["status"],
        attempts: json["attempts"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "currency": currency,
        "receipt": receipt,
        "offer_id": offerId,
        "status": status,
        "attempts": attempts,
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "created_at": createdAt,
      };
}
