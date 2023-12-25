// To parse this JSON data, do
//
// final villageModel = villageModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/LocationModel/block_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/city_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';

List<VillageModel> villageModelFromJson(String str) => List<VillageModel>.from(
    json.decode(str).map((x) => VillageModel.fromJson(x)));

String villageModelToJson(List<VillageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VillageModel {
  String id;
  String creationDate;
  String name;
  StateModel state;
  CityModel city;
  TehsilModel tehsil;
  BlockModel block;
  bool active;

  VillageModel({
    this.id,
    this.creationDate,
    this.name,
    this.state,
    this.city,
    this.tehsil,
    this.block,
    this.active,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) => VillageModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        state: StateModel.fromJson(json["state"]),
        city: CityModel.fromJson(json["city"]),
        tehsil: TehsilModel.fromJson(json["tehsil"]),
        block:
            json["block"] == null ? null : BlockModel.fromJson(json["block"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "state": state.toJson(),
        "city": city.toJson(),
        "tehsil": tehsil.toJson(),
        "block": block == null ? null : block.toJson(),
        "active": active,
      };
}
