// To parse this JSON data, do
//
//     final specificEmployeeModel = specificEmployeeModelFromJson(jsonString);

import 'dart:convert';

SpecificEmployeeModel specificEmployeeModelFromJson(String str) => SpecificEmployeeModel.fromJson(json.decode(str));

String specificEmployeeModelToJson(SpecificEmployeeModel data) => json.encode(data.toJson());

class SpecificEmployeeModel {
    int? success;
    Data? data;

    SpecificEmployeeModel({
        this.success,
        this.data,
    });

    factory SpecificEmployeeModel.fromJson(Map<String, dynamic> json) => SpecificEmployeeModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? picture;
    String? employeeNo;
    String? firstname;
    dynamic lastname;
    String? contactNo;
    String? officialEmail;
    dynamic fatherName;
    int? status;
    int? designationId;
    int? managerId;
    String? fullName;
    String? acronym;
    Designation? designation;

    Data({
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
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
