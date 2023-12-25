// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
    List<RequestList> requestList;
    String responseMessage;

    AdsModel({
        this.requestList,
        this.responseMessage,
    });

    factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
        requestList: List<RequestList>.from(json["requestList"].map((x) => RequestList.fromJson(x))),
        responseMessage: json["responseMessage"],
    );

    Map<String, dynamic> toJson() => {
        "requestList": List<dynamic>.from(requestList.map((x) => x.toJson())),
        "responseMessage": responseMessage,
    };
}

class RequestList {
    List<Image> images;
    dynamic video;
    dynamic voiceNote;
    String productUploadTime;
    dynamic wishListId;
    dynamic wishListItemSeqId;
    String categoryName;
    String variety;
    CustRequestDetail custRequestDetail;
    DateTime custRequestDate;
    DateTime closedDateTime;

    RequestList({
        this.images,
        this.video,
        this.voiceNote,
        this.productUploadTime,
        this.wishListId,
        this.wishListItemSeqId,
        this.categoryName,
        this.variety,
        this.custRequestDetail,
        this.custRequestDate,
        this.closedDateTime,
    });

    factory RequestList.fromJson(Map<String, dynamic> json) => RequestList(
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        video: json["video"],
        voiceNote: json["voiceNote"],
        productUploadTime: json["productUploadTime"],
        wishListId: json["wishListId"],
        wishListItemSeqId: json["wishListItemSeqId"],
        categoryName: json["categoryName"],
        variety: json["variety"],
        custRequestDetail: CustRequestDetail.fromJson(json["custRequestDetail"]),
        custRequestDate: DateTime.parse(json["custRequestDate"]),
        closedDateTime: DateTime.parse(json["closedDateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "video": video,
        "voiceNote": voiceNote,
        "productUploadTime": productUploadTime,
        "wishListId": wishListId,
        "wishListItemSeqId": wishListItemSeqId,
        "categoryName": categoryName,
        "variety": variety,
        "custRequestDetail": custRequestDetail.toJson(),
        "custRequestDate": custRequestDate.toIso8601String(),
        "closedDateTime": closedDateTime.toIso8601String(),
    };
}

class CustRequestDetail {
    dynamic reason;
    String fromPartyId;
    dynamic organicCertificateNumber;
    dynamic salesChannelEnumId;
    int maximumAmount;
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
    int quantity;
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

    factory CustRequestDetail.fromJson(Map<String, dynamic> json) => CustRequestDetail(
        reason: json["reason"],
        fromPartyId: json["fromPartyId"],
        organicCertificateNumber: json["organicCertificateNumber"],
        salesChannelEnumId: json["salesChannelEnumId"],
        maximumAmount: json["maximumAmount"] == null ? null : json["maximumAmount"],
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
        unitForFxiedPrice: json["unitForFxiedPrice"] == null ? null : json["unitForFxiedPrice"],
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
        "unitForFxiedPrice": unitForFxiedPrice == null ? null : unitForFxiedPrice,
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
    };
}

class Image {
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

    Image({
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

    factory Image.fromJson(Map<String, dynamic> json) => Image(
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
