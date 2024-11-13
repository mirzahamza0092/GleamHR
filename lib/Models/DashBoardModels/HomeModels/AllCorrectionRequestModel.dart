// To parse this JSON data, do
//
//     final allCorrectionRequestsModel = allCorrectionRequestsModelFromJson(jsonString);

import 'dart:convert';

AllCorrectionRequestsModel allCorrectionRequestsModelFromJson(String str) => AllCorrectionRequestsModel.fromJson(json.decode(str));

String allCorrectionRequestsModelToJson(AllCorrectionRequestsModel data) => json.encode(data.toJson());

class AllCorrectionRequestsModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    AllCorrectionRequestsModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory AllCorrectionRequestsModel.fromJson(Map<String, dynamic> json) => AllCorrectionRequestsModel(
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
    String? date;
    String? timeInDate;
    String? timeIn;
    String? timeOutDate;
    String? timeOut;
    String? timeInStatus;
    String? attendanceStatus;
    String? reasonForLeaving;
    String? takenABreak;
    String? status;
    String? totalEntries;
    dynamic attendanceId;
    dynamic removeAttendanceId;
    int? employeeId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Employee? employee;

    Datum({
        this.id,
        this.date,
        this.timeInDate,
        this.timeIn,
        this.timeOutDate,
        this.timeOut,
        this.timeInStatus,
        this.attendanceStatus,
        this.reasonForLeaving,
        this.takenABreak,
        this.status,
        this.totalEntries,
        this.attendanceId,
        this.removeAttendanceId,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.employee,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        date: json["date"],
        timeInDate: json["time_in_date"],
        timeIn: json["time_in"],
        timeOutDate: json["time_out_date"],
        timeOut: json["time_out"],
        timeInStatus: json["time_in_status"],
        attendanceStatus: json["attendance_status"],
        reasonForLeaving: json["reason_for_leaving"],
        takenABreak: json["taken_a_break"],
        status: json["status"],
        totalEntries: json["total_entries"],
        attendanceId: json["attendance_id"],
        removeAttendanceId: json["remove_attendance_id"],
        employeeId: json["employee_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "time_in_date": timeInDate,
        "time_in": timeIn,
        "time_out_date": timeOutDate,
        "time_out": timeOut,
        "time_in_status": timeInStatus,
        "attendance_status": attendanceStatus,
        "reason_for_leaving": reasonForLeaving,
        "taken_a_break": takenABreak,
        "status": status,
        "total_entries": totalEntries,
        "attendance_id": attendanceId,
        "remove_attendance_id": removeAttendanceId,
        "employee_id": employeeId,
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
