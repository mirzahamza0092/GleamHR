// To parse this JSON data, do
//
//     final allTimeOffRequestsModel = allTimeOffRequestsModelFromJson(jsonString);

import 'dart:convert';

AllTimeOffRequestsModel allTimeOffRequestsModelFromJson(String str) => AllTimeOffRequestsModel.fromJson(json.decode(str));

String allTimeOffRequestsModelToJson(AllTimeOffRequestsModel data) => json.encode(data.toJson());

class AllTimeOffRequestsModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    AllTimeOffRequestsModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory AllTimeOffRequestsModel.fromJson(Map<String, dynamic> json) => AllTimeOffRequestsModel(
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
    int? assignTimeOffPolicyId;
    DateTime? to;
    DateTime? from;
    String? note;
    String? status;
    int? employeeId;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    dynamic docFile;
    List<RequestTimeOffDetail>? requestTimeOffDetail;
    Employee? employee;

    Datum({
        this.id,
        this.assignTimeOffPolicyId,
        this.to,
        this.from,
        this.note,
        this.status,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.docFile,
        this.requestTimeOffDetail,
        this.employee,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        assignTimeOffPolicyId: json["assign_time_off_policy_id"],
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        note: json["note"],
        status: json["status"],
        employeeId: json["employee_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        docFile: json["doc_file"],
        requestTimeOffDetail: json["request_time_off_detail"] == null ? [] : List<RequestTimeOffDetail>.from(json["request_time_off_detail"]!.map((x) => RequestTimeOffDetail.fromJson(x))),
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "assign_time_off_policy_id": assignTimeOffPolicyId,
        "to": "${to!.year.toString().padLeft(4, '0')}-${to!.month.toString().padLeft(2, '0')}-${to!.day.toString().padLeft(2, '0')}",
        "from": "${from!.year.toString().padLeft(4, '0')}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}",
        "note": note,
        "status": status,
        "employee_id": employeeId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "doc_file": docFile,
        "request_time_off_detail": requestTimeOffDetail == null ? [] : List<dynamic>.from(requestTimeOffDetail!.map((x) => x.toJson())),
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

class RequestTimeOffDetail {
    int? id;
    int? requestTimeOffId;
    DateTime? date;
    int? hours;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;

    RequestTimeOffDetail({
        this.id,
        this.requestTimeOffId,
        this.date,
        this.hours,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory RequestTimeOffDetail.fromJson(Map<String, dynamic> json) => RequestTimeOffDetail(
        id: json["id"],
        requestTimeOffId: json["request_time_off_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        hours: json["hours"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "request_time_off_id": requestTimeOffId,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "hours": hours,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
