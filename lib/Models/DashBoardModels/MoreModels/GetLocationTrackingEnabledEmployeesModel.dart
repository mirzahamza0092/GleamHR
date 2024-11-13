// To parse this JSON data, do
//
//     final getLocationTrackingEnabledEmployeesModel = getLocationTrackingEnabledEmployeesModelFromJson(jsonString);

import 'dart:convert';

GetLocationTrackingEnabledEmployeesModel getLocationTrackingEnabledEmployeesModelFromJson(String str) => GetLocationTrackingEnabledEmployeesModel.fromJson(json.decode(str));

String getLocationTrackingEnabledEmployeesModelToJson(GetLocationTrackingEnabledEmployeesModel data) => json.encode(data.toJson());

class GetLocationTrackingEnabledEmployeesModel {
    String? success;
    Data? data;

    GetLocationTrackingEnabledEmployeesModel({
        this.success,
        this.data,
    });

    factory GetLocationTrackingEnabledEmployeesModel.fromJson(Map<String, dynamic> json) => GetLocationTrackingEnabledEmployeesModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    int? currentPage;
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    List<Link>? links;
    dynamic nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    Data({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    int? id;
    String? picture;
    String? firstname;
    String? employeeNo;
    String? lastname;
    int? status;
    int? trackLocation;
    int? frequency;
    String? fullName;
    String? acronym;

    Datum({
        this.id,
        this.picture,
        this.firstname,
        this.employeeNo,
        this.lastname,
        this.status,
        this.trackLocation,
        this.frequency,
        this.fullName,
        this.acronym,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        picture: json["picture"],
        firstname: json["firstname"],
        employeeNo: json["employee_no"],
        lastname: json["lastname"],
        status: json["status"],
        trackLocation: json["track_location"],
        frequency: json["frequency"],
        fullName: json["full_name"],
        acronym: json["acronym"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "picture": picture,
        "firstname": firstname,
        "employee_no": employeeNo,
        "lastname": lastname,
        "status": status,
        "track_location": trackLocation,
        "frequency": frequency,
        "full_name": fullName,
        "acronym": acronym,
    };
}

class Link {
    String? url;
    String? label;
    bool? active;

    Link({
        this.url,
        this.label,
        this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
