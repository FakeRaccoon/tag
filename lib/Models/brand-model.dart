// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

List<BrandModel> brandModelFromJson(String str) => List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));

String brandModelToJson(List<BrandModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandModel {
  BrandModel({
    this.brandCode,
    this.brandName,
  });

  String? brandCode;
  String? brandName;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    brandCode: json["brand_code"] == null ? null : json["brand_code"],
    brandName: json["brand_name"] == null ? null : json["brand_name"],
  );

  Map<String, dynamic> toJson() => {
    "brand_code": brandCode == null ? null : brandCode,
    "brand_name": brandName == null ? null : brandName,
  };
}
