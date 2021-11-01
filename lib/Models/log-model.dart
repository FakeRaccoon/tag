// To parse this JSON data, do
//
//     final logModel = logModelFromJson(jsonString);

import 'dart:convert';

LogModel logModelFromJson(String str) => LogModel.fromJson(json.decode(str));

String logModelToJson(LogModel data) => json.encode(data.toJson());

class LogModel {
  LogModel({
    this.status,
    this.data,
    this.meta,
  });

  int? status;
  List<Datum>? data;
  Meta? meta;

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta == null ? null : meta!.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.log,
    this.type,
    this.createdAt,
  });

  int? id;
  String? log;
  int? type;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    log: json["log"] == null ? null : json["log"],
    type: json["type"] == null ? null : json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "log": log == null ? null : log,
    "type": type == null ? null : type,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
  };
}

class Meta {
  Meta({
    this.perPage,
    this.currentPage,
    this.totalPage,
  });

  int? perPage;
  int? currentPage;
  int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    perPage: json["per_page"] == null ? null : json["per_page"],
    currentPage: json["current_page"] == null ? null : json["current_page"],
    totalPage: json["total_page"] == null ? null : json["total_page"],
  );

  Map<String, dynamic> toJson() => {
    "per_page": perPage == null ? null : perPage,
    "current_page": currentPage == null ? null : currentPage,
    "total_page": totalPage == null ? null : totalPage,
  };
}
