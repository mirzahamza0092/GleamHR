// To parse this JSON data, do
//
//     final getWorkFromHomeModel = getWorkFromHomeModelFromJson(jsonString);

import 'dart:convert';

GetWorkFromHomeModel getWorkFromHomeModelFromJson(String str) => GetWorkFromHomeModel.fromJson(json.decode(str));

String getWorkFromHomeModelToJson(GetWorkFromHomeModel data) => json.encode(data.toJson());

class GetWorkFromHomeModel {
    List<Datum>? data;
    List<DateTime>? daysData;

    GetWorkFromHomeModel({
        this.data,
        this.daysData,
    });

    factory GetWorkFromHomeModel.fromJson(Map<String, dynamic> json) => GetWorkFromHomeModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        daysData: json["days_data"] == null ? [] : List<DateTime>.from(json["days_data"]!.map((x) => DateTime.parse(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "days_data": daysData == null ? [] : List<dynamic>.from(daysData!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
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
    };
}
