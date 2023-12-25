// To parse this JSON data, do
//
//     final cartItemModel = cartItemModelFromJson(jsonString);

import 'dart:convert';

CartItemModel cartItemModelFromJson(String str) =>
    CartItemModel.fromJson(json.decode(str));

String cartItemModelToJson(CartItemModel data) => json.encode(data.toJson());

class CartItemModel {
  CartItemModel({
    this.responseMessage,
    this.cartItemList,
    this.cartGrandTotal,
  });

  String responseMessage;
  List<CartItemList> cartItemList;
  String cartGrandTotal;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        responseMessage: json["responseMessage"],
        cartItemList: List<CartItemList>.from(
            json["cartItemList"].map((x) => CartItemList.fromJson(x))),
        cartGrandTotal: json["cartGrandTotal"],
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "cartItemList": List<dynamic>.from(cartItemList.map((x) => x.toJson())),
        "cartGrandTotal": cartGrandTotal,
      };
}

class CartItemList {
  CartItemList({
    this.productUploadTime,
    this.sellerName,
    this.cartItemId,
    this.cartItemSeqId,
    this.categoryName,
    this.variety,
    this.custRequestDetail,
    this.closedDateTime,
  });

  String productUploadTime;
  String sellerName;
  String cartItemId;
  String cartItemSeqId;
  String categoryName;
  String variety;
  CustRequestDetail custRequestDetail;
  DateTime closedDateTime;

  factory CartItemList.fromJson(Map<String, dynamic> json) => CartItemList(
        productUploadTime: json["productUploadTime"],
        sellerName: json["sellerName"],
        cartItemId: json["cartItemId"],
        cartItemSeqId: json["cartItemSeqId"],
        categoryName: json["categoryName"],
        variety: json["variety"],
        custRequestDetail:
            CustRequestDetail.fromJson(json["custRequestDetail"]),
        closedDateTime: DateTime.parse(json["closedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "productUploadTime": productUploadTime,
        "sellerName": sellerName,
        "cartItemId": cartItemId,
        "cartItemSeqId": cartItemSeqId,
        "categoryName": categoryName,
        "variety": variety,
        "custRequestDetail": custRequestDetail.toJson(),
        "closedDateTime": closedDateTime.toIso8601String(),
      };
}

class CustRequestDetail {
  CustRequestDetail({
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

  factory CustRequestDetail.fromJson(Map<String, dynamic> json) =>
      CustRequestDetail(
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
