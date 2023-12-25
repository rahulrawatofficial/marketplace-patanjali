// To parse this JSON data, do
//
//     final primaryCategoryModel = primaryCategoryModelFromJson(jsonString);

import 'dart:convert';

PrimaryCategoryModel primaryCategoryModelFromJson(String str) =>
    PrimaryCategoryModel.fromJson(json.decode(str));

String primaryCategoryModelToJson(PrimaryCategoryModel data) =>
    json.encode(data.toJson());

class PrimaryCategoryModel {
  PrimaryCategoryModel({
    this.responseMessage,
    this.prodCatalogCategoryList,
  });

  String responseMessage;
  List<ProdCatalogCategoryList> prodCatalogCategoryList;

  factory PrimaryCategoryModel.fromJson(Map<String, dynamic> json) =>
      PrimaryCategoryModel(
        responseMessage: json["responseMessage"],
        prodCatalogCategoryList: List<ProdCatalogCategoryList>.from(
            json["prodCatalogCategoryList"]
                .map((x) => ProdCatalogCategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "prodCatalogCategoryList":
            List<dynamic>.from(prodCatalogCategoryList.map((x) => x.toJson())),
      };
}

class ProdCatalogCategoryList {
  ProdCatalogCategoryList({
    this.productCategoryId,
    this.categoryName,
    this.categoryImageUrl,
  });

  String productCategoryId;
  String categoryName;
  String categoryImageUrl;

  factory ProdCatalogCategoryList.fromJson(Map<String, dynamic> json) =>
      ProdCatalogCategoryList(
        productCategoryId: json["productCategoryId"],
        categoryName: json["categoryName"],
        categoryImageUrl:
            json["categoryImageUrl"] == null ? null : json["categoryImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "productCategoryId": productCategoryId,
        "categoryName": categoryName,
        "categoryImageUrl": categoryImageUrl == null ? null : categoryImageUrl,
      };
}
