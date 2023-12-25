// To parse this JSON data, do
//
// final varietyModel = varietyModelFromJson(jsonString);

import 'dart:convert';

VarietyModel varietyModelFromJson(String str) =>
    VarietyModel.fromJson(json.decode(str));

String varietyModelToJson(VarietyModel data) => json.encode(data.toJson());

class VarietyModel {
  String responseMessage;
  List<ProductMembersList> productMembersList;

  VarietyModel({
    this.responseMessage,
    this.productMembersList,
  });

  factory VarietyModel.fromJson(Map<String, dynamic> json) => VarietyModel(
        responseMessage: json["responseMessage"],
        productMembersList: List<ProductMembersList>.from(
            json["productMembersList"]
                .map((x) => ProductMembersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "productMembersList":
            List<dynamic>.from(productMembersList.map((x) => x.toJson())),
      };
}

class ProductMembersList {
  String productId;
  String productName;

  ProductMembersList({
    this.productId,
    this.productName,
  });

  factory ProductMembersList.fromJson(Map<String, dynamic> json) =>
      ProductMembersList(
        productId: json["productId"],
        productName: json["productName"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
      };
}
