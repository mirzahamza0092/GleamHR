// To parse this JSON data, do
//
//     final stagingLoginModel = stagingLoginModelFromJson(jsonString);

import 'dart:convert';

StagingLoginModel stagingLoginModelFromJson(String str) =>
    StagingLoginModel.fromJson(json.decode(str));

String stagingLoginModelToJson(StagingLoginModel data) =>
    json.encode(data.toJson());

class StagingLoginModel {
  dynamic accessToken;
  dynamic tokenType;
  dynamic expiresAt;
  UserData? userData;
  UserWorkSchedule? userWorkSchedule;
  dynamic userAttendanceData;
  List<UserRole>? userRole;
  dynamic permissions;

  StagingLoginModel({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.userData,
    this.userWorkSchedule,
    this.userAttendanceData,
    this.userRole,
    this.permissions,
  });

  factory StagingLoginModel.fromJson(Map<String, dynamic> json) =>
      StagingLoginModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresAt: json["expires_at"],
        userData: UserData.fromJson(json["user_data"]),
        userWorkSchedule: UserWorkSchedule.fromJson(json["user_work_schedule"]),
        userAttendanceData: json["user_attendance_data"],
        userRole: List<UserRole>.from(
            json["user_role"].map((x) => UserRole.fromJson(x))),
        permissions: json["permissions"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_at": expiresAt,
        "user_data": userData!.toJson(),
        "user_work_schedule": userWorkSchedule!.toJson(),
        "user_attendance_data": userAttendanceData,
        "permissions": permissions,
        "user_role": List<dynamic>.from(userRole!.map((x) => x.toJson())),
      };
}

class UserAttendanceData {
  List<dynamic>? assignedAttendanceTypes;
  dynamic employeeLatestAttendance;
  List<dynamic>? employeeAllAttendanceToday;
  List<dynamic>? employeeCurrentMonthAttendance;

  UserAttendanceData({
    this.assignedAttendanceTypes,
    this.employeeLatestAttendance,
    this.employeeAllAttendanceToday,
    this.employeeCurrentMonthAttendance,
  });

  factory UserAttendanceData.fromJson(Map<String, dynamic> json) =>
      UserAttendanceData(
        assignedAttendanceTypes: json["assignedAttendanceTypes"],
        employeeLatestAttendance: json["employeeLatestAttendance"],
        employeeAllAttendanceToday: List<dynamic>.from(
            json["employeeAllAttendanceToday"].map((x) => x)),
        employeeCurrentMonthAttendance: List<dynamic>.from(
            json["employeeCurrentMonthAttendance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "assignedAttendanceTypes": assignedAttendanceTypes,
        "employeeLatestAttendance": employeeLatestAttendance,
        "employeeAllAttendanceToday":
            List<dynamic>.from(employeeAllAttendanceToday!.map((x) => x)),
        "employeeCurrentMonthAttendance":
            List<dynamic>.from(employeeCurrentMonthAttendance!.map((x) => x)),
      };
}

class AssignedAttendanceType {
  int? id;
  int? employeeId;
  int? attendanceTypeId;
  String? createdAt;
  String? updatedAt;
  AttendanceType? attendanceType;

  AssignedAttendanceType({
    this.id,
    this.employeeId,
    this.attendanceTypeId,
    this.createdAt,
    this.updatedAt,
    this.attendanceType,
  });

  factory AssignedAttendanceType.fromJson(Map<String, dynamic> json) =>
      AssignedAttendanceType(
        id: json["id"],
        employeeId: json["employee_id"],
        attendanceTypeId: json["attendance_type_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        attendanceType: AttendanceType.fromJson(json["attendance_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "attendance_type_id": attendanceTypeId,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "attendance_type": attendanceType!.toJson(),
      };
}

class AttendanceType {
  int? id;
  String? name;
  String? permission;
  String? createdAt;
  String? updatedAt;

  AttendanceType({
    this.id,
    this.name,
    this.permission,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceType.fromJson(Map<String, dynamic> json) => AttendanceType(
        id: json["id"],
        name: json["name"],
        permission: json["permission"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "permission": permission,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
      };
}

class UserData {
  int? id;
  String? employeeNo;
  String? firstname;
  String? lastname;
  dynamic contactNo;
  String? officialEmail;
  dynamic personalEmail;
  dynamic nin;
  dynamic dateOfBirth;
  dynamic gender;
  dynamic maritalStatus;
  String? emergencyContactRelationship;
  dynamic emergencyContact;
  String? password;
  int? canMarkAttendance;
  dynamic currentAddress;
  dynamic currentCity;
  dynamic currentLatitude;
  dynamic currentLongitude;
  dynamic permanentAddress;
  dynamic permanentCity;
  dynamic permanentLatitude;
  dynamic permanentLongitude;
  dynamic city;
  int? designationId;
  String? type;
  int? status;
  int? employmentStatusId;
  dynamic educationId;
  dynamic visaId;
  dynamic picture;
  String? joiningDate;
  dynamic exitDate;
  int? locationId;
  int? zuid;
  int? accountId;
  int? departmentId;
  int? workScheduleId;
  dynamic inviteToZoho;
  dynamic inviteToSlack;
  dynamic inviteToAsana;
  int? managerId;
  DateTime? lastLogin;
  DateTime? lastLoginMobile;
  dynamic rememberToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic healthCardNo;
  String? username;
  String? fatherName;
  String? motherName;
  String? fullName;
  dynamic location;
  dynamic designation;
  dynamic department;
  dynamic todayWorkingHours;
  int? trackLocation;
  int? frequency;

  UserData({
    this.id,
    this.employeeNo,
    this.firstname,
    this.lastname,
    this.contactNo,
    this.officialEmail,
    this.personalEmail,
    this.nin,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.emergencyContactRelationship,
    this.emergencyContact,
    this.password,
    this.canMarkAttendance,
    this.currentAddress,
    this.currentCity,
    this.currentLatitude,
    this.currentLongitude,
    this.permanentAddress,
    this.permanentCity,
    this.permanentLatitude,
    this.permanentLongitude,
    this.city,
    this.designationId,
    this.type,
    this.status,
    this.employmentStatusId,
    this.educationId,
    this.visaId,
    this.picture,
    this.joiningDate,
    this.exitDate,
    this.locationId,
    this.zuid,
    this.todayWorkingHours,
    this.accountId,
    this.departmentId,
    this.workScheduleId,
    this.inviteToZoho,
    this.inviteToSlack,
    this.inviteToAsana,
    this.managerId,
    this.lastLogin,
    this.lastLoginMobile,
    this.rememberToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.healthCardNo,
    this.username,
    this.fatherName,
    this.motherName,
    this.fullName,
    this.location,
    this.designation,
    this.department,
    this.frequency,
    this.trackLocation,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        employeeNo: json["employee_no"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        contactNo: json["contact_no"],
        officialEmail: json["official_email"],
        personalEmail: json["personal_email"],
        nin: json["nin"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        emergencyContactRelationship: json["emergency_contact_relationship"],
        emergencyContact: json["emergency_contact"],
        password: json["password"],
        canMarkAttendance: json["can_mark_attendance"],
        currentAddress: json["current_address"],
        currentCity: json["current_city"],
        currentLatitude: json["current_latitude"],
        currentLongitude: json["current_longitude"],
        permanentAddress: json["permanent_address"],
        permanentCity: json["permanent_city"],
        permanentLatitude: json["permanent_latitude"],
        permanentLongitude: json["permanent_longitude"],
        city: json["city"],
        designationId: json["designation_id"],
        todayWorkingHours: json["today_working_hours"],
        type: json["type"],
        status: json["status"],
        employmentStatusId: json["employment_status_id"],
        educationId: json["education_id"],
        visaId: json["visa_id"],
        picture: json["picture"],
        joiningDate: json["joining_date"],
        exitDate: json["exit_date"],
        locationId: json["location_id"],
        zuid: json["zuid"],
        accountId: json["account_id"],
        departmentId: json["department_id"],
        workScheduleId: json["work_schedule_id"],
        inviteToZoho: json["invite_to_zoho"],
        inviteToSlack: json["invite_to_slack"],
        inviteToAsana: json["invite_to_asana"],
        managerId: json["manager_id"],
        lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
        lastLoginMobile: json["last_login_mobile"] == null ? null : DateTime.parse(json["last_login_mobile"]),
        rememberToken: json["remember_token"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        healthCardNo: json["health_card_no"],
        username: json["username"],
        fatherName: json["father_name"],
        motherName: json["mother_name"],
        fullName: json["full_name"],
        location: json["location"],
        designation: json["designation"],
        department: json["department"],
        trackLocation: json["track_location"],
        frequency: json["frequency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_no": employeeNo,
        "firstname": firstname,
        "lastname": lastname,
        "contact_no": contactNo,
        "official_email": officialEmail,
        "personal_email": personalEmail,
        "nin": nin,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "marital_status": maritalStatus,
        "emergency_contact_relationship": emergencyContactRelationship,
        "emergency_contact": emergencyContact,
        "password": password,
        "can_mark_attendance": canMarkAttendance,
        "current_address": currentAddress,
        "current_city": currentCity,
        "current_latitude": currentLatitude,
        "current_longitude": currentLongitude,
        "permanent_address": permanentAddress,
        "permanent_city": permanentCity,
        "permanent_latitude": permanentLatitude,
        "permanent_longitude": permanentLongitude,
        "city": city,
        "designation_id": designationId,
        "type": type,
        "status": status,
        "employment_status_id": employmentStatusId,
        "education_id": educationId,
        "visa_id": visaId,
        "picture": picture,
        "today_working_hours": todayWorkingHours,
        "joining_date": joiningDate,
        "exit_date": exitDate,
        "location_id": locationId,
        "zuid": zuid,
        "account_id": accountId,
        "department_id": departmentId,
        "work_schedule_id": workScheduleId,
        "invite_to_zoho": inviteToZoho,
        "invite_to_slack": inviteToSlack,
        "invite_to_asana": inviteToAsana,
        "manager_id": managerId,
        "last_login": lastLogin?.toIso8601String(),
        "last_login_mobile": lastLoginMobile?.toIso8601String(),
        "remember_token": rememberToken,
        "deleted_at": deletedAt,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "health_card_no": healthCardNo,
        "username": username,
        "father_name": fatherName,
        "mother_name": motherName,
        "full_name": fullName,
        "location": location,
        "designation": designation,
        "department": department,
        "track_location": trackLocation,
        "frequency": frequency,
      };
}

class Department {
  int? id;
  String? departmentName;
  String? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Department({
    this.id,
    this.departmentName,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        departmentName: json["department_name"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_name": departmentName,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
      };
}

class Designation {
  int? id;
  String? designationName;
  int? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Designation({
    this.id,
    this.designationName,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        designationName: json["designation_name"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation_name": designationName,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
      };
}

class Location {
  int? id;
  String? name;
  String? street1;
  String? street2;
  String? city;
  String? state;
  int? zipCode;
  String? country;
  String? latitude;
  String? longitude;
  String? phoneNumber;
  String? timezone;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Location({
    this.id,
    this.name,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.timezone,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        street1: json["street_1"],
        street2: json["street_2"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        phoneNumber: json["phone_number"],
        timezone: json["timezone"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "street_1": street1,
        "street_2": street2,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "phone_number": phoneNumber,
        "timezone": timezone,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "deleted_at": deletedAt,
      };
}

class UserRole {
  int? id;
  String? name;
  String? guardName;
  String? type;
  String? description;
  dynamic subRole;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  UserRole({
    this.id,
    this.name,
    this.guardName,
    this.type,
    this.description,
    this.subRole,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        type: json["type"],
        description: json["description"],
        subRole: json["sub_role"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "type": type,
        "description": description,
        "sub_role": subRole,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "pivot": pivot!.toJson(),
      };
}

class Pivot {
  int? modelId;
  int? roleId;
  String? modelType;

  Pivot({
    this.modelId,
    this.roleId,
    this.modelType,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelId: json["model_id"],
        roleId: json["role_id"],
        modelType: json["model_type"],
      );

  Map<String, dynamic> toJson() => {
        "model_id": modelId,
        "role_id": roleId,
        "model_type": modelType,
      };
}

class UserWorkSchedule {
  dynamic workSchedule;
  String? scheduleStartTime;
  String? scheduleEndTime;

  UserWorkSchedule({
    this.workSchedule,
    this.scheduleStartTime,
    this.scheduleEndTime,
  });

  factory UserWorkSchedule.fromJson(Map<String, dynamic> json) =>
      UserWorkSchedule(
        workSchedule: json["work_schedule"],
        scheduleStartTime: json["schedule_start_time"],
        scheduleEndTime: json["schedule_end_time"],
      );

  Map<String, dynamic> toJson() => {
        "work_schedule": workSchedule,
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
  String? createdAt;
  String? updatedAt;

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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
      };
}
