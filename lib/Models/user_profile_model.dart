// To parse this JSON data, do
//
//     final UserProfileModel = UserProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/LocationModel/address_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  String aadhaarCardNumber;
  bool active;
  String address;
  String authToken;
  String category;
  String createdVia;
  DateTime creationDate;
  String cropStanding;
  DateTime dateOfBirth;
  String district;
  String fatherName;
  String firstName;
  String middleName;
  String gender;
  String id;
  List<String> landKhasraNos;
  String landSizeAcre;
  String language;
  String lastName;
  Otp otp;
  String password;
  String primaryPhone;
  String profileImage;
  String qualification;
  String religion;
  List<Role> roles;
  // String state;
  List<String> tehsils;
  // String village;
  List<String> villageList;
  // String stateId;
  String districtId;
  String relationship;
  TehsilModel tehsil;
  AddressModel addressModel;
  String userCode;
  String createdByUserId;
  String email;

  UserProfileModel({
    this.aadhaarCardNumber,
    this.active,
    this.address,
    this.authToken,
    this.category,
    this.createdVia,
    this.creationDate,
    this.cropStanding,
    this.dateOfBirth,
    this.district,
    this.fatherName,
    this.firstName,
    this.middleName,
    this.gender,
    this.id,
    this.landKhasraNos,
    this.landSizeAcre,
    this.language,
    this.lastName,
    this.otp,
    this.password,
    this.primaryPhone,
    this.profileImage,
    this.qualification,
    this.religion,
    this.roles,
    // this.state,
    this.tehsils,
    // this.village,
    this.villageList,
    // this.stateId,
    this.districtId,
    this.relationship,
    this.tehsil,
    this.addressModel,
    this.userCode,
    this.createdByUserId,
    this.email,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      new UserProfileModel(
        aadhaarCardNumber: json["aadhaarCardNumber"],
        active: json["active"],
        address: json["address"],
        addressModel: json["addressModel"] != null
            ? AddressModel.fromJson(json["addressModel"])
            : null,
        authToken: json["authToken"],
        category: json["category"],
        createdVia: json["createdVia"],
        creationDate: DateTime.parse(json["creationDate"]),
        cropStanding: json["cropStanding"],
        dateOfBirth: json["dateOfBirth"] != null
            ? DateTime.parse(json["dateOfBirth"])
            : null,
        district: json["district"],
        fatherName: json["fatherName"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        gender: json["gender"],
        id: json["id"],
        // landKhasraNos:
        //     new List<String>.from(json["landKhasraNos"].map((x) => x)),
        landSizeAcre: json["landSizeAcre"],
        language: json["language"],
        lastName: json["lastName"],
        otp: Otp.fromJson(json["otp"]),
        password: json["password"],
        primaryPhone: json["primaryPhone"],
        profileImage: json["profileImage"],
        qualification: json["qualification"],
        religion: json["religion"],
        roles: new List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        // state: json["state"],
        // // tehsils: new List<String>.from(json["tehsils"].map((x) => x)),
        // village: json["village"],
        // stateId: json["stateId"],
        districtId: json["districtId"],
        relationship: json["relationship"],
        // villageList: new List<String>.from(json["villageList"].map((x) => x)),
        tehsil: json["tehsil"] != null
            ? TehsilModel.fromJson(json["tehsil"])
            : null,
        userCode: json["userCode"],
        createdByUserId: json["createdByUserId"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "aadhaarCardNumber": aadhaarCardNumber,
        "active": active,
        "address": address,
        "addressModel": addressModel.toJson(),
        "authToken": authToken,
        "category": category,
        "createdVia": createdVia,
        "creationDate":
            creationDate != null ? creationDate.toIso8601String() : null,
        "cropStanding": cropStanding,
        "dateOfBirth":
            dateOfBirth != null ? dateOfBirth.toIso8601String() : null,
        "district": district,
        "fatherName": fatherName,
        "firstName": firstName,
        "middleName": middleName,
        "gender": gender,
        "id": id,
        "landKhasraNos": new List<dynamic>.from(landKhasraNos.map((x) => x)),
        "landSizeAcre": landSizeAcre,
        "language": language,
        "lastName": lastName,
        "otp": otp.toJson(),
        "password": password,
        "primaryPhone": primaryPhone,
        "profileImage": profileImage,
        "qualification": qualification,
        "religion": religion,
        "roles": new List<dynamic>.from(roles.map((x) => x.toJson())),
        // "state": state,
        "tehsils": new List<dynamic>.from(tehsils.map((x) => x)),
        // "village": village,
        "villageList": new List<dynamic>.from(villageList.map((x) => x)),
        // "stateId": stateId,
        "districtId": districtId,
        "relationship": relationship,
        "tehsil": tehsil != null ? tehsil.toJson() : null,
        "userCode": userCode,
        "createdByUserId": createdByUserId,
        "email": email,
      };
}

class Otp {
  bool active;
  DateTime creationDate;
  DateTime expiryTime;
  String id;
  String otp;

  Otp({
    this.active,
    this.creationDate,
    this.expiryTime,
    this.id,
    this.otp,
  });

  factory Otp.fromJson(Map<String, dynamic> json) => new Otp(
        active: json["active"],
        creationDate: DateTime.parse(json["creationDate"]),
        expiryTime: DateTime.parse(json["expiryTime"]),
        id: json["id"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "creationDate":
            creationDate != null ? creationDate.toIso8601String() : null,
        "expiryTime": expiryTime != null ? expiryTime.toIso8601String() : null,
        "id": id,
        "otp": otp,
      };
}

class Role {
  bool active;
  DateTime creationDate;
  String description;
  String id;
  String roleName;

  Role({
    this.active,
    this.creationDate,
    this.description,
    this.id,
    this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => new Role(
        active: json["active"],
        creationDate: json["creationDate"] != null
            ? DateTime.parse(json["creationDate"])
            : null,
        description: json["description"],
        id: json["id"],
        roleName: json["roleName"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "creationDate":
            creationDate != null ? creationDate.toIso8601String() : null,
        "description": description,
        "id": id,
        "roleName": roleName,
      };
}
