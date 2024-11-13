// To parse this JSON data, do
//
//     final allEmployeeEnrollStatusModel = allEmployeeEnrollStatusModelFromJson(jsonString);

import 'dart:convert';

AllEmployeeEnrollStatusModel allEmployeeEnrollStatusModelFromJson(String str) => AllEmployeeEnrollStatusModel.fromJson(json.decode(str));

String allEmployeeEnrollStatusModelToJson(AllEmployeeEnrollStatusModel data) => json.encode(data.toJson());

class AllEmployeeEnrollStatusModel {
    List<String>? employeeIds;
    String? message;
    bool? status;

    AllEmployeeEnrollStatusModel({
        this.employeeIds,
        this.message,
        this.status,
    });

    factory AllEmployeeEnrollStatusModel.fromJson(Map<String, dynamic> json) => AllEmployeeEnrollStatusModel(
        employeeIds: json["employee_ids"] == null ? [] : List<String>.from(json["employee_ids"]!.map((x) => x)),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "employee_ids": employeeIds == null ? [] : List<dynamic>.from(employeeIds!.map((x) => x)),
        "message": message,
        "status": status,
    };
}
