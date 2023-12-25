// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) =>
    json.encode(data.toJson());

class UserResponseModel {
  String responseMessage;
  String basicAuth;
  PartyDetail partyDetail;

  UserResponseModel({
    this.responseMessage,
    this.basicAuth,
    this.partyDetail,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        responseMessage: json["responseMessage"],
        basicAuth: json["basicAuth"],
        partyDetail: PartyDetail.fromJson(json["partyDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "basicAuth": basicAuth,
        "partyDetail": partyDetail.toJson(),
      };
}

class PartyDetail {
  String firstName;
  String lastName;
  String partyId;

  PartyDetail({
    this.firstName,
    this.lastName,
    this.partyId,
  });

  factory PartyDetail.fromJson(Map<String, dynamic> json) => PartyDetail(
        firstName: json["firstName"],
        lastName: json["lastName"],
        partyId: json["partyId"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "partyId": partyId,
      };
}
