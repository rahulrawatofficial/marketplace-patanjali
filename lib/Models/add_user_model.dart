// To parse this JSON data, do
//
//     final addUserModel = addUserModelFromJson(jsonString);

import 'dart:convert';

AddUserModel addUserModelFromJson(String str) =>
    AddUserModel.fromJson(json.decode(str));

String addUserModelToJson(AddUserModel data) => json.encode(data.toJson());

class AddUserModel {
  String partyId;
  ReqData reqData;

  AddUserModel({
    this.partyId,
    this.reqData,
  });

  factory AddUserModel.fromJson(Map<String, dynamic> json) => AddUserModel(
        partyId: json["partyId"],
        reqData: ReqData.fromJson(json["reqData"]),
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "reqData": reqData.toJson(),
      };
}

class ReqData {
  String firstName;
  String lastName;
  String fatherName;
  String email;
  String methodOfFarming;
  String userType;
  PostalAddress postalAddress;

  ReqData({
    this.firstName,
    this.lastName,
    this.fatherName,
    this.email,
    this.methodOfFarming,
    this.userType,
    this.postalAddress,
  });

  factory ReqData.fromJson(Map<String, dynamic> json) => ReqData(
        firstName: json["firstName"],
        lastName: json["lastName"],
        fatherName: json["fatherName"],
        email: json["email"],
        methodOfFarming: json["methodOfFarming"],
        userType: json["userType"],
        postalAddress: PostalAddress.fromJson(json["postalAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "fatherName": fatherName,
        "email": email,
        "methodOfFarming": methodOfFarming,
        "userType": userType,
        "postalAddress": postalAddress.toJson(),
      };
}

class PostalAddress {
  String countryGeoId;
  String stateProvinceGeoId;
  String city;
  String address1;
  String block;
  String address2;

  PostalAddress({
    this.countryGeoId,
    this.stateProvinceGeoId,
    this.city,
    this.address1,
    this.block,
    this.address2,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
        countryGeoId: json["countryGeoId"],
        stateProvinceGeoId: json["stateProvinceGeoId"],
        city: json["city"],
        address1: json["address1"],
        block: json["block"],
        address2: json["address2"],
      );

  Map<String, dynamic> toJson() => {
        "countryGeoId": countryGeoId,
        "stateProvinceGeoId": stateProvinceGeoId,
        "city": city,
        "address1": address1,
        "block":block,
        "address2": address2,
      };
}
