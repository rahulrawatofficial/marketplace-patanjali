// To parse this JSON data, do
//
//     final userAuctionModel = userAuctionModelFromJson(jsonString);

import 'dart:convert';

UserAuctionModel userAuctionModelFromJson(String str) =>
    UserAuctionModel.fromJson(json.decode(str));

String userAuctionModelToJson(UserAuctionModel data) =>
    json.encode(data.toJson());

class UserAuctionModel {
  List<RequestList> requestList;
  String responseMessage;

  UserAuctionModel({
    this.requestList,
    this.responseMessage,
  });

  factory UserAuctionModel.fromJson(Map<String, dynamic> json) =>
      UserAuctionModel(
        requestList: List<RequestList>.from(
            json["requestList"].map((x) => RequestList.fromJson(x))),
        responseMessage: json["responseMessage"],
      );

  Map<String, dynamic> toJson() => {
        "requestList": List<dynamic>.from(requestList.map((x) => x.toJson())),
        "responseMessage": responseMessage,
      };
}

class RequestList {
  List<ImageD> images;
  dynamic video;
  String bidId;
  dynamic voiceNote;
  String productUploadTime;
  dynamic wishListId;
  dynamic wishListItemSeqId;
  String categoryName;
  String variety;
  String sellerName;
  CustRequestDetail custRequestDetail;
  DateTime custRequestDate;
  DateTime closedDateTime;
  String inventoryItemId;

  RequestList({
    this.images,
    this.video,
    this.bidId,
    this.voiceNote,
    this.productUploadTime,
    this.wishListId,
    this.wishListItemSeqId,
    this.categoryName,
    this.variety,
    this.sellerName,
    this.custRequestDetail,
    this.custRequestDate,
    this.closedDateTime,
    this.inventoryItemId,
  });

  factory RequestList.fromJson(Map<String, dynamic> json) => RequestList(
        images:
            List<ImageD>.from(json["images"].map((x) => ImageD.fromJson(x))),
        video: json["video"],
        bidId: json["bidId"],
        voiceNote: json["voiceNote"],
        productUploadTime: json["productUploadTime"],
        wishListId: json["wishListId"],
        wishListItemSeqId: json["wishListItemSeqId"],
        categoryName: json["categoryName"],
        variety: json["variety"],
        sellerName: json["sellerName"],
        custRequestDetail: json["custRequestDetail"] != null
            ? CustRequestDetail.fromJson(json["custRequestDetail"])
            : null,
        custRequestDate: json["custRequestDate"] != null
            ? DateTime.parse(json["custRequestDate"])
            : null,
        closedDateTime: DateTime.parse(json["closedDateTime"]),
        inventoryItemId: json["inventoryItemId"],
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "video": video,
        "bidId": bidId,
        "voiceNote": voiceNote,
        "productUploadTime": productUploadTime,
        "wishListId": wishListId,
        "wishListItemSeqId": wishListItemSeqId,
        "categoryName": categoryName,
        "variety": variety,
        "sellerName": sellerName,
        "custRequestDetail": custRequestDetail.toJson(),
        "custRequestDate": custRequestDate.toIso8601String(),
        "closedDateTime": closedDateTime.toIso8601String(),
        "inventoryItemId": inventoryItemId,
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
  String inventoryItemId;

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
    this.inventoryItemId,
  });

  factory CustRequestDetail.fromJson(Map<String, dynamic> json) =>
      CustRequestDetail(
        reason: json["reason"] != null ? json["reason"] : null,
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
        unit: json["unit"] == null ? null : json["unit"],
        currencyUomId: json["currencyUomId"],
        createdDate: json["createdDate"],
        statusId: json["statusId"],
        custRequestTypeId: json["custRequestTypeId"],
        parentCustRequestId: json["parentCustRequestId"],
        custEstimatedMilliSeconds: json["custEstimatedMilliSeconds"],
        custRequestCategoryId: json["custRequestCategoryId"],
        inventoryItemId: json["inventoryItemId"],
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
        "unit": unit == null ? null : unit,
        "currencyUomId": currencyUomId,
        "createdDate": createdDate,
        "statusId": statusId,
        "custRequestTypeId": custRequestTypeId,
        "parentCustRequestId": parentCustRequestId,
        "custEstimatedMilliSeconds": custEstimatedMilliSeconds,
        "custRequestCategoryId": custRequestCategoryId,
        "inventoryItemId": inventoryItemId,
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
