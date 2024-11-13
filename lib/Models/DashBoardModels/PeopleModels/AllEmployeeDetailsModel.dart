// To parse this JSON data, do
//
//     final allEmployeesDetailsModel = allEmployeesDetailsModelFromJson(jsonString);

import 'dart:convert';

AllEmployeesDetailsModel allEmployeesDetailsModelFromJson(String str) => AllEmployeesDetailsModel.fromJson(json.decode(str));

String allEmployeesDetailsModelToJson(AllEmployeesDetailsModel data) => json.encode(data.toJson());

class AllEmployeesDetailsModel {
    List<Employee>? employees;

    AllEmployeesDetailsModel({
        this.employees,
    });

    factory AllEmployeesDetailsModel.fromJson(Map<String, dynamic> json) => AllEmployeesDetailsModel(
        employees: json["Employees"] == null ? [] : List<Employee>.from(json["Employees"]!.map((x) => Employee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
    };
}

class Employee {
    int? id;
    String? picture;
    String? employeeNo;
    String? firstname;
    String? lastname;
    String? contactNo;
    String? officialEmail;
    String? fatherName;
    int? status;
    int? designationId;
    int? managerId;
    String? fullName;
    String? acronym;
    Designation? designation;
    List<Role>? roles;

    Employee({
        this.id,
        this.picture,
        this.employeeNo,
        this.firstname,
        this.lastname,
        this.contactNo,
        this.officialEmail,
        this.fatherName,
        this.status,
        this.designationId,
        this.managerId,
        this.fullName,
        this.acronym,
        this.designation,
        this.roles,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        picture: json["picture"],
        employeeNo: json["employee_no"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        contactNo: json["contact_no"],
        officialEmail: json["official_email"],
        fatherName: json["father_name"],
        status: json["status"],
        designationId: json["designation_id"],
        managerId: json["manager_id"],
        fullName: json["full_name"],
        acronym: json["acronym"],
        designation: json["designation"] == null ? null : Designation.fromJson(json["designation"]),
        roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "picture": picture,
        "employee_no": employeeNo,
        "firstname": firstname,
        "lastname": lastname,
        "contact_no": contactNo,
        "official_email": officialEmail,
        "father_name": fatherName,
        "status": status,
        "designation_id": designationId,
        "manager_id": managerId,
        "full_name": fullName,
        "acronym": acronym,
        "designation": designation?.toJson(),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
    };
}

class Designation {
    int? id;
    String? designationName;

    Designation({
        this.id,
        this.designationName,
    });

    factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        designationName: json["designation_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "designation_name": designationName,
    };
}

class Role {
    int? id;
    String? name;
    Pivot? pivot;

    Role({
        this.id,
        this.name,
        this.pivot,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pivot": pivot?.toJson(),
    };
}

class Pivot {
    String? modelType;
    int? modelId;
    int? roleId;

    Pivot({
        this.modelType,
        this.modelId,
        this.roleId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelType: json["model_type"],
        modelId: json["model_id"],
        roleId: json["role_id"],
    );

    Map<String, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
    };
}
