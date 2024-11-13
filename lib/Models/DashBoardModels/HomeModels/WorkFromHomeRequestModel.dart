// To parse this JSON data, do
//
//     final workFromHomeRequestModel = workFromHomeRequestModelFromJson(jsonString);

import 'dart:convert';

WorkFromHomeRequestModel workFromHomeRequestModelFromJson(String str) => WorkFromHomeRequestModel.fromJson(json.decode(str));

String workFromHomeRequestModelToJson(WorkFromHomeRequestModel data) => json.encode(data.toJson());

class WorkFromHomeRequestModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    WorkFromHomeRequestModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory WorkFromHomeRequestModel.fromJson(Map<String, dynamic> json) => WorkFromHomeRequestModel(
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
    DateTime? from;
    DateTime? to;
    String? reason;
    int? employeeId;
    String? status;
    String? comment;
    int? approverId;
    dynamic deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    Employee? employee;

    Datum({
        this.id,
        this.from,
        this.to,
        this.reason,
        this.employeeId,
        this.status,
        this.comment,
        this.approverId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.employee,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        reason: json["reason"],
        employeeId: json["employee_id"],
        status: json["status"],
        comment: json["comment"],
        approverId: json["approver_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "from": "${from!.year.toString().padLeft(4, '0')}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}",
        "to": "${to!.year.toString().padLeft(4, '0')}-${to!.month.toString().padLeft(2, '0')}-${to!.day.toString().padLeft(2, '0')}",
        "reason": reason,
        "employee_id": employeeId,
        "status": status,
        "comment": comment,
        "approver_id": approverId,
        "deleted_at": deletedAt,
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
