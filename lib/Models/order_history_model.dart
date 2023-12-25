// // To parse this JSON data, do
// //
// //     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

// import 'dart:convert';

// OrderHistoryModel orderHistoryModelFromJson(String str) =>
//     OrderHistoryModel.fromJson(json.decode(str));

// String orderHistoryModelToJson(OrderHistoryModel data) =>
//     json.encode(data.toJson());

// class OrderHistoryModel {
//   String responseMessage;
//   List<OrderList> orderList;

//   OrderHistoryModel({
//     this.responseMessage,
//     this.orderList,
//   });

//   factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
//       OrderHistoryModel(
//         responseMessage: json["responseMessage"],
//         orderList: List<OrderList>.from(
//             json["orderList"].map((x) => OrderList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "responseMessage": responseMessage,
//         "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
//       };
// }

// class OrderList {
//   List<ImageD> images;
//   dynamic video;
//   dynamic voiceNote;
//   String sellerName;
//   String sellerPhoneNumber;
//   LocationDetail locationDetail;
//   String categoryName;
//   String orderId;
//   String paymentStatusId;
//   String variety;
//   QuoteResult quoteResult;

//   OrderList({
//     this.images,
//     this.video,
//     this.voiceNote,
//     this.sellerName,
//     this.sellerPhoneNumber,
//     this.locationDetail,
//     this.categoryName,
//     this.orderId,
//     this.paymentStatusId,
//     this.variety,
//     this.quoteResult,
//   });

//   factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
//         images:
//             List<ImageD>.from(json["images"].map((x) => ImageD.fromJson(x))),
//         video: json["video"],
//         voiceNote: json["voiceNote"],
//         sellerName: json["sellerName"],
//         sellerPhoneNumber: json["sellerPhoneNumber"],
//         locationDetail: json["locationDetail"] != null
//             ? LocationDetail.fromJson(json["locationDetail"])
//             : null,
//         categoryName: json["categoryName"],
//         orderId: json["orderId"],
//         paymentStatusId: json["paymentStatusId"],
//         variety: json["variety"],
//         quoteResult: QuoteResult.fromJson(json["quoteResult"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "images": List<dynamic>.from(images.map((x) => x.toJson())),
//         "video": video,
//         "voiceNote": voiceNote,
//         "sellerName": sellerName,
//         "sellerPhoneNumber": sellerPhoneNumber,
//         "locationDetail": locationDetail.toJson(),
//         "categoryName": categoryName,
//         "orderId": orderId,
//         "paymentStatusId": paymentStatusId,
//         "variety": variety,
//         "quoteResult": quoteResult.toJson(),
//       };
// }

// class ImageD {
//   dynamic voiceUrl;
//   int lastUpdatedStamp;
//   dynamic videoUrl;
//   String productId;
//   int createdTxStamp;
//   String imageUrl;
//   int createdStamp;
//   String custRequestId;
//   String mimeTypeId;
//   int lastUpdatedTxStamp;
//   String partyId;
//   String imageSeqId;

//   ImageD({
//     this.voiceUrl,
//     this.lastUpdatedStamp,
//     this.videoUrl,
//     this.productId,
//     this.createdTxStamp,
//     this.imageUrl,
//     this.createdStamp,
//     this.custRequestId,
//     this.mimeTypeId,
//     this.lastUpdatedTxStamp,
//     this.partyId,
//     this.imageSeqId,
//   });

//   factory ImageD.fromJson(Map<String, dynamic> json) => ImageD(
//         voiceUrl: json["voiceUrl"],
//         lastUpdatedStamp: json["lastUpdatedStamp"],
//         videoUrl: json["videoUrl"],
//         productId: json["productId"],
//         createdTxStamp: json["createdTxStamp"],
//         imageUrl: json["imageUrl"],
//         createdStamp: json["createdStamp"],
//         custRequestId: json["custRequestId"],
//         mimeTypeId: json["mimeTypeId"],
//         lastUpdatedTxStamp: json["lastUpdatedTxStamp"],
//         partyId: json["partyId"],
//         imageSeqId: json["imageSeqId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "voiceUrl": voiceUrl,
//         "lastUpdatedStamp": lastUpdatedStamp,
//         "videoUrl": videoUrl,
//         "productId": productId,
//         "createdTxStamp": createdTxStamp,
//         "imageUrl": imageUrl,
//         "createdStamp": createdStamp,
//         "custRequestId": custRequestId,
//         "mimeTypeId": mimeTypeId,
//         "lastUpdatedTxStamp": lastUpdatedTxStamp,
//         "partyId": partyId,
//         "imageSeqId": imageSeqId,
//       };
// }

// class LocationDetail {
//   dynamic elevation;
//   int lastUpdatedStamp;
//   String country;
//   dynamic geoPointTypeEnumId;
//   int createdTxStamp;
//   String latitude;
//   int createdStamp;
//   dynamic description;
//   int lastUpdatedTxStamp;
//   String tehsil;
//   String dataSourceId;
//   dynamic elevationUomId;
//   String district;
//   String custRequestId;
//   dynamic information;
//   String block;
//   String state;
//   String geoPointId;
//   dynamic village;
//   String longitude;

//   LocationDetail({
//     this.elevation,
//     this.lastUpdatedStamp,
//     this.country,
//     this.geoPointTypeEnumId,
//     this.createdTxStamp,
//     this.latitude,
//     this.createdStamp,
//     this.description,
//     this.lastUpdatedTxStamp,
//     this.tehsil,
//     this.dataSourceId,
//     this.elevationUomId,
//     this.district,
//     this.custRequestId,
//     this.information,
//     this.block,
//     this.state,
//     this.geoPointId,
//     this.village,
//     this.longitude,
//   });

//   factory LocationDetail.fromJson(Map<String, dynamic> json) => LocationDetail(
//         elevation: json["elevation"],
//         lastUpdatedStamp: json["lastUpdatedStamp"],
//         country: json["country"],
//         geoPointTypeEnumId: json["geoPointTypeEnumId"],
//         createdTxStamp: json["createdTxStamp"],
//         latitude: json["latitude"],
//         createdStamp: json["createdStamp"],
//         description: json["description"],
//         lastUpdatedTxStamp: json["lastUpdatedTxStamp"],
//         tehsil: json["tehsil"] == null ? null : json["tehsil"],
//         dataSourceId: json["dataSourceId"],
//         elevationUomId: json["elevationUomId"],
//         district: json["district"],
//         custRequestId: json["custRequestId"],
//         information: json["information"],
//         block: json["block"] == null ? null : json["block"],
//         state: json["state"],
//         geoPointId: json["geoPointId"],
//         village: json["village"],
//         longitude: json["longitude"],
//       );

//   Map<String, dynamic> toJson() => {
//         "elevation": elevation,
//         "lastUpdatedStamp": lastUpdatedStamp,
//         "country": country,
//         "geoPointTypeEnumId": geoPointTypeEnumId,
//         "createdTxStamp": createdTxStamp,
//         "latitude": latitude,
//         "createdStamp": createdStamp,
//         "description": description,
//         "lastUpdatedTxStamp": lastUpdatedTxStamp,
//         "tehsil": tehsil == null ? null : tehsil,
//         "dataSourceId": dataSourceId,
//         "elevationUomId": elevationUomId,
//         "district": district,
//         "custRequestId": custRequestId,
//         "information": information,
//         "block": block == null ? null : block,
//         "state": state,
//         "geoPointId": geoPointId,
//         "village": village,
//         "longitude": longitude,
//       };
// }

// class QuoteResult {
//   double quantity;
//   dynamic comments;
//   dynamic salesChannelEnumId;
//   String productId;
//   dynamic deliverableTypeId;
//   String quoteItemSeqId;
//   double quoteUnitPrice;
//   String description;
//   dynamic estimatedDeliveryDate;
//   String quoteId;
//   dynamic validThruDate;
//   double totalAmount;
//   String unit;
//   String quoteTypeId;
//   dynamic currencyUomId;
//   String quotePartyId;
//   String statusId;
//   String custRequestId;
//   dynamic validFromDate;
//   String productStoreId;
//   String partyId;
//   dynamic issueDate;
//   dynamic selectedAmount;
//   String quoteName;

//   QuoteResult({
//     this.quantity,
//     this.comments,
//     this.salesChannelEnumId,
//     this.productId,
//     this.deliverableTypeId,
//     this.quoteItemSeqId,
//     this.quoteUnitPrice,
//     this.description,
//     this.estimatedDeliveryDate,
//     this.quoteId,
//     this.validThruDate,
//     this.totalAmount,
//     this.unit,
//     this.quoteTypeId,
//     this.currencyUomId,
//     this.quotePartyId,
//     this.statusId,
//     this.custRequestId,
//     this.validFromDate,
//     this.productStoreId,
//     this.partyId,
//     this.issueDate,
//     this.selectedAmount,
//     this.quoteName,
//   });

//   factory QuoteResult.fromJson(Map<String, dynamic> json) => QuoteResult(
//         quantity: json["quantity"],
//         comments: json["comments"],
//         salesChannelEnumId: json["salesChannelEnumId"],
//         productId: json["productId"],
//         deliverableTypeId: json["deliverableTypeId"],
//         quoteItemSeqId: json["quoteItemSeqId"],
//         quoteUnitPrice: json["quoteUnitPrice"],
//         description: json["description"] == null ? null : json["description"],
//         estimatedDeliveryDate: json["estimatedDeliveryDate"],
//         quoteId: json["quoteId"],
//         validThruDate: json["validThruDate"],
//         totalAmount: json["totalAmount"],
//         unit: json["unit"],
//         quoteTypeId: json["quoteTypeId"],
//         currencyUomId: json["currencyUomId"],
//         quotePartyId: json["quotePartyId"],
//         statusId: json["statusId"],
//         custRequestId: json["custRequestId"],
//         validFromDate: json["validFromDate"],
//         productStoreId: json["productStoreId"],
//         partyId: json["partyId"],
//         issueDate: json["issueDate"],
//         selectedAmount: json["selectedAmount"],
//         quoteName: json["quoteName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "quantity": quantity,
//         "comments": comments,
//         "salesChannelEnumId": salesChannelEnumId,
//         "productId": productId,
//         "deliverableTypeId": deliverableTypeId,
//         "quoteItemSeqId": quoteItemSeqId,
//         "quoteUnitPrice": quoteUnitPrice,
//         "description": description == null ? null : description,
//         "estimatedDeliveryDate": estimatedDeliveryDate,
//         "quoteId": quoteId,
//         "validThruDate": validThruDate,
//         "totalAmount": totalAmount,
//         "unit": unit,
//         "quoteTypeId": quoteTypeId,
//         "currencyUomId": currencyUomId,
//         "quotePartyId": quotePartyId,
//         "statusId": statusId,
//         "custRequestId": custRequestId,
//         "validFromDate": validFromDate,
//         "productStoreId": productStoreId,
//         "partyId": partyId,
//         "issueDate": issueDate,
//         "selectedAmount": selectedAmount,
//         "quoteName": quoteName,
//       };
// }

// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    this.responseMessage,
    this.orderList,
  });

  String responseMessage;
  List<OrderList> orderList;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        responseMessage: json["responseMessage"],
        orderList: List<OrderList>.from(
            json["orderList"].map((x) => OrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
      };
}

class OrderList {
  OrderList({
    this.images,
    this.video,
    this.voiceNote,
    this.quoteResult,
    this.sellerName,
    this.sellerPhoneNumber,
    this.locationDetail,
    this.categoryName,
    this.orderId,
    this.paymentStatusId,
    this.amount,
    this.paymentMethod,
    this.variety,
  });

  List<dynamic> images;
  dynamic video;
  dynamic voiceNote;
  QuoteResult quoteResult;
  String sellerName;
  String sellerPhoneNumber;
  LocationDetail locationDetail;
  String categoryName;
  String orderId;
  String paymentStatusId;
  double amount;
  String paymentMethod;
  String variety;

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        images:
            List<ImageD>.from(json["images"].map((x) => ImageD.fromJson(x))),
        video: json["video"],
        voiceNote: json["voiceNote"],
        quoteResult: QuoteResult.fromJson(json["quoteResult"]),
        sellerName: json["sellerName"],
        sellerPhoneNumber: json["sellerPhoneNumber"],
        locationDetail: LocationDetail.fromJson(json["locationDetail"]),
        categoryName: json["categoryName"],
        orderId: json["orderId"],
        paymentStatusId: json["paymentStatusId"],
        amount: json["amount"],
        paymentMethod: json["paymentMethod"],
        variety: json["variety"],
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "video": video,
        "voiceNote": voiceNote,
        "quoteResult": quoteResult.toJson(),
        "sellerName": sellerName,
        "sellerPhoneNumber": sellerPhoneNumber,
        "locationDetail": locationDetail.toJson(),
        "categoryName": categoryName,
        "orderId": orderId,
        "paymentStatusId": paymentStatusId,
        "amount": amount,
        "paymentMethod": paymentMethod,
        "variety": variety,
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

class LocationDetail {
  LocationDetail({
    this.elevation,
    this.lastUpdatedStamp,
    this.country,
    this.geoPointTypeEnumId,
    this.createdTxStamp,
    this.latitude,
    this.createdStamp,
    this.description,
    this.lastUpdatedTxStamp,
    this.tehsil,
    this.inventoryItemId,
    this.dataSourceId,
    this.elevationUomId,
    this.district,
    this.custRequestId,
    this.information,
    this.block,
    this.state,
    this.geoPointId,
    this.village,
    this.longitude,
  });

  dynamic elevation;
  int lastUpdatedStamp;
  String country;
  dynamic geoPointTypeEnumId;
  int createdTxStamp;
  String latitude;
  int createdStamp;
  dynamic description;
  int lastUpdatedTxStamp;
  String tehsil;
  String inventoryItemId;
  String dataSourceId;
  dynamic elevationUomId;
  String district;
  dynamic custRequestId;
  dynamic information;
  String block;
  String state;
  String geoPointId;
  String village;
  String longitude;

  factory LocationDetail.fromJson(Map<String, dynamic> json) => LocationDetail(
        elevation: json["elevation"],
        lastUpdatedStamp: json["lastUpdatedStamp"],
        country: json["country"],
        geoPointTypeEnumId: json["geoPointTypeEnumId"],
        createdTxStamp: json["createdTxStamp"],
        latitude: json["latitude"],
        createdStamp: json["createdStamp"],
        description: json["description"],
        lastUpdatedTxStamp: json["lastUpdatedTxStamp"],
        tehsil: json["tehsil"],
        inventoryItemId: json["inventoryItemId"],
        dataSourceId: json["dataSourceId"],
        elevationUomId: json["elevationUomId"],
        district: json["district"],
        custRequestId: json["custRequestId"],
        information: json["information"],
        block: json["block"] == null ? null : json["block"],
        state: json["state"],
        geoPointId: json["geoPointId"],
        village: json["village"] == null ? null : json["village"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "elevation": elevation,
        "lastUpdatedStamp": lastUpdatedStamp,
        "country": country,
        "geoPointTypeEnumId": geoPointTypeEnumId,
        "createdTxStamp": createdTxStamp,
        "latitude": latitude,
        "createdStamp": createdStamp,
        "description": description,
        "lastUpdatedTxStamp": lastUpdatedTxStamp,
        "tehsil": tehsil,
        "inventoryItemId": inventoryItemId,
        "dataSourceId": dataSourceId,
        "elevationUomId": elevationUomId,
        "district": district,
        "custRequestId": custRequestId,
        "information": information,
        "block": block == null ? null : block,
        "state": state,
        "geoPointId": geoPointId,
        "village": village == null ? null : village,
        "longitude": longitude,
      };
}

class QuoteResult {
  QuoteResult({
    this.organicCertificateNumber,
    this.maximumAmount,
    this.softIdentifier,
    this.description,
    this.binNumber,
    this.oldAvailableToPromise,
    this.adType,
    this.quantityOnHandTotal,
    this.datetimeManufactured,
    this.expireDate,
    this.oldQuantityOnHand,
    this.partyId,
    this.containerId,
    this.availableToPromiseTotal,
    this.closedDateTime,
    this.inventoryItemTypeId,
    this.locationSeqId,
    this.unitForFxiedPrice,
    this.quantity,
    this.facilityId,
    this.comments,
    this.serialNumber,
    this.productId,
    this.fixedProduct,
    this.lotId,
    this.uomId,
    this.accountingQuantityTotal,
    this.methodOfFarming,
    this.inventoryItemId,
    this.ownerPartyId,
    this.activationValidThru,
    this.unit,
    this.createdDate,
    this.activationNumber,
    this.currencyUomId,
    this.statusId,
    this.unitCost,
    this.fixedAssetId,
    this.datetimeReceived,
    this.categoryId,
  });

  dynamic organicCertificateNumber;
  double maximumAmount;
  dynamic softIdentifier;
  String description;
  dynamic binNumber;
  dynamic oldAvailableToPromise;
  String adType;
  double quantityOnHandTotal;
  dynamic datetimeManufactured;
  dynamic expireDate;
  dynamic oldQuantityOnHand;
  String partyId;
  dynamic containerId;
  double availableToPromiseTotal;
  int closedDateTime;
  String inventoryItemTypeId;
  dynamic locationSeqId;
  String unitForFxiedPrice;
  double quantity;
  String facilityId;
  dynamic comments;
  dynamic serialNumber;
  String productId;
  String fixedProduct;
  dynamic lotId;
  dynamic uomId;
  double accountingQuantityTotal;
  String methodOfFarming;
  String inventoryItemId;
  String ownerPartyId;
  dynamic activationValidThru;
  String unit;
  int createdDate;
  dynamic activationNumber;
  String currencyUomId;
  String statusId;
  double unitCost;
  dynamic fixedAssetId;
  dynamic datetimeReceived;
  dynamic categoryId;

  factory QuoteResult.fromJson(Map<String, dynamic> json) => QuoteResult(
        organicCertificateNumber: json["organicCertificateNumber"],
        maximumAmount: json["maximumAmount"],
        softIdentifier: json["softIdentifier"],
        description: json["description"],
        binNumber: json["binNumber"],
        oldAvailableToPromise: json["oldAvailableToPromise"],
        adType: json["adType"],
        quantityOnHandTotal: json["quantityOnHandTotal"],
        datetimeManufactured: json["datetimeManufactured"],
        expireDate: json["expireDate"],
        oldQuantityOnHand: json["oldQuantityOnHand"],
        partyId: json["partyId"],
        containerId: json["containerId"],
        availableToPromiseTotal: json["availableToPromiseTotal"],
        closedDateTime: json["closedDateTime"],
        inventoryItemTypeId: json["inventoryItemTypeId"],
        locationSeqId: json["locationSeqId"],
        unitForFxiedPrice: json["unitForFxiedPrice"],
        quantity: json["quantity"],
        facilityId: json["facilityId"],
        comments: json["comments"],
        serialNumber: json["serialNumber"],
        productId: json["productId"],
        fixedProduct: json["fixedProduct"],
        lotId: json["lotId"],
        uomId: json["uomId"],
        accountingQuantityTotal: json["accountingQuantityTotal"],
        methodOfFarming: json["methodOfFarming"],
        inventoryItemId: json["inventoryItemId"],
        ownerPartyId: json["ownerPartyId"],
        activationValidThru: json["activationValidThru"],
        unit: json["unit"],
        createdDate: json["createdDate"],
        activationNumber: json["activationNumber"],
        currencyUomId: json["currencyUomId"],
        statusId: json["statusId"],
        unitCost: json["unitCost"],
        fixedAssetId: json["fixedAssetId"],
        datetimeReceived: json["datetimeReceived"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "organicCertificateNumber": organicCertificateNumber,
        "maximumAmount": maximumAmount,
        "softIdentifier": softIdentifier,
        "description": description,
        "binNumber": binNumber,
        "oldAvailableToPromise": oldAvailableToPromise,
        "adType": adType,
        "quantityOnHandTotal": quantityOnHandTotal,
        "datetimeManufactured": datetimeManufactured,
        "expireDate": expireDate,
        "oldQuantityOnHand": oldQuantityOnHand,
        "partyId": partyId,
        "containerId": containerId,
        "availableToPromiseTotal": availableToPromiseTotal,
        "closedDateTime": closedDateTime,
        "inventoryItemTypeId": inventoryItemTypeId,
        "locationSeqId": locationSeqId,
        "unitForFxiedPrice": unitForFxiedPrice,
        "quantity": quantity,
        "facilityId": facilityId,
        "comments": comments,
        "serialNumber": serialNumber,
        "productId": productId,
        "fixedProduct": fixedProduct,
        "lotId": lotId,
        "uomId": uomId,
        "accountingQuantityTotal": accountingQuantityTotal,
        "methodOfFarming": methodOfFarming,
        "inventoryItemId": inventoryItemId,
        "ownerPartyId": ownerPartyId,
        "activationValidThru": activationValidThru,
        "unit": unit,
        "createdDate": createdDate,
        "activationNumber": activationNumber,
        "currencyUomId": currencyUomId,
        "statusId": statusId,
        "unitCost": unitCost,
        "fixedAssetId": fixedAssetId,
        "datetimeReceived": datetimeReceived,
        "categoryId": categoryId,
      };
}
