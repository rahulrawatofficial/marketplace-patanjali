// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String responseMessage;
  List<Category> categories;

  CategoryModel({
    this.responseMessage,
    this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        responseMessage: json["responseMessage"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  dynamic longDescription;
  int lastUpdatedStamp;
  String productCategoryTypeId;
  dynamic detailScreen;
  int createdTxStamp;
  int createdStamp;
  dynamic description;
  int lastUpdatedTxStamp;
  dynamic linkTwoImageUrl;
  String categoryName;
  String productCategoryId;
  dynamic linkOneImageUrl;
  String primaryParentCategoryId;
  dynamic categoryImageUrl;
  String showChildCategory;
  dynamic showInSelect;

  Category({
    this.longDescription,
    this.lastUpdatedStamp,
    this.productCategoryTypeId,
    this.detailScreen,
    this.createdTxStamp,
    this.createdStamp,
    this.description,
    this.lastUpdatedTxStamp,
    this.linkTwoImageUrl,
    this.categoryName,
    this.productCategoryId,
    this.linkOneImageUrl,
    this.primaryParentCategoryId,
    this.categoryImageUrl,
    this.showChildCategory,
    this.showInSelect,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        longDescription: json["longDescription"],
        lastUpdatedStamp: json["lastUpdatedStamp"],
        productCategoryTypeId: json["productCategoryTypeId"],
        detailScreen: json["detailScreen"],
        createdTxStamp: json["createdTxStamp"],
        createdStamp: json["createdStamp"],
        description: json["description"],
        lastUpdatedTxStamp: json["lastUpdatedTxStamp"],
        linkTwoImageUrl: json["linkTwoImageUrl"],
        categoryName: json["categoryName"],
        productCategoryId: json["productCategoryId"],
        linkOneImageUrl: json["linkOneImageUrl"],
        primaryParentCategoryId: json["primaryParentCategoryId"],
        categoryImageUrl: json["categoryImageUrl"],
        showChildCategory: json["showChildCategory"],
        showInSelect: json["showInSelect"],
      );

  Map<String, dynamic> toJson() => {
        "longDescription": longDescription,
        "lastUpdatedStamp": lastUpdatedStamp,
        "productCategoryTypeId": productCategoryTypeId,
        "detailScreen": detailScreen,
        "createdTxStamp": createdTxStamp,
        "createdStamp": createdStamp,
        "description": description,
        "lastUpdatedTxStamp": lastUpdatedTxStamp,
        "linkTwoImageUrl": linkTwoImageUrl,
        "categoryName": categoryName,
        "productCategoryId": productCategoryId,
        "linkOneImageUrl": linkOneImageUrl,
        "primaryParentCategoryId": primaryParentCategoryId,
        "categoryImageUrl": categoryImageUrl,
        "showChildCategory": showChildCategory,
        "showInSelect": showInSelect,
      };
}
