// To parse this JSON data, do
//
//     final checkinCheckoutModel = checkinCheckoutModelFromJson(jsonString);

import 'dart:convert';

CheckinCheckoutModel checkinCheckoutModelFromJson(String str) => CheckinCheckoutModel.fromJson(json.decode(str));

String checkinCheckoutModelToJson(CheckinCheckoutModel data) => json.encode(data.toJson());

class CheckinCheckoutModel {
    int? success;
    String? message;
    AttendanceDetails? attendanceDetails;

    CheckinCheckoutModel({
        this.success,
        this.message,
        this.attendanceDetails,
    });

    factory CheckinCheckoutModel.fromJson(Map<String, dynamic> json) => CheckinCheckoutModel(
        success: json["success"],
        message: json["message"],
        attendanceDetails: json["attendanceDetails"] == null ? null : AttendanceDetails.fromJson(json["attendanceDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "attendanceDetails": attendanceDetails?.toJson(),
    };
}

class AttendanceDetails {
    AttendancePermissions? attendancePermissions;
    EmployeeAttendance? employeeLatestAttendance;
    List<int>? employeeAllAttendanceToday;
    dynamic employeeWorkFromHomeStatus;
    List<EmployeeAttendance>? employeeCurrentMonthAttendance;
    bool? mobileAttendancePermission;
    bool? geoFencing;
    int? geoRadius;
    bool? facialRecognition;
    AttendanceMarkingData? attendanceMarkingData;

    AttendanceDetails({
        this.attendancePermissions,
        this.employeeLatestAttendance,
        this.employeeAllAttendanceToday,
        this.employeeWorkFromHomeStatus,
        this.employeeCurrentMonthAttendance,
        this.mobileAttendancePermission,
        this.geoFencing,
        this.geoRadius,
        this.facialRecognition,
        this.attendanceMarkingData,
    });

    factory AttendanceDetails.fromJson(Map<String, dynamic> json) => AttendanceDetails(
        attendancePermissions: json["attendancePermissions"] == null ? null : AttendancePermissions.fromJson(json["attendancePermissions"]),
        employeeLatestAttendance: json["employeeLatestAttendance"] == null ? null : EmployeeAttendance.fromJson(json["employeeLatestAttendance"]),
        employeeAllAttendanceToday: json["employeeAllAttendanceToday"] == null ? [] : List<int>.from(json["employeeAllAttendanceToday"]!.map((x) => x)),
        employeeWorkFromHomeStatus: json["employeeWorkFromHomeStatus"],
        employeeCurrentMonthAttendance: json["employeeCurrentMonthAttendance"] == null ? [] : List<EmployeeAttendance>.from(json["employeeCurrentMonthAttendance"]!.map((x) => EmployeeAttendance.fromJson(x))),
        mobileAttendancePermission: json["mobile_attendance_permission"],
        geoFencing: json["geo_fencing"],
        geoRadius: json["geo_radius"],
        facialRecognition: json["facial_recognition"],
        attendanceMarkingData: json["attendance_marking_data"] == null ? null : AttendanceMarkingData.fromJson(json["attendance_marking_data"]),
    );

    Map<String, dynamic> toJson() => {
        "attendancePermissions": attendancePermissions?.toJson(),
        "employeeLatestAttendance": employeeLatestAttendance?.toJson(),
        "employeeAllAttendanceToday": employeeAllAttendanceToday == null ? [] : List<dynamic>.from(employeeAllAttendanceToday!.map((x) => x)),
        "employeeWorkFromHomeStatus": employeeWorkFromHomeStatus,
        "employeeCurrentMonthAttendance": employeeCurrentMonthAttendance == null ? [] : List<dynamic>.from(employeeCurrentMonthAttendance!.map((x) => x.toJson())),
        "mobile_attendance_permission": mobileAttendancePermission,
        "geo_fencing": geoFencing,
        "geo_radius": geoRadius,
        "facial_recognition": facialRecognition,
        "attendance_marking_data": attendanceMarkingData?.toJson(),
    };
}

class AttendanceMarkingData {
    String? button;
    String? clockType;

    AttendanceMarkingData({
        this.button,
        this.clockType,
    });

    factory AttendanceMarkingData.fromJson(Map<String, dynamic> json) => AttendanceMarkingData(
        button: json["button"],
        clockType: json["clock_type"],
    );

    Map<String, dynamic> toJson() => {
        "button": button,
        "clock_type": clockType,
    };
}

class AttendancePermissions {
    bool? deviceAttendance;
    bool? mobileAppAttendance;
    bool? websiteAttendance;

    AttendancePermissions({
        this.deviceAttendance,
        this.mobileAppAttendance,
        this.websiteAttendance,
    });

    factory AttendancePermissions.fromJson(Map<String, dynamic> json) => AttendancePermissions(
        deviceAttendance: json["device attendance"],
        mobileAppAttendance: json["mobile-app attendance"],
        websiteAttendance: json["website attendance"],
    );

    Map<String, dynamic> toJson() => {
        "device attendance": deviceAttendance,
        "mobile-app attendance": mobileAppAttendance,
        "website attendance": websiteAttendance,
    };
}

class EmployeeAttendance {
    int? id;
    String? timeIn;
    String? timeOut;
    String? timeInStatus;
    String? attendanceStatus;
    String? reasonForLeaving;
    String? takenABreak;
    int? employeeId;
    DateTime? relatedToDate;
    dynamic deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? sourceId;

    EmployeeAttendance({
        this.id,
        this.timeIn,
        this.timeOut,
        this.timeInStatus,
        this.attendanceStatus,
        this.reasonForLeaving,
        this.takenABreak,
        this.employeeId,
        this.relatedToDate,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.sourceId,
    });

    factory EmployeeAttendance.fromJson(Map<String, dynamic> json) => EmployeeAttendance(
        id: json["id"],
        timeIn: json["time_in"],
        timeOut: json["time_out"],
        timeInStatus: json["time_in_status"],
        attendanceStatus: json["attendance_status"],
        reasonForLeaving: json["reason_for_leaving"],
        takenABreak: json["taken_a_break"],
        employeeId: json["employee_id"],
        relatedToDate: json["related_to_date"] == null ? null : DateTime.parse(json["related_to_date"]),
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        sourceId: json["source_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "time_in": timeIn,
        "time_out": timeOut,
        "time_in_status": timeInStatus,
        "attendance_status": attendanceStatus,
        "reason_for_leaving": reasonForLeaving,
        "taken_a_break": takenABreak,
        "employee_id": employeeId,
        "related_to_date": "${relatedToDate!.year.toString().padLeft(4, '0')}-${relatedToDate!.month.toString().padLeft(2, '0')}-${relatedToDate!.day.toString().padLeft(2, '0')}",
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "source_id": sourceId,
    };
}
