// To parse this JSON data, do
//
//     final warehouseModel = warehouseModelFromJson(jsonString);

import 'dart:convert';

List<WarehouseModel> warehouseModelFromJson(String str) => List<WarehouseModel>.from(json.decode(str).map((x) => WarehouseModel.fromJson(x)));

String warehouseModelToJson(List<WarehouseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseModel {
  WarehouseModel({
    this.id,
    this.warehouseName,
    this.warehouseLocation,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? warehouseName;
  String? warehouseLocation;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
    id: json["id"] == null ? null : json["id"],
    warehouseName: json["warehouse_name"] == null ? null : json["warehouse_name"],
    warehouseLocation: json["warehouse_location"] == null ? null : json["warehouse_location"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "warehouse_name": warehouseName == null ? null : warehouseName,
    "warehouse_location": warehouseLocation == null ? null : warehouseLocation,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
