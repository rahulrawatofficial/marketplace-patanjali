// To parse this JSON data, do
//
//     final updateProfileModel = updateProfileModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileModel updateProfileModelFromJson(String str) =>
    UpdateProfileModel.fromJson(json.decode(str));

String updateProfileModelToJson(UpdateProfileModel data) =>
    json.encode(data.toJson());

class UpdateProfileModel {
  String partyId;
  UpdateData updateData;

  UpdateProfileModel({
    this.partyId,
    this.updateData,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileModel(
        partyId: json["partyId"],
        updateData: UpdateData.fromJson(json["updateData"]),
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "updateData": updateData.toJson(),
      };
}

class UpdateData {
  // String name;
  String firstName;
  String lastName;
  String fatherName;
  String methodOfFarming;
  String userType;
  PostalAddress postalAddress;
  PhoneNumber phoneNumber;
  EmailAddress emailAddress;

  UpdateData({
    // this.name,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.methodOfFarming,
    this.userType,
    this.postalAddress,
    this.phoneNumber,
    this.emailAddress,
  });

  factory UpdateData.fromJson(Map<String, dynamic> json) => UpdateData(
        // name: json["name"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        fatherName: json["fatherName"],
        methodOfFarming: json["methodOfFarming"],
        userType: json["userType"],
        postalAddress: PostalAddress.fromJson(json["postalAddress"]),
        phoneNumber: PhoneNumber.fromJson(json["phoneNumber"]),
        emailAddress: EmailAddress.fromJson(json["emailAddress"]),
      );

  Map<String, dynamic> toJson() => {
        // "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "fatherName": fatherName,
        "methodOfFarming": methodOfFarming,
        "userType": userType,
        "postalAddress": postalAddress.toJson(),
        "phoneNumber": phoneNumber.toJson(),
        "emailAddress": emailAddress.toJson(),
      };
}

class EmailAddress {
  String emailAddress;
  String contactMechId;

  EmailAddress({
    this.emailAddress,
    this.contactMechId,
  });

  factory EmailAddress.fromJson(Map<String, dynamic> json) => EmailAddress(
        emailAddress: json["emailAddress"],
        contactMechId: json["contactMechId"],
      );

  Map<String, dynamic> toJson() => {
        "emailAddress": emailAddress,
        "contactMechId": contactMechId,
      };
}

class PhoneNumber {
  String contactNumber;
  String contactMechPurposeTypeId;
  String contactMechId;

  PhoneNumber({
    this.contactNumber,
    this.contactMechPurposeTypeId,
    this.contactMechId,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        contactNumber: json["contactNumber"],
        contactMechPurposeTypeId: json["contactMechPurposeTypeId"],
        contactMechId: json["contactMechId"],
      );

  Map<String, dynamic> toJson() => {
        "contactNumber": contactNumber,
        "contactMechPurposeTypeId": contactMechPurposeTypeId,
        "contactMechId": contactMechId,
      };
}

class PostalAddress {
  String countryGeoId;
  String contactMechPurposeTypeId;
  String address2;
  String city;
  String address1;
  String block;
  String postalCode;
  String stateProvinceGeoId;
  String contactMechId;

  PostalAddress({
    this.countryGeoId,
    this.contactMechPurposeTypeId,
    this.address2,
    this.city,
    this.address1,
    this.block,
    this.postalCode,
    this.stateProvinceGeoId,
    this.contactMechId,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
        countryGeoId: json["countryGeoId"],
        contactMechPurposeTypeId: json["contactMechPurposeTypeId"],
        address2: json["address2"],
        city: json["city"],
        address1: json["address1"],
        block: json["block"],
        postalCode: json["postalCode"],
        stateProvinceGeoId: json["stateProvinceGeoId"],
        contactMechId: json["contactMechId"],
      );

  Map<String, dynamic> toJson() => {
        "countryGeoId": countryGeoId,
        "contactMechPurposeTypeId": contactMechPurposeTypeId,
        "address2": address2,
        "city": city,
        "address1": address1,
        "block":block,
        "postalCode": postalCode,
        "stateProvinceGeoId": stateProvinceGeoId,
        "contactMechId": contactMechId,
      };
}
