// To parse this JSON data, do
//
//     final cropModel = cropModelFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_patanjali/Models/CropModel/fertilizer_model.dart';

CropModel cropModelFromJson(String str) => CropModel.fromJson(json.decode(str));

String cropModelToJson(CropModel data) => json.encode(data.toJson());

class CropModel {
    String id;
    String creationDate;
    String cropName;
    String cropType;
    List<FertilizerModel> fertilizers;
    List<String> cropSeasons;
    bool active;

    CropModel({
        this.id,
        this.creationDate,
        this.cropName,
        this.cropType,
        this.fertilizers,
        this.cropSeasons,
        this.active,
    });

    factory CropModel.fromJson(Map<String, dynamic> json) => CropModel(
        id: json["id"],
        creationDate: json["creationDate"],
        cropName: json["cropName"],
        cropType: json["cropType"],
        fertilizers: List<FertilizerModel>.from(json["fertilizers"].map((x) => FertilizerModel.fromJson(x))),
        cropSeasons: List<String>.from(json["cropSeasons"].map((x) => x)),
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "cropName": cropName,
        "cropType": cropType,
        "fertilizers": List<dynamic>.from(fertilizers.map((x) => x.toJson())),
        "cropSeasons": List<dynamic>.from(cropSeasons.map((x) => x)),
        "active": active,
    };
}



