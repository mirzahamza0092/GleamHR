// To parse this JSON data, do
//
//     final checkModulesModel = checkModulesModelFromJson(jsonString);

import 'dart:convert';

CheckModulesModel checkModulesModelFromJson(String str) => CheckModulesModel.fromJson(json.decode(str));

String checkModulesModelToJson(CheckModulesModel data) => json.encode(data.toJson());

class CheckModulesModel {
    List<Datum>? data;

    CheckModulesModel({
        this.data,
    });

    factory CheckModulesModel.fromJson(Map<String, dynamic> json) => CheckModulesModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? moduleName;
    int? status;

    Datum({
        this.id,
        this.moduleName,
        this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        moduleName: json["module_name"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "module_name": moduleName,
        "status": status,
    };
}
