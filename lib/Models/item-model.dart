// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
  ItemModel({
    this.status,
    this.data,
    this.meta,
  });

  int? status;
  List<Data>? data;
  Meta? meta;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta == null ? null : meta!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.itemCode,
    this.itemName,
    this.itemAlias,
    this.category,
    this.brand,
    this.group,
  });

  int? id;
  String? itemCode;
  String? itemName;
  String? itemAlias;
  Category? category;
  Brand? brand;
  Group? group;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    itemCode: json["item_code"] == null ? null : json["item_code"],
    itemName: json["item_name"] == null ? null : json["item_name"],
    itemAlias: json["item_alias"] == null ? null : json["item_alias"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
    group: json["group"] == null ? null : Group.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "item_code": itemCode == null ? null : itemCode,
    "item_name": itemName == null ? null : itemName,
    "item_alias": itemAlias == null ? null : itemAlias,
    "category": category == null ? null : category!.toJson(),
    "brand": brand == null ? null : brand!.toJson(),
    "group": group == null ? null : group!.toJson(),
  };
}

class Brand {
  Brand({
    this.id,
    this.brandCode,
    this.brandName,
  });

  int? id;
  String? brandCode;
  String? brandName;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"] == null ? null : json["id"],
    brandCode: json["brand_code"] == null ? null : json["brand_code"],
    brandName: json["brand_name"] == null ? null : json["brand_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "brand_code": brandCode == null ? null : brandCode,
    "brand_name": brandName == null ? null : brandName,
  };
}

class Category {
  Category({
    this.id,
    this.categoryCode,
    this.categoryName,
    this.categoryDescription,
  });

  int? id;
  String? categoryCode;
  String? categoryName;
  String? categoryDescription;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    categoryCode: json["category_code"] == null ? null : json["category_code"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    categoryDescription: json["category_description"] == null ? null : json["category_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "category_code": categoryCode == null ? null : categoryCode,
    "category_name": categoryName == null ? null : categoryName,
    "category_description": categoryDescription == null ? null : categoryDescription,
  };
}

class Group {
  Group({
    this.id,
    this.groupCode,
    this.groupName,
  });

  int? id;
  String? groupCode;
  String? groupName;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"] == null ? null : json["id"],
    groupCode: json["group_code"] == null ? null : json["group_code"],
    groupName: json["group_name"] == null ? null : json["group_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "group_code": groupCode == null ? null : groupCode,
    "group_name": groupName == null ? null : groupName,
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
