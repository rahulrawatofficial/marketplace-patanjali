// To parse this JSON data, do
//
//     final fertilizerModel = fertilizerModelFromJson(jsonString);

import 'dart:convert';

FertilizerModel fertilizerModelFromJson(String str) =>
    FertilizerModel.fromJson(json.decode(str));

String fertilizerModelToJson(FertilizerModel data) =>
    json.encode(data.toJson());

class FertilizerModel {
  String id;
  String creationDate;
  String name;
  String categoryType;
  String fertilizerType;
  double nRatio;
  double pRatio;
  double kRatio;
  int quantityGood;
  int quantityMedium;
  int quantityPoor;
  int irrigated;
  int semiIrrigated;
  int rainfed;
  String fertId;
  String unit;
  bool active;

  FertilizerModel({
    this.id,
    this.creationDate,
    this.name,
    this.categoryType,
    this.fertilizerType,
    this.nRatio,
    this.pRatio,
    this.kRatio,
    this.quantityGood,
    this.quantityMedium,
    this.quantityPoor,
    this.irrigated,
    this.semiIrrigated,
    this.rainfed,
    this.fertId,
    this.unit,
    this.active,
  });

  factory FertilizerModel.fromJson(Map<String, dynamic> json) =>
      FertilizerModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        categoryType: json["categoryType"],
        fertilizerType: json["fertilizerType"],
        nRatio: json["nRatio"],
        pRatio: json["pRatio"],
        kRatio: json["kRatio"],
        quantityGood: json["quantityGood"],
        quantityMedium: json["quantityMedium"],
        quantityPoor: json["quantityPoor"],
        irrigated: json["irrigated"],
        semiIrrigated: json["semiIrrigated"],
        rainfed: json["rainfed"],
        fertId: json["fertId"],
        unit: json["unit"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "categoryType": categoryType,
        "fertilizerType": fertilizerType,
        "nRatio": nRatio,
        "pRatio": pRatio,
        "kRatio": kRatio,
        "quantityGood": quantityGood,
        "quantityMedium": quantityMedium,
        "quantityPoor": quantityPoor,
        "irrigated": irrigated,
        "semiIrrigated": semiIrrigated,
        "rainfed": rainfed,
        "fertId": fertId,
        "unit": unit,
        "active": active,
      };
}
