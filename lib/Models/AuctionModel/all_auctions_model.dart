// To parse this JSON data, do
//
// final allAuctionsModel = allAuctionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/user_profile_model.dart';

List<AllAuctionsModel> allAuctionsModelFromJson(String str) =>
    List<AllAuctionsModel>.from(
        json.decode(str).map((x) => AllAuctionsModel.fromJson(x)));

String allAuctionsModelToJson(List<AllAuctionsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllAuctionsModel {
  String id;
  String creationDate;
  Product product;
  UserProfileModel user;
  String startTime;
  String endTime;
  dynamic startingAmount;
  dynamic winningBidAmount;
  dynamic minimumBidingAmount;
  dynamic bidsCount;
  dynamic winningBidUserId;
  bool active;

  AllAuctionsModel({
    this.id,
    this.creationDate,
    this.product,
    this.user,
    this.startTime,
    this.endTime,
    this.startingAmount,
    this.winningBidAmount,
    this.minimumBidingAmount,
    this.bidsCount,
    this.winningBidUserId,
    this.active,
  });

  factory AllAuctionsModel.fromJson(Map<String, dynamic> json) =>
      AllAuctionsModel(
        id: json["id"],
        creationDate: json["creationDate"],
        product: Product.fromJson(json["product"]),
        user: UserProfileModel.fromJson(json["user"]),
        startTime: json["startTime"],
        endTime: json["endTime"],
        startingAmount: json["startingAmount"],
        winningBidAmount: json["winningBidAmount"],
        minimumBidingAmount: json["minimumBidingAmount"],
        bidsCount: json["bidsCount"],
        winningBidUserId: json["winningBidUserId"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "product": product.toJson(),
        "user": user.toJson(),
        "startTime": startTime,
        "endTime": endTime,
        "startingAmount": startingAmount,
        "winningBidAmount": winningBidAmount,
        "minimumBidingAmount": minimumBidingAmount,
        "bidsCount": bidsCount,
        "winningBidUserId": winningBidUserId,
        "active": active,
      };
}

class Product {
  String id;
  String creationDate;
  String productId;
  String productName;
  dynamic description;
  dynamic imageUrl;
  dynamic createdVia;
  dynamic userCrop;
  bool active;

  Product({
    this.id,
    this.creationDate,
    this.productId,
    this.productName,
    this.description,
    this.imageUrl,
    this.createdVia,
    this.userCrop,
    this.active,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        creationDate: json["creationDate"],
        productId: json["productId"],
        productName: json["productName"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        createdVia: json["createdVia"],
        userCrop: json["userCrop"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "productId": productId,
        "productName": productName,
        "description": description,
        "imageUrl": imageUrl,
        "createdVia": createdVia,
        "userCrop": userCrop,
        "active": active,
      };
}
