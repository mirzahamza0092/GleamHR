// To parse this JSON data, do
//
//     final EmployeeShiftModel = EmployeeShiftModelFromJson(jsonString);

import 'dart:convert';

EmployeeShiftModel EmployeeShiftModelFromJson(String str) => EmployeeShiftModel.fromJson(json.decode(str));

String EmployeeShiftModelToJson(EmployeeShiftModel data) => json.encode(data.toJson());

class EmployeeShiftModel {
    Data? data;

    EmployeeShiftModel({
        this.data,
    });

    factory EmployeeShiftModel.fromJson(Map<String, dynamic> json) => EmployeeShiftModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    WorkSchedule? workSchedule;
    String? scheduleStartTime;
    String? scheduleEndTime;

    Data({
        this.workSchedule,
        this.scheduleStartTime,
        this.scheduleEndTime,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        workSchedule: json["work_schedule"] == null ? null : WorkSchedule.fromJson(json["work_schedule"]),
        scheduleStartTime: json["schedule_start_time"],
        scheduleEndTime: json["schedule_end_time"],
    );

    Map<String, dynamic> toJson() => {
        "work_schedule": workSchedule?.toJson(),
        "schedule_start_time": scheduleStartTime,
        "schedule_end_time": scheduleEndTime,
    };
}

class WorkSchedule {
    int? id;
    String? title;
    String? scheduleStartTime;
    String? flexTimeIn;
    String? scheduleBreakTime;
    String? scheduleBackTime;
    String? scheduleEndTime;
    String? scheduleHours;
    String? nonWorkingDays;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? flexEndTime;
    dynamic startScheduleEarlyTime;
    dynamic endScheduleLateTime;

    WorkSchedule({
        this.id,
        this.title,
        this.scheduleStartTime,
        this.flexTimeIn,
        this.scheduleBreakTime,
        this.scheduleBackTime,
        this.scheduleEndTime,
        this.scheduleHours,
        this.nonWorkingDays,
        this.createdAt,
        this.updatedAt,
        this.flexEndTime,
        this.startScheduleEarlyTime,
        this.endScheduleLateTime,
    });

    factory WorkSchedule.fromJson(Map<String, dynamic> json) => WorkSchedule(
        id: json["id"],
        title: json["title"],
        scheduleStartTime: json["schedule_start_time"],
        flexTimeIn: json["flex_time_in"],
        scheduleBreakTime: json["schedule_break_time"],
        scheduleBackTime: json["schedule_back_time"],
        scheduleEndTime: json["schedule_end_time"],
        scheduleHours: json["schedule_hours"],
        nonWorkingDays: json["non_working_days"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        flexEndTime: json["flex_end_time"],
        startScheduleEarlyTime: json["start_schedule_early_time"],
        endScheduleLateTime: json["end_schedule_late_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "schedule_start_time": scheduleStartTime,
        "flex_time_in": flexTimeIn,
        "schedule_break_time": scheduleBreakTime,
        "schedule_back_time": scheduleBackTime,
        "schedule_end_time": scheduleEndTime,
        "schedule_hours": scheduleHours,
        "non_working_days": nonWorkingDays,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "flex_end_time": flexEndTime,
        "start_schedule_early_time": startScheduleEarlyTime,
        "end_schedule_late_time": endScheduleLateTime,
    };
}
