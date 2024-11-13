// To parse this JSON data, do
//
//     final allEmployeeRolesModel = allEmployeeRolesModelFromJson(jsonString);

import 'dart:convert';

AllEmployeeRolesModel allEmployeeRolesModelFromJson(String str) => AllEmployeeRolesModel.fromJson(json.decode(str));

String allEmployeeRolesModelToJson(AllEmployeeRolesModel data) => json.encode(data.toJson());

class AllEmployeeRolesModel {
    String? success;
    List<Role>? roles;

    AllEmployeeRolesModel({
        this.success,
        this.roles,
    });

    factory AllEmployeeRolesModel.fromJson(Map<String, dynamic> json) => AllEmployeeRolesModel(
        success: json["success"],
        roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
    };
}

class Role {
    int? id;
    String? name;
    String? guardName;
    String? type;
    String? description;
    String? subRole;
    DateTime? createdAt;
    DateTime? updatedAt;

    Role({
        this.id,
        this.name,
        this.guardName,
        this.type,
        this.description,
        this.subRole,
        this.createdAt,
        this.updatedAt,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        type: json["type"],
        description: json["description"],
        subRole: json["sub_role"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "type": type,
        "description": description,
        "sub_role": subRole,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
