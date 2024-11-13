// To parse this JSON data, do
//
//     final allNotificationsModel = allNotificationsModelFromJson(jsonString);

import 'dart:convert';

AllNotificationsModel allNotificationsModelFromJson(String str) => AllNotificationsModel.fromJson(json.decode(str));

String allNotificationsModelToJson(AllNotificationsModel data) => json.encode(data.toJson());

class AllNotificationsModel {
    String? success;
    Notifications? notifications;

    AllNotificationsModel({
        this.success,
        this.notifications,
    });

    factory AllNotificationsModel.fromJson(Map<String, dynamic> json) => AllNotificationsModel(
        success: json["success"],
        notifications: json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "notifications": notifications?.toJson(),
    };
}

class Notifications {
    int? currentPage;
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    List<Link>? links;
    String? nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    Notifications({
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

    factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
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
    String? id;
    String? type;
    String? notifiableType;
    int? notifiableId;
    Data? data;
    DateTime? readAt;
    int? isCompleted;
    dynamic deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.readAt,
        this.isCompleted,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
        isCompleted: json["is_completed"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data?.toJson(),
        "read_at": readAt?.toIso8601String(),
        "is_completed": isCompleted,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Data {
    String? title;
    String? message;
    String? description;
    String? inboxUrl;
    String? url;
    String? greetings;
    String? subject;
    String? approveUrl;
    String? disapproveUrl;
    String? requester;
    String? approvalType;
    String? body;
    String? bodyInformation;
    RequestedInformation? requestedInformation;
    int? requestedDataId;
    String? status;
    int? requesttimeoffId;
    String? id;

    Data({
        this.title,
        this.message,
        this.description,
        this.inboxUrl,
        this.url,
        this.greetings,
        this.subject,
        this.approveUrl,
        this.disapproveUrl,
        this.requester,
        this.approvalType,
        this.body,
        this.bodyInformation,
        this.requestedInformation,
        this.requestedDataId,
        this.status,
        this.requesttimeoffId,
        this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        message: json["message"],
        description: json["description"],
        inboxUrl: json["inboxURL"],
        url: json["url"],
        greetings: json["greetings"],
        subject: json["subject"],
        approveUrl: json["approveURL"],
        disapproveUrl: json["disapproveURL"],
        requester: json["requester"],
        approvalType: json["approval_type"],
        body: json["body"],
        bodyInformation: json["body_information"],
        requestedInformation: json["requested_information"] == null ? null : RequestedInformation.fromJson(json["requested_information"]),
        requestedDataId: json["requestedDataID"],
        status: json["status"],
        requesttimeoffId: json["requesttimeoff_id"],
        id: json["id"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "description": description,
        "inboxURL": inboxUrl,
        "url": url,
        "greetings": greetings,
        "subject": subject,
        "approveURL": approveUrl,
        "disapproveURL": disapproveUrl,
        "requester": requester,
        "approval_type": approvalType,
        "body": body,
        "body_information": bodyInformation,
        "requested_information": requestedInformation?.toJson(),
        "requestedDataID": requestedDataId,
        "status": status,
        "requesttimeoff_id": requesttimeoffId,
        "id": id,
    };
}

class RequestedInformation {
    String? date;
    String? reason;
    String? requestedOn;
    int? id;
    List<String>? expenseProof;
    String? expenseCategory;
    String? expenseType;
    String? expenseAmount;
    dynamic comments;
    String? assetTypeId;
    String? assetType;
    String? message;

    RequestedInformation({
        this.date,
        this.reason,
        this.requestedOn,
        this.id,
        this.expenseProof,
        this.expenseCategory,
        this.expenseType,
        this.expenseAmount,
        this.comments,
        this.assetTypeId,
        this.assetType,
        this.message,
    });

    factory RequestedInformation.fromJson(Map<String, dynamic> json) => RequestedInformation(
        date: json["Date"],
        reason: json["Reason"],
        requestedOn: json["Requested On"],
        id: json["id"],
        expenseProof: json["expense_proof"] == null ? [] : List<String>.from(json["expense_proof"]!.map((x) => x)),
        expenseCategory: json["Expense Category"],
        expenseType: json["Expense Type"],
        expenseAmount: json["Expense Amount"],
        comments: json["Comments"],
        assetTypeId: json["asset_type_id"],
        assetType: json["asset_type"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "Date": date,
        "Reason": reason,
        "Requested On": requestedOn,
        "id": id,
        "expense_proof": expenseProof == null ? [] : List<dynamic>.from(expenseProof!.map((x) => x)),
        "Expense Category": expenseCategory,
        "Expense Type": expenseType,
        "Expense Amount": expenseAmount,
        "Comments": comments,
        "asset_type_id": assetTypeId,
        "asset_type": assetType,
        "message": message,
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
