// To parse this JSON data, do
//
//     final assetTypesModel = assetTypesModelFromJson(jsonString);

import 'dart:convert';

AssetTypesModel assetTypesModelFromJson(String str) => AssetTypesModel.fromJson(json.decode(str));

String assetTypesModelToJson(AssetTypesModel data) => json.encode(data.toJson());

class AssetTypesModel {
    List<Datum>? data;

    AssetTypesModel({
        this.data,
    });

    factory AssetTypesModel.fromJson(Map<String, dynamic> json) => AssetTypesModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;

    Datum({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
