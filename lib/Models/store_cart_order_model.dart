// To parse this JSON data, do
//
//     final storeCartOrderModel = storeCartOrderModelFromJson(jsonString);

import 'dart:convert';

StoreCartOrderModel storeCartOrderModelFromJson(String str) =>
    StoreCartOrderModel.fromJson(json.decode(str));

String storeCartOrderModelToJson(StoreCartOrderModel data) =>
    json.encode(data.toJson());

class StoreCartOrderModel {
  StoreCartOrderModel({
    this.orderList,
    this.partyId,
    this.paymentId,
    this.paymentStatus,
  });

  List<OrderListStore> orderList;
  String partyId;
  String paymentId;
  String paymentStatus;

  factory StoreCartOrderModel.fromJson(Map<String, dynamic> json) =>
      StoreCartOrderModel(
        orderList: List<OrderListStore>.from(
            json["orderList"].map((x) => OrderListStore.fromJson(x))),
        partyId: json["partyId"],
        paymentId: json["paymentId"],
        paymentStatus: json["paymentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
        "partyId": partyId,
        "paymentId": paymentId,
        "paymentStatus": paymentStatus,
      };
}

class OrderListStore {
  OrderListStore({
    this.orderId,
    this.amount,
    this.inventoryItemId,
    this.shoppingListId,
    this.shoppingListItemSeqId,
  });

  String orderId;
  String amount;
  String inventoryItemId;
  String shoppingListId;
  String shoppingListItemSeqId;

  factory OrderListStore.fromJson(Map<String, dynamic> json) => OrderListStore(
        orderId: json["orderId"],
        amount: json["amount"],
        inventoryItemId: json["inventoryItemId"],
        shoppingListId: json["shoppingListId"],
        shoppingListItemSeqId: json["shoppingListItemSeqId"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "amount": amount,
        "inventoryItemId": inventoryItemId,
        "shoppingListId": shoppingListId,
        "shoppingListItemSeqId": shoppingListItemSeqId,
      };
}
