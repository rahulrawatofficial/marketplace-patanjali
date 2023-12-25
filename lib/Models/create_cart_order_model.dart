// To parse this JSON data, do
//
//     final createCartOrderModel = createCartOrderModelFromJson(jsonString);

import 'dart:convert';

CreateCartOrderModel createCartOrderModelFromJson(String str) =>
    CreateCartOrderModel.fromJson(json.decode(str));

String createCartOrderModelToJson(CreateCartOrderModel data) =>
    json.encode(data.toJson());

class CreateCartOrderModel {
  CreateCartOrderModel({
    this.totalAmount,
    this.inventoryItemDetail,
  });

  String totalAmount;
  List<InventoryItemDetail> inventoryItemDetail;

  factory CreateCartOrderModel.fromJson(Map<String, dynamic> json) =>
      CreateCartOrderModel(
        totalAmount: json["totalAmount"],
        inventoryItemDetail: List<InventoryItemDetail>.from(
            json["inventoryItemDetail"]
                .map((x) => InventoryItemDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "inventoryItemDetail":
            List<dynamic>.from(inventoryItemDetail.map((x) => x.toJson())),
      };
}

class InventoryItemDetail {
  InventoryItemDetail({
    this.inventoryItemId,
    this.amount,
    this.quantity,
    this.shoppingListId,
    this.paymentMethodTypeId,
    this.shoppingListItemSeqId,
  });

  String inventoryItemId;
  String paymentMethodTypeId;
  String amount;
  String quantity;
  String shoppingListId;
  String shoppingListItemSeqId;

  factory InventoryItemDetail.fromJson(Map<String, dynamic> json) =>
      InventoryItemDetail(
        inventoryItemId: json["inventoryItemId"],
        amount: json["amount"],
        quantity: json["quantity"],
        paymentMethodTypeId: json["paymentMethodTypeId"],
        shoppingListId: json["shoppingListId"],
        shoppingListItemSeqId: json["shoppingListItemSeqId"],
      );

  Map<String, dynamic> toJson() => paymentMethodTypeId != null
      ? {
          "inventoryItemId": inventoryItemId,
          "amount": amount,
          "quantity": quantity,
          "paymentMethodTypeId": paymentMethodTypeId,
          "shoppingListId": shoppingListId,
          "shoppingListItemSeqId": shoppingListItemSeqId,
        }
      : {
          "inventoryItemId": inventoryItemId,
          "amount": amount,
          "quantity": quantity,
          "shoppingListId": shoppingListId,
          "shoppingListItemSeqId": shoppingListItemSeqId,
        };
}
