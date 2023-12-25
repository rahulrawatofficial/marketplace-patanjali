import 'package:marketplace_patanjali/Models/LocationModel/block_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/city_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/state_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/village_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';

class AddressModel {
  String address;
  CityModel city;
  String country;
  StateModel state;
  TehsilModel tehsil;
  BlockModel block;
  VillageModel villageModel;
  // String village;

  AddressModel({
    this.address,
    this.city,
    this.country,
    this.state,
    this.tehsil,
    this.block,
    this.villageModel,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => new AddressModel(
        address: json["address"],
        city: json["city"] != null ? CityModel.fromJson(json["city"]) : null,
        country: json["country"],
        state:
            json["state"] != null ? StateModel.fromJson(json["state"]) : null,
        tehsil: json["tehsil"] != null
            ? TehsilModel.fromJson(json["tehsil"])
            : null,
        block:
            json["block"] != null ? BlockModel.fromJson(json["block"]) : null,
        villageModel: json["villageModel"] != null
            ? VillageModel.fromJson(json["villageModel"])
            : null,
      );

  Map<String, dynamic> toJson() => block != null
      ? {
          "address": address,
          "city": city.toJson(),
          "country": country,
          "state": state.toJson(),
          "tehsil": tehsil != null ? tehsil.toJson() : null,
          "block": block != null ? block.toJson() : null,
          "villageModel": villageModel != null ? villageModel.toJson() : null,
        }
      : {
          "address": address,
          "city": city.toJson(),
          "country": country,
          "state": state.toJson(),
          "tehsil": tehsil != null ? tehsil.toJson() : null,
          "villageModel": villageModel != null ? villageModel.toJson() : null,
        };
}
