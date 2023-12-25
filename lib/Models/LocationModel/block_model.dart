// To parse this JSON data, do
//
//     final blockModel = blockModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/LocationModel/city_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';

List<BlockModel> blockModelFromJson(String str) =>
    List<BlockModel>.from(json.decode(str).map((x) => BlockModel.fromJson(x)));

String blockModelToJson(List<BlockModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlockModel {
  String id;
  String creationDate;
  String name;
  TehsilModel tehsil;
  CityModel city;
  StateModel state;
  bool active;

  BlockModel({
    this.id,
    this.creationDate,
    this.name,
    this.tehsil,
    this.city,
    this.state,
    this.active,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        tehsil: TehsilModel.fromJson(json["tehsil"]),
        city: CityModel.fromJson(json["city"]),
        state: StateModel.fromJson(json["state"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "tehsil": tehsil.toJson(),
        "city": city.toJson(),
        "state": state.toJson(),
        "active": active,
      };
}
