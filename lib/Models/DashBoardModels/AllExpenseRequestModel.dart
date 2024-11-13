// To parse this JSON data, do
//
//     final allExpenseRequestsModel = allExpenseRequestsModelFromJson(jsonString);

import 'dart:convert';

AllExpenseRequestsModel allExpenseRequestsModelFromJson(String str) => AllExpenseRequestsModel.fromJson(json.decode(str));

String allExpenseRequestsModelToJson(AllExpenseRequestsModel data) => json.encode(data.toJson());

class AllExpenseRequestsModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    AllExpenseRequestsModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory AllExpenseRequestsModel.fromJson(Map<String, dynamic> json) => AllExpenseRequestsModel(
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
    String? startDate;
    String? endDate;
    String? expense;
    String? expenseCategory;
    String? expenseProcessStatus;
    String? comment;
    String? status;
    int? decisionBy;
    dynamic decisionComment;
    int? expenseTypeId;
    int? employeeId;
    DateTime? createdAt;
    DateTime? updatedAt;
    EmployeeName? employeeName;

    Datum({
        this.id,
        this.startDate,
        this.endDate,
        this.expense,
        this.expenseCategory,
        this.expenseProcessStatus,
        this.comment,
        this.status,
        this.decisionBy,
        this.decisionComment,
        this.expenseTypeId,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.employeeName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        expense: json["expense"],
        expenseCategory: json["expense_category"],
        expenseProcessStatus: json["expense_process_status"],
        comment: json["comment"],
        status: json["status"],
        decisionBy: json["decision_by"],
        decisionComment: json["decision_comment"],
        expenseTypeId: json["expense_type_id"],
        employeeId: json["employee_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        employeeName: json["employee_name"] == null ? null : EmployeeName.fromJson(json["employee_name"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate,
        "end_date": endDate,
        "expense": expense,
        "expense_category": expenseCategory,
        "expense_process_status": expenseProcessStatus,
        "comment": comment,
        "status": status,
        "decision_by": decisionBy,
        "decision_comment": decisionComment,
        "expense_type_id": expenseTypeId,
        "employee_id": employeeId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "employee_name": employeeName?.toJson(),
    };
}

class EmployeeName {
    int? id;
    String? firstname;
    String? lastname;
    String? fullName;
    String? acronym;

    EmployeeName({
        this.id,
        this.firstname,
        this.lastname,
        this.fullName,
        this.acronym,
    });

    factory EmployeeName.fromJson(Map<String, dynamic> json) => EmployeeName(
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
