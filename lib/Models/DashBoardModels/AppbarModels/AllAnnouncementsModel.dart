// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';

AnnouncementModel announcementModelFromJson(String str) => AnnouncementModel.fromJson(json.decode(str));

String announcementModelToJson(AnnouncementModel data) => json.encode(data.toJson());

class AnnouncementModel {
    List<Datum>? data;
    int? currentPage;
    int? totalPages;

    AnnouncementModel({
        this.data,
        this.currentPage,
        this.totalPages,
    });

    factory AnnouncementModel.fromJson(Map<String, dynamic> json) => AnnouncementModel(
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
    String? title;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
