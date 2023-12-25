// To parse this JSON data, do
//
//     final addBidModel = addBidModelFromJson(jsonString);

import 'dart:convert';

String addBidModelToJson(AddBidModel data) => json.encode(data.toJson());
String addBidModelFixedToJson(AddBidModelFixed data) =>
    json.encode(data.toJson());

class AddBidModel {
  ReqData reqData;

  AddBidModel({
    this.reqData,
  });

  Map<String, dynamic> toJson() => {
        "reqData": reqData.toJson(),
      };
}

class ReqData {
  String custRequestId;
  String quoteUnitPrice;
  String quantity;
  String partyId;
  String unit;
  String fixedProduct;
  double totalAmount;
  String custRequestItemSeqId;

  ReqData({
    this.custRequestId,
    this.quoteUnitPrice,
    this.quantity,
    this.partyId,
    this.unit,
    this.fixedProduct,
    this.totalAmount,
    this.custRequestItemSeqId,
  });

  Map<String, dynamic> toJson() => {
        "custRequestId": custRequestId,
        "quoteUnitPrice": quoteUnitPrice,
        "quantity": quantity,
        "partyId": partyId,
        "unit": unit,
        "fixedProduct": fixedProduct,
        "totalAmount": totalAmount,
        "custRequestItemSeqId": custRequestItemSeqId,
      };
}

class AddBidModelFixed {
  ReqDataFixed reqData;

  AddBidModelFixed({
    this.reqData,
  });

  Map<String, dynamic> toJson() => {
        "reqData": reqData.toJson(),
      };
}

class ReqDataFixed {
  String custRequestId;
  String partyId;
  String custRequestItemSeqId;
  // String fixedProduct;
  // String unit;

  ReqDataFixed({
    this.custRequestId,
    this.partyId,
    this.custRequestItemSeqId,
    // this.fixedProduct,
    // this.unit,
  });

  Map<String, dynamic> toJson() => {
        "custRequestId": custRequestId,
        "partyId": partyId,
        "custRequestItemSeqId": custRequestItemSeqId,
        // "fixedProduct":fixedProduct,
        // "unit":unit,
      };
}
