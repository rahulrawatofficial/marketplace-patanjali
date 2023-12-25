// To parse this JSON data, do
//
//     final dkdProductsModel = dkdProductsModelFromJson(jsonString);

import 'dart:convert';

DkdProductsModel dkdProductsModelFromJson(String str) =>
    DkdProductsModel.fromJson(json.decode(str));

String dkdProductsModelToJson(DkdProductsModel data) =>
    json.encode(data.toJson());

class DkdProductsModel {
  String responseMessage;
  List<ListElement> list;

  DkdProductsModel({
    this.responseMessage,
    this.list,
  });

  factory DkdProductsModel.fromJson(Map<String, dynamic> json) =>
      DkdProductsModel(
        responseMessage: json["responseMessage"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseMessage": responseMessage,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  String id;
  String creationDate;
  String userId;
  String agentId;
  String cropId;
  Crop crop;
  String khasraNo;
  dynamic lastCultivateCropId;
  dynamic lastCultivateCropYield;
  String lastCultivateCropYieldUnit;
  int cropYield;
  String cropYieldUnit;
  String yearOfSowing;
  String userLandDetailId;
  int landSize;
  String landSizeType;
  int seedExpenses;
  int manPowerExpenses;
  int fertilizerExpenses;
  String type;
  dynamic fruitVariety;
  dynamic plantAge;
  dynamic timeUnit;
  dynamic columnSpace;
  dynamic rowSpace;
  dynamic totalNoOfPlants;
  String cropSeason;
  bool currentCrop;
  bool readyToSell;
  bool postCreated;
  bool active;

  ListElement({
    this.id,
    this.creationDate,
    this.userId,
    this.agentId,
    this.cropId,
    this.crop,
    this.khasraNo,
    this.lastCultivateCropId,
    this.lastCultivateCropYield,
    this.lastCultivateCropYieldUnit,
    this.cropYield,
    this.cropYieldUnit,
    this.yearOfSowing,
    this.userLandDetailId,
    this.landSize,
    this.landSizeType,
    this.seedExpenses,
    this.manPowerExpenses,
    this.fertilizerExpenses,
    this.type,
    this.fruitVariety,
    this.plantAge,
    this.timeUnit,
    this.columnSpace,
    this.rowSpace,
    this.totalNoOfPlants,
    this.cropSeason,
    this.currentCrop,
    this.readyToSell,
    this.postCreated,
    this.active,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        creationDate: json["creationDate"],
        userId: json["userId"],
        agentId: json["agentId"],
        cropId: json["cropId"],
        crop: Crop.fromJson(json["crop"]),
        khasraNo: json["khasraNo"],
        lastCultivateCropId: json["lastCultivateCropId"],
        lastCultivateCropYield: json["lastCultivateCropYield"],
        lastCultivateCropYieldUnit: json["lastCultivateCropYieldUnit"],
        cropYield: json["cropYield"],
        cropYieldUnit: json["cropYieldUnit"],
        yearOfSowing: json["yearOfSowing"],
        userLandDetailId: json["userLandDetailId"],
        landSize: json["landSize"],
        landSizeType: json["landSizeType"],
        seedExpenses: json["seedExpenses"],
        manPowerExpenses: json["manPowerExpenses"],
        fertilizerExpenses: json["fertilizerExpenses"],
        type: json["type"],
        fruitVariety: json["fruitVariety"],
        plantAge: json["plantAge"],
        timeUnit: json["timeUnit"],
        columnSpace: json["columnSpace"],
        rowSpace: json["rowSpace"],
        totalNoOfPlants: json["totalNoOfPlants"],
        cropSeason: json["cropSeason"],
        currentCrop: json["currentCrop"],
        readyToSell: json["readyToSell"],
        postCreated: json["postCreated"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "userId": userId,
        "agentId": agentId,
        "cropId": cropId,
        "crop": crop.toJson(),
        "khasraNo": khasraNo,
        "lastCultivateCropId": lastCultivateCropId,
        "lastCultivateCropYield": lastCultivateCropYield,
        "lastCultivateCropYieldUnit": lastCultivateCropYieldUnit,
        "cropYield": cropYield,
        "cropYieldUnit": cropYieldUnit,
        "yearOfSowing": yearOfSowing,
        "userLandDetailId": userLandDetailId,
        "landSize": landSize,
        "landSizeType": landSizeType,
        "seedExpenses": seedExpenses,
        "manPowerExpenses": manPowerExpenses,
        "fertilizerExpenses": fertilizerExpenses,
        "type": type,
        "fruitVariety": fruitVariety,
        "plantAge": plantAge,
        "timeUnit": timeUnit,
        "columnSpace": columnSpace,
        "rowSpace": rowSpace,
        "totalNoOfPlants": totalNoOfPlants,
        "cropSeason": cropSeason,
        "currentCrop": currentCrop,
        "readyToSell": readyToSell,
        "postCreated": postCreated,
        "active": active,
      };
}

class Crop {
  String id;
  String creationDate;
  String cropName;
  String cropType;
  String type;
  List<Fertilizer> fertilizers;
  List<String> cropSeasons;
  bool active;

  Crop({
    this.id,
    this.creationDate,
    this.cropName,
    this.cropType,
    this.type,
    this.fertilizers,
    this.cropSeasons,
    this.active,
  });

  factory Crop.fromJson(Map<String, dynamic> json) => Crop(
        id: json["id"],
        creationDate: json["creationDate"],
        cropName: json["cropName"],
        cropType: json["cropType"],
        type: json["type"],
        fertilizers: List<Fertilizer>.from(
            json["fertilizers"].map((x) => Fertilizer.fromJson(x))),
        cropSeasons: List<String>.from(json["cropSeasons"].map((x) => x)),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "cropName": cropName,
        "cropType": cropType,
        "type": type,
        "fertilizers": List<dynamic>.from(fertilizers.map((x) => x.toJson())),
        "cropSeasons": List<dynamic>.from(cropSeasons.map((x) => x)),
        "active": active,
      };
}

class Fertilizer {
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

  Fertilizer({
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

  factory Fertilizer.fromJson(Map<String, dynamic> json) => Fertilizer(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        categoryType: json["categoryType"],
        fertilizerType: json["fertilizerType"],
        nRatio: json["nRatio"].toDouble(),
        pRatio: json["pRatio"].toDouble(),
        kRatio: json["kRatio"].toDouble(),
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
