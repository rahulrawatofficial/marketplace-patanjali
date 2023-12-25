// To parse this JSON data, do
//
//     final adDetailModel = adDetailModelFromJson(jsonString);

import 'dart:convert';

AdDetailModel adDetailModelFromJson(String str) =>
    AdDetailModel.fromJson(json.decode(str));

String adDetailModelToJson(AdDetailModel data) => json.encode(data.toJson());

class AdDetailModel {
  String responseMessage;
  List<BidList> bidList;

  AdDetailModel({
    this.responseMessage,
    this.bidList,
  });

  factory AdDetailModel.fromJson(Map<String, dynamic> json) => AdDetailModel(
        responseMessage: json["responseMessage"],
        bidList:
            List<BidList>.from(json["bidList"].map((x) => BidList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "bidList": List<dynamic>.from(bidList.map((x) => x.toJson())),
      };
}

class BidList {
  String status;
  BidDetail bidDetail;
  String name;
  String bidderPhoneNumber;

  BidList({
    this.status,
    this.bidDetail,
    this.name,
    this.bidderPhoneNumber,
  });

  factory BidList.fromJson(Map<String, dynamic> json) => BidList(
        status: json["status"],
        bidDetail: BidDetail.fromJson(json["bidDetail"]),
        name: json["name"],
        bidderPhoneNumber: json["bidderPhoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "bidDetail": bidDetail.toJson(),
        "name": name,
        "bidderPhoneNumber": bidderPhoneNumber,
      };
}

class BidDetail {
  double quantity;
  dynamic comments;
  dynamic salesChannelEnumId;
  String productId;
  dynamic deliverableTypeId;
  String quoteItemSeqId;
  double quoteUnitPrice;
  dynamic description;
  dynamic estimatedDeliveryDate;
  String quoteId;
  dynamic validThruDate;
  double totalAmount;
  String unit;
  String quoteTypeId;
  dynamic currencyUomId;
  String quotePartyId;
  String statusId;
  String custRequestId;
  dynamic validFromDate;
  String productStoreId;
  String partyId;
  dynamic issueDate;
  dynamic selectedAmount;
  String quoteName;

  BidDetail({
    this.quantity,
    this.comments,
    this.salesChannelEnumId,
    this.productId,
    this.deliverableTypeId,
    this.quoteItemSeqId,
    this.quoteUnitPrice,
    this.description,
    this.estimatedDeliveryDate,
    this.quoteId,
    this.validThruDate,
    this.totalAmount,
    this.unit,
    this.quoteTypeId,
    this.currencyUomId,
    this.quotePartyId,
    this.statusId,
    this.custRequestId,
    this.validFromDate,
    this.productStoreId,
    this.partyId,
    this.issueDate,
    this.selectedAmount,
    this.quoteName,
  });

  factory BidDetail.fromJson(Map<String, dynamic> json) => BidDetail(
        quantity: json["quantity"],
        comments: json["comments"],
        salesChannelEnumId: json["salesChannelEnumId"],
        productId: json["productId"],
        deliverableTypeId: json["deliverableTypeId"],
        quoteItemSeqId: json["quoteItemSeqId"],
        quoteUnitPrice: json["quoteUnitPrice"],
        description: json["description"],
        estimatedDeliveryDate: json["estimatedDeliveryDate"],
        quoteId: json["quoteId"],
        validThruDate: json["validThruDate"],
        totalAmount: json["totalAmount"],
        unit: json["unit"],
        quoteTypeId: json["quoteTypeId"],
        currencyUomId: json["currencyUomId"],
        quotePartyId: json["quotePartyId"],
        statusId: json["statusId"],
        custRequestId: json["custRequestId"],
        validFromDate: json["validFromDate"],
        productStoreId: json["productStoreId"],
        partyId: json["partyId"],
        issueDate: json["issueDate"],
        selectedAmount: json["selectedAmount"],
        quoteName: json["quoteName"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "comments": comments,
        "salesChannelEnumId": salesChannelEnumId,
        "productId": productId,
        "deliverableTypeId": deliverableTypeId,
        "quoteItemSeqId": quoteItemSeqId,
        "quoteUnitPrice": quoteUnitPrice,
        "description": description,
        "estimatedDeliveryDate": estimatedDeliveryDate,
        "quoteId": quoteId,
        "validThruDate": validThruDate,
        "totalAmount": totalAmount,
        "unit": unit,
        "quoteTypeId": quoteTypeId,
        "currencyUomId": currencyUomId,
        "quotePartyId": quotePartyId,
        "statusId": statusId,
        "custRequestId": custRequestId,
        "validFromDate": validFromDate,
        "productStoreId": productStoreId,
        "partyId": partyId,
        "issueDate": issueDate,
        "selectedAmount": selectedAmount,
        "quoteName": quoteName,
      };
}
