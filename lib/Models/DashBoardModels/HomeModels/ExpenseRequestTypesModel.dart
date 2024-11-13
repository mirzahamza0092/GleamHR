// To parse this JSON data, do
//
//     final expenseRequestModel = expenseRequestModelFromJson(jsonString);

import 'dart:convert';

ExpenseRequestModel expenseRequestModelFromJson(String str) =>
    ExpenseRequestModel.fromJson(json.decode(str));

String expenseRequestModelToJson(ExpenseRequestModel data) =>
    json.encode(data.toJson());

class ExpenseRequestModel {
  List<Datum>? data;

  ExpenseRequestModel({
    this.data,
  });

  factory ExpenseRequestModel.fromJson(Map<String, dynamic> json) =>
      ExpenseRequestModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
