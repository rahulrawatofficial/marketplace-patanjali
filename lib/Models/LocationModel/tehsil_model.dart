// To parse this JSON data, do
//
//     final tehsilModel = tehsilModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/LocationModel/city_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';

List<TehsilModel> tehsilModelFromJson(String str) => new List<TehsilModel>.from(
    json.decode(str).map((x) => TehsilModel.fromJson(x)));

String tehsilModelToJson(List<TehsilModel> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class TehsilModel {
  String id;
  String creationDate;
  String name;
  CityModel city;
  StateModel state;
  bool active;

  TehsilModel({
    this.id,
    this.creationDate,
    this.name,
    this.city,
    this.state,
    this.active,
  });

  factory TehsilModel.fromJson(Map<String, dynamic> json) => new TehsilModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        city: json["city"] == null ? null : CityModel.fromJson(json["city"]),
        state:
            json["state"] == null ? null : StateModel.fromJson(json["state"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "city": city == null ? null : city.toJson(),
        "state": state == null ? null : state.toJson(),
        "active": active,
      };
}
