// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) => List<CategoriesModel>.from(json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  CategoriesModel({
    this.categoryCode,
    this.categoryName,
    this.categoryDescription,
  });

  String? categoryCode;
  String? categoryName;
  String? categoryDescription;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    categoryCode: json["category_code"] == null ? null : json["category_code"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    categoryDescription: json["category_description"] == null ? null : json["category_description"],
  );

  Map<String, dynamic> toJson() => {
    "category_code": categoryCode == null ? null : categoryCode,
    "category_name": categoryName == null ? null : categoryName,
    "category_description": categoryDescription == null ? null : categoryDescription,
  };
}
