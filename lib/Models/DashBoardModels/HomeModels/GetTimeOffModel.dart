// To parse this JSON data, do
//
//     final getTimeOffModel = getTimeOffModelFromJson(jsonString);

import 'dart:convert';

GetTimeOffModel getTimeOffModelFromJson(String str) => GetTimeOffModel.fromJson(json.decode(str));

String getTimeOffModelToJson(GetTimeOffModel data) => json.encode(data.toJson());

class GetTimeOffModel {
    List<PolicyElement>? policies;
    List<RequestedDay>? requestedDays;
    DaysData? daysData;
    List<DateTime>? holidays;

    GetTimeOffModel({
        this.policies,
        this.requestedDays,
        this.daysData,
        this.holidays,
    });

    factory GetTimeOffModel.fromJson(Map<String, dynamic> json) => GetTimeOffModel(
        policies: json["policies"] == null ? [] : List<PolicyElement>.from(json["policies"]!.map((x) => PolicyElement.fromJson(x))),
        requestedDays: json["requested_days"] == null ? [] : List<RequestedDay>.from(json["requested_days"]!.map((x) => RequestedDay.fromJson(x))),
        daysData: json["days_data"] == null ? null : DaysData.fromJson(json["days_data"]),
        holidays: json["holidays"] == null ? [] : List<DateTime>.from(json["holidays"]!.map((x) => DateTime.parse(x))),
    );

    Map<String, dynamic> toJson() => {
        "policies": policies == null ? [] : List<dynamic>.from(policies!.map((x) => x.toJson())),
        "requested_days": requestedDays == null ? [] : List<dynamic>.from(requestedDays!.map((x) => x.toJson())),
        "days_data": daysData?.toJson(),
        "holidays": holidays == null ? [] : List<dynamic>.from(holidays!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
    };
}

class DaysData {
    String? scheduleHours;
    List<String>? nonWorkingDays;

    DaysData({
        this.scheduleHours,
        this.nonWorkingDays,
    });

    factory DaysData.fromJson(Map<String, dynamic> json) => DaysData(
        scheduleHours: json["scheduleHours"],
        nonWorkingDays: json["nonWorkingDays"] == null ? [] : List<String>.from(json["nonWorkingDays"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "scheduleHours": scheduleHours,
        "nonWorkingDays": nonWorkingDays == null ? [] : List<dynamic>.from(nonWorkingDays!.map((x) => x)),
    };
}

class PolicyElement {
    int? id;
    int? employeeId;
    int? timeoffPolicyId;
    DateTime? createdAt;
    DateTime? updatedAt;
    DateTime? deletedAt;
    PolicyPolicy? policy;

    PolicyElement({
        this.id,
        this.employeeId,
        this.timeoffPolicyId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.policy,
    });

    factory PolicyElement.fromJson(Map<String, dynamic> json) => PolicyElement(
        id: json["id"],
        employeeId: json["employee_id"],
        timeoffPolicyId: json["timeoff_policy_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        policy: json["policy"] == null ? null : PolicyPolicy.fromJson(json["policy"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "timeoff_policy_id": timeoffPolicyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "policy": policy?.toJson(),
    };
}

class PolicyPolicy {
    int? id;
    String? policyName;
    String? policyType;
    String? firstAccrual;
    String? carryOverDate;
    String? accrualHappen;
    dynamic accrualTransitionHappend;
    String? oneTimeLimit;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    String? category;
    int? hoursAvailable;

    PolicyPolicy({
        this.id,
        this.policyName,
        this.policyType,
        this.firstAccrual,
        this.carryOverDate,
        this.accrualHappen,
        this.accrualTransitionHappend,
        this.oneTimeLimit,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.category,
        this.hoursAvailable,
    });

    factory PolicyPolicy.fromJson(Map<String, dynamic> json) => PolicyPolicy(
        id: json["id"],
        policyName: json["policy_name"],
        policyType: json["policy_type"],
        firstAccrual: json["first_accrual"],
        carryOverDate: json["carry_over_date"],
        accrualHappen: json["accrual_happen"],
        accrualTransitionHappend: json["accrual_transition_happend"],
        oneTimeLimit: json["one_time_limit"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        category: json["category"],
        hoursAvailable: json["hours_available"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "policy_name": policyName,
        "policy_type": policyType,
        "first_accrual": firstAccrual,
        "carry_over_date": carryOverDate,
        "accrual_happen": accrualHappen,
        "accrual_transition_happend": accrualTransitionHappend,
        "one_time_limit": oneTimeLimit,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "category": category,
        "hours_available": hoursAvailable,
    };
}

class RequestedDay {
    int? id;
    int? requestTimeOffId;
    DateTime? date;
    int? hours;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    RequestTimeOff? requestTimeOff;

    RequestedDay({
        this.id,
        this.requestTimeOffId,
        this.date,
        this.hours,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.requestTimeOff,
    });

    factory RequestedDay.fromJson(Map<String, dynamic> json) => RequestedDay(
        id: json["id"],
        requestTimeOffId: json["request_time_off_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        hours: json["hours"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        requestTimeOff: json["request_time_off"] == null ? null : RequestTimeOff.fromJson(json["request_time_off"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "request_time_off_id": requestTimeOffId,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "hours": hours,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "request_time_off": requestTimeOff?.toJson(),
    };
}

class RequestTimeOff {
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
    PolicyElement? assignTimeOff;

    RequestTimeOff({
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
        this.assignTimeOff,
    });

    factory RequestTimeOff.fromJson(Map<String, dynamic> json) => RequestTimeOff(
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
        assignTimeOff: json["assign_time_off"] == null ? null : PolicyElement.fromJson(json["assign_time_off"]),
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
        "assign_time_off": assignTimeOff?.toJson(),
    };
}
