// To parse this JSON data, do
//
//     final razorPayCartModel = razorPayCartModelFromJson(jsonString);

import 'dart:convert';

RazorPayCartModel razorPayCartModelFromJson(String str) =>
    RazorPayCartModel.fromJson(json.decode(str));

String razorPayCartModelToJson(RazorPayCartModel data) =>
    json.encode(data.toJson());

class RazorPayCartModel {
  RazorPayCartModel({
    this.orderList,
    this.responseData,
    this.orderUniqueId,
    this.responseMessage,
    this.orderId,
  });

  List<OrderList> orderList;
  ResponseData responseData;
  String orderUniqueId;
  String responseMessage;
  String orderId;

  factory RazorPayCartModel.fromJson(Map<String, dynamic> json) =>
      RazorPayCartModel(
        orderList: json["orderList"] != null
            ? List<OrderList>.from(
                json["orderList"].map((x) => OrderList.fromJson(x)))
            : null,
        responseData: ResponseData.fromJson(json["responseData"]),
        orderUniqueId: json["orderUniqueId"],
        responseMessage: json["responseMessage"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
        "responseData": responseData.toJson(),
        "orderUniqueId": orderUniqueId,
        "responseMessage": responseMessage,
        "orderId": orderId,
      };
}

class OrderList {
  OrderList({
    this.orderId,
    this.amount,
    this.inventoryItemId,
  });

  String orderId;
  String amount;
  String inventoryItemId;

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        orderId: json["orderId"],
        amount: json["amount"],
        inventoryItemId: json["inventoryItemId"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "amount": amount,
        "inventoryItemId": inventoryItemId,
      };
}

class ResponseData {
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
        notes: json["notes"] != null
            ? List<dynamic>.from(json["notes"].map((x) => x))
            : null,
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
