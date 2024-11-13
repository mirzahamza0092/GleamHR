// To parse this JSON data, do
//
//     final assetRequestModel = assetRequestModelFromJson(jsonString);

import 'dart:convert';

AssetRequestModel assetRequestModelFromJson(String str) => AssetRequestModel.fromJson(json.decode(str));

String assetRequestModelToJson(AssetRequestModel data) => json.encode(data.toJson());

class AssetRequestModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    AssetRequestModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory AssetRequestModel.fromJson(Map<String, dynamic> json) => AssetRequestModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "current_page": currentPage,
        "total_pages": totalPages,
    };
}

class Datum {
    int? id;
    int? assetTypeId;
    int? employeeId;
    String? message;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    Employee? employee;

    Datum({
        this.id,
        this.assetTypeId,
        this.employeeId,
        this.message,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.employee,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        assetTypeId: json["asset_type_id"],
        employeeId: json["employee_id"],
        message: json["message"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "asset_type_id": assetTypeId,
        "employee_id": employeeId,
        "message": message,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "employee": employee?.toJson(),
    };
}

class Employee {
    int? id;
    String? firstname;
    String? lastname;
    String? fullName;
    String? acronym;

    Employee({
        this.id,
        this.firstname,
        this.lastname,
        this.fullName,
        this.acronym,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        fullName: json["full_name"],
        acronym: json["acronym"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "full_name": fullName,
        "acronym": acronym,
    };
}
