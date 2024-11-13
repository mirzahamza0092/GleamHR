// To parse this JSON data, do
//
//     final paySlipsModel = paySlipsModelFromJson(jsonString);

import 'dart:convert';

PaySlipsModel paySlipsModelFromJson(String str) => PaySlipsModel.fromJson(json.decode(str));

String paySlipsModelToJson(PaySlipsModel data) => json.encode(data.toJson());

class PaySlipsModel {
    String? success;
    List<Datum>? data;

    PaySlipsModel({
        this.success,
        this.data,
    });

    factory PaySlipsModel.fromJson(Map<String, dynamic> json) => PaySlipsModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? basicSalary;
    String? homeAllowance;
    String? travelAllowance;
    String? incomeTax;
    String? bonus;
    String? customDeduction;
    String? absentCount;
    String? deduction;
    String? netPayable;
    String? tenure;
    String? status;
    dynamic reason;
    int? employeeId;
    dynamic createdAt;
    dynamic updatedAt;
    String? specialAllowance;
    String? grossSalary;
    String? overtimePay;
    int? processed;
    String? assetDeduction;
    int? batchId;
    int? payScheduleId;
    String? salary;
    String? noOfItems;
    String? totalHours;
    dynamic salarySlip;

    Datum({
        this.id,
        this.basicSalary,
        this.homeAllowance,
        this.travelAllowance,
        this.incomeTax,
        this.bonus,
        this.customDeduction,
        this.absentCount,
        this.deduction,
        this.netPayable,
        this.tenure,
        this.status,
        this.reason,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.specialAllowance,
        this.grossSalary,
        this.overtimePay,
        this.processed,
        this.assetDeduction,
        this.batchId,
        this.payScheduleId,
        this.salary,
        this.noOfItems,
        this.totalHours,
        this.salarySlip,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        basicSalary: json["basic_salary"],
        homeAllowance: json["home_allowance"],
        travelAllowance: json["travel_allowance"],
        incomeTax: json["income_tax"],
        bonus: json["bonus"],
        customDeduction: json["custom_deduction"],
        absentCount: json["absent_count"],
        deduction: json["deduction"],
        netPayable: json["net_payable"],
        tenure: json["tenure"],
        status: json["status"],
        reason: json["reason"],
        employeeId: json["employee_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        specialAllowance: json["special_allowance"],
        grossSalary: json["gross_salary"],
        overtimePay: json["overtime_pay"],
        processed: json["processed"],
        assetDeduction: json["asset_deduction"],
        batchId: json["batch_id"],
        payScheduleId: json["pay_schedule_id"],
        salary: json["salary"],
        noOfItems: json["no_of_items"],
        totalHours: json["total_hours"],
        salarySlip: json["salary_slip"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "basic_salary": basicSalary,
        "home_allowance": homeAllowance,
        "travel_allowance": travelAllowance,
        "income_tax": incomeTax,
        "bonus": bonus,
        "custom_deduction": customDeduction,
        "absent_count": absentCount,
        "deduction": deduction,
        "net_payable": netPayable,
        "tenure": tenure,
        "status": status,
        "reason": reason,
        "employee_id": employeeId,
        "created_at": createdAt!,
        "updated_at": updatedAt!,
        "special_allowance": specialAllowance,
        "gross_salary": grossSalary,
        "overtime_pay": overtimePay,
        "processed": processed,
        "asset_deduction": assetDeduction,
        "batch_id": batchId,
        "pay_schedule_id": payScheduleId,
        "salary": salary,
        "no_of_items": noOfItems,
        "total_hours": totalHours,
        "salary_slip": salarySlip,
    };
}
