// To parse this JSON data, do
//
//     final homeCategoryModel = homeCategoryModelFromJson(jsonString);

import 'dart:convert';

HomeCategoryModel homeCategoryModelFromJson(String str) =>
    HomeCategoryModel.fromJson(json.decode(str));

String homeCategoryModelToJson(HomeCategoryModel data) =>
    json.encode(data.toJson());

class HomeCategoryModel {
  List<CategoryList> categoryList;
  String responseMessage;

  HomeCategoryModel({
    this.categoryList,
    this.responseMessage,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) =>
      HomeCategoryModel(
        categoryList: List<CategoryList>.from(
            json["categoryList"].map((x) => CategoryList.fromJson(x))),
        responseMessage: json["responseMessage"],
      );

  Map<String, dynamic> toJson() => {
        "categoryList": List<dynamic>.from(categoryList.map((x) => x.toJson())),
        "responseMessage": responseMessage,
      };
}

class CategoryList {
  String primaryCategoryName;
  String productCategoryId;
  String categoryImageUrl;

  CategoryList({
    this.primaryCategoryName,
    this.productCategoryId,
    this.categoryImageUrl,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        primaryCategoryName: json["primaryCategoryName"],
        productCategoryId: json["productCategoryId"],
        categoryImageUrl:
            json["categoryImageUrl"] == null ? null : json["categoryImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "primaryCategoryName": primaryCategoryName,
        "productCategoryId": productCategoryId,
        "categoryImageUrl": categoryImageUrl == null ? null : categoryImageUrl,
      };
}
