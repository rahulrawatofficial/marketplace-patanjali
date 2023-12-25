// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';
import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';

List<CityModel> cityModelFromJson(String str) => new List<CityModel>.from(
    json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  String id;
  String creationDate;
  String name;
  StateModel state;
  bool active;

  CityModel({
    this.id,
    this.creationDate,
    this.name,
    this.state,
    this.active,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => new CityModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        state:
            json["state"] == null ? null : StateModel.fromJson(json["state"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "state": state == null ? null : state.toJson(),
        "active": active,
      };
}
