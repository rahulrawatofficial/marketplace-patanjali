// To parse this JSON data, do
//
//     final transactionsModel = transactionsModelFromJson(jsonString);

import 'dart:convert';

TransactionsModel transactionsModelFromJson(String str) =>
    TransactionsModel.fromJson(json.decode(str));

String transactionsModelToJson(TransactionsModel data) =>
    json.encode(data.toJson());

class TransactionsModel {
  List<TransactionList> transactionList;
  String responseMessage;

  TransactionsModel({
    this.transactionList,
    this.responseMessage,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
        transactionList: List<TransactionList>.from(
            json["transactionList"].map((x) => TransactionList.fromJson(x))),
        responseMessage: json["responseMessage"],
      );

  Map<String, dynamic> toJson() => {
        "transactionList":
            List<dynamic>.from(transactionList.map((x) => x.toJson())),
        "responseMessage": responseMessage,
      };
}

class TransactionList {
  String paymentMethodTypeId;
  String gatewayCode;
  DateTime transactionDate;
  String amount;
  BidDetail bidDetail;
  List<ImageD> images;
  dynamic video;
  dynamic voiceNote;
  String categoryName;
  String variety;
  CustRequestDetail custRequestDetail;
  DateTime closedDateTime;
  String biderName;

  TransactionList({
    this.paymentMethodTypeId,
    this.gatewayCode,
    this.transactionDate,
    this.amount,
    this.bidDetail,
    this.images,
    this.video,
    this.voiceNote,
    this.categoryName,
    this.variety,
    this.custRequestDetail,
    this.closedDateTime,
    this.biderName,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) =>
      TransactionList(
        paymentMethodTypeId: json["paymentMethodTypeId"],
        gatewayCode: json["gatewayCode"],
        transactionDate: DateTime.parse(json["transactionDate"]),
        amount: json["amount"],
        bidDetail: json["bidDetail"] != null
            ? BidDetail.fromJson(json["bidDetail"])
            : null,
        images: json["images"] != null
            ? List<ImageD>.from(json["images"].map((x) => ImageD.fromJson(x)))
            : null,
        video: json["video"],
        voiceNote: json["voiceNote"],
        categoryName: json["categoryName"],
        variety: json["variety"],
        custRequestDetail: json["custRequestDetail"] != null
            ? CustRequestDetail.fromJson(json["custRequestDetail"])
            : null,
        closedDateTime: json["closedDateTime"] != null
            ? DateTime.parse(json["closedDateTime"])
            : null,
        biderName: json["biderName"],
      );

  Map<String, dynamic> toJson() => {
        "paymentMethodTypeId": paymentMethodTypeId,
        "gatewayCode": gatewayCode,
        "transactionDate": transactionDate.toIso8601String(),
        "amount": amount,
        "bidDetail": bidDetail.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "video": video,
        "voiceNote": voiceNote,
        "categoryName": categoryName,
        "variety": variety,
        "custRequestDetail": custRequestDetail.toJson(),
        "closedDateTime": closedDateTime.toIso8601String(),
        "biderName": biderName,
      };
}

class BidDetail {
  double quantity;
  String comments;
  dynamic salesChannelEnumId;
  String productId;
  dynamic deliverableTypeId;
  String quoteItemSeqId;
  double quoteUnitPrice;
  String description;
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

class CustRequestDetail {
  dynamic reason;
  String fromPartyId;
  dynamic organicCertificateNumber;
  dynamic salesChannelEnumId;
  double maximumAmount;
  dynamic fulfillContactMechId;
  String description;
  int custRequestDate;
  dynamic custSequenceNum;
  dynamic internalComment;
  String adType;
  String lastModifiedByUserLogin;
  dynamic billed;
  dynamic imageUrl;
  String custRequestId;
  String productStoreId;
  String createdByUserLogin;
  int closedDateTime;
  String unitForFxiedPrice;
  String custRequestName;
  double quantity;
  dynamic responseRequiredDate;
  String productId;
  int lastModifiedDate;
  String fixedProduct;
  dynamic priority;
  dynamic maximumAmountUomId;
  String methodOfFarming;
  dynamic openDateTime;
  String custRequestItemSeqId;
  String unit;
  dynamic currencyUomId;
  int createdDate;
  String statusId;
  String custRequestTypeId;
  dynamic parentCustRequestId;
  dynamic custEstimatedMilliSeconds;
  dynamic custRequestCategoryId;

  CustRequestDetail({
    this.reason,
    this.fromPartyId,
    this.organicCertificateNumber,
    this.salesChannelEnumId,
    this.maximumAmount,
    this.fulfillContactMechId,
    this.description,
    this.custRequestDate,
    this.custSequenceNum,
    this.internalComment,
    this.adType,
    this.lastModifiedByUserLogin,
    this.billed,
    this.imageUrl,
    this.custRequestId,
    this.productStoreId,
    this.createdByUserLogin,
    this.closedDateTime,
    this.unitForFxiedPrice,
    this.custRequestName,
    this.quantity,
    this.responseRequiredDate,
    this.productId,
    this.lastModifiedDate,
    this.fixedProduct,
    this.priority,
    this.maximumAmountUomId,
    this.methodOfFarming,
    this.openDateTime,
    this.custRequestItemSeqId,
    this.unit,
    this.currencyUomId,
    this.createdDate,
    this.statusId,
    this.custRequestTypeId,
    this.parentCustRequestId,
    this.custEstimatedMilliSeconds,
    this.custRequestCategoryId,
  });

  factory CustRequestDetail.fromJson(Map<String, dynamic> json) =>
      CustRequestDetail(
        reason: json["reason"],
        fromPartyId: json["fromPartyId"],
        organicCertificateNumber: json["organicCertificateNumber"],
        salesChannelEnumId: json["salesChannelEnumId"],
        maximumAmount:
            json["maximumAmount"] == null ? null : json["maximumAmount"],
        fulfillContactMechId: json["fulfillContactMechId"],
        description: json["description"],
        custRequestDate: json["custRequestDate"],
        custSequenceNum: json["custSequenceNum"],
        internalComment: json["internalComment"],
        adType: json["adType"],
        lastModifiedByUserLogin: json["lastModifiedByUserLogin"],
        billed: json["billed"],
        imageUrl: json["imageUrl"],
        custRequestId: json["custRequestId"],
        productStoreId: json["productStoreId"],
        createdByUserLogin: json["createdByUserLogin"],
        closedDateTime: json["closedDateTime"],
        unitForFxiedPrice: json["unitForFxiedPrice"] == null
            ? null
            : json["unitForFxiedPrice"],
        custRequestName: json["custRequestName"],
        quantity: json["quantity"],
        responseRequiredDate: json["responseRequiredDate"],
        productId: json["productId"],
        lastModifiedDate: json["lastModifiedDate"],
        fixedProduct: json["fixedProduct"],
        priority: json["priority"],
        maximumAmountUomId: json["maximumAmountUomId"],
        methodOfFarming: json["methodOfFarming"],
        openDateTime: json["openDateTime"],
        custRequestItemSeqId: json["custRequestItemSeqId"],
        unit: json["unit"],
        currencyUomId: json["currencyUomId"],
        createdDate: json["createdDate"],
        statusId: json["statusId"],
        custRequestTypeId: json["custRequestTypeId"],
        parentCustRequestId: json["parentCustRequestId"],
        custEstimatedMilliSeconds: json["custEstimatedMilliSeconds"],
        custRequestCategoryId: json["custRequestCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "fromPartyId": fromPartyId,
        "organicCertificateNumber": organicCertificateNumber,
        "salesChannelEnumId": salesChannelEnumId,
        "maximumAmount": maximumAmount == null ? null : maximumAmount,
        "fulfillContactMechId": fulfillContactMechId,
        "description": description,
        "custRequestDate": custRequestDate,
        "custSequenceNum": custSequenceNum,
        "internalComment": internalComment,
        "adType": adType,
        "lastModifiedByUserLogin": lastModifiedByUserLogin,
        "billed": billed,
        "imageUrl": imageUrl,
        "custRequestId": custRequestId,
        "productStoreId": productStoreId,
        "createdByUserLogin": createdByUserLogin,
        "closedDateTime": closedDateTime,
        "unitForFxiedPrice":
            unitForFxiedPrice == null ? null : unitForFxiedPrice,
        "custRequestName": custRequestName,
        "quantity": quantity,
        "responseRequiredDate": responseRequiredDate,
        "productId": productId,
        "lastModifiedDate": lastModifiedDate,
        "fixedProduct": fixedProduct,
        "priority": priority,
        "maximumAmountUomId": maximumAmountUomId,
        "methodOfFarming": methodOfFarming,
        "openDateTime": openDateTime,
        "custRequestItemSeqId": custRequestItemSeqId,
        "unit": unit,
        "currencyUomId": currencyUomId,
        "createdDate": createdDate,
        "statusId": statusId,
        "custRequestTypeId": custRequestTypeId,
        "parentCustRequestId": parentCustRequestId,
        "custEstimatedMilliSeconds": custEstimatedMilliSeconds,
        "custRequestCategoryId": custRequestCategoryId,
      };
}

class ImageD {
  dynamic voiceUrl;
  int lastUpdatedStamp;
  dynamic videoUrl;
  String productId;
  int createdTxStamp;
  String imageUrl;
  int createdStamp;
  String custRequestId;
  String mimeTypeId;
  int lastUpdatedTxStamp;
  String partyId;
  String imageSeqId;

  ImageD({
    this.voiceUrl,
    this.lastUpdatedStamp,
    this.videoUrl,
    this.productId,
    this.createdTxStamp,
    this.imageUrl,
    this.createdStamp,
    this.custRequestId,
    this.mimeTypeId,
    this.lastUpdatedTxStamp,
    this.partyId,
    this.imageSeqId,
  });

  factory ImageD.fromJson(Map<String, dynamic> json) => ImageD(
        voiceUrl: json["voiceUrl"],
        lastUpdatedStamp: json["lastUpdatedStamp"],
        videoUrl: json["videoUrl"],
        productId: json["productId"],
        createdTxStamp: json["createdTxStamp"],
        imageUrl: json["imageUrl"],
        createdStamp: json["createdStamp"],
        custRequestId: json["custRequestId"],
        mimeTypeId: json["mimeTypeId"],
        lastUpdatedTxStamp: json["lastUpdatedTxStamp"],
        partyId: json["partyId"],
        imageSeqId: json["imageSeqId"],
      );

  Map<String, dynamic> toJson() => {
        "voiceUrl": voiceUrl,
        "lastUpdatedStamp": lastUpdatedStamp,
        "videoUrl": videoUrl,
        "productId": productId,
        "createdTxStamp": createdTxStamp,
        "imageUrl": imageUrl,
        "createdStamp": createdStamp,
        "custRequestId": custRequestId,
        "mimeTypeId": mimeTypeId,
        "lastUpdatedTxStamp": lastUpdatedTxStamp,
        "partyId": partyId,
        "imageSeqId": imageSeqId,
      };
}
