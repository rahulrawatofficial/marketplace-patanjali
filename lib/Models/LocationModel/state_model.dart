// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'dart:convert';

List<StateModel> stateModelFromJson(String str) => List<StateModel>.from(json.decode(str).map((x) => StateModel.fromJson(x)));

String stateModelToJson(List<StateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateModel {
    String id;
    String creationDate;
    String name;
    String stateAbbreviation;
    bool active;

    StateModel({
        this.id,
        this.creationDate,
        this.name,
        this.stateAbbreviation,
        this.active,
    });

    factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        creationDate: json["creationDate"],
        name: json["name"],
        stateAbbreviation: json["stateAbbreviation"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "creationDate": creationDate,
        "name": name,
        "stateAbbreviation": stateAbbreviation,
        "active": active,
    };
}
