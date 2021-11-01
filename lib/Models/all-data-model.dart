// To parse this JSON data, do
//
//     final allDataModel = allDataModelFromJson(jsonString);

import 'dart:convert';

AllDataModel allDataModelFromJson(String str) => AllDataModel.fromJson(json.decode(str));

String allDataModelToJson(AllDataModel data) => json.encode(data.toJson());

class AllDataModel {
  AllDataModel({
    this.status,
    this.data,
    this.meta,
  });

  int? status;
  List<Datum>? data;
  Meta? meta;

  factory AllDataModel.fromJson(Map<String, dynamic> json) => AllDataModel(
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
    this.itemCode,
    this.type,
    this.status,
    // this.itemName,
    this.item,
    this.description,
    this.location,
    this.parts,
    this.diagnoses,
    this.treatments,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? itemCode;
  int? type;
  int? status;
  // String? itemName;
  Item? item;
  String? description;
  Location? location;
  List<Treatments>? parts;
  List<Treatments>? diagnoses;
  Treatments? treatments;
  List<Image>? images;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    itemCode: json["item_code"] == null ? null : json["item_code"],
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    // itemName: json["item_name"] == null ? null : json["item_name"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    description: json["description"] == null ? null : json["description"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    parts: json["parts"] == null ? null : List<Treatments>.from(json["parts"].map((x) => Treatments.fromJson(x))),
    diagnoses: json["diagnoses"] == null ? null : List<Treatments>.from(json["diagnoses"].map((x) => Treatments.fromJson(x))),
    treatments: json["treatments"] == null ? null : Treatments.fromJson(json["treatments"]),
    images: json["images"] == null ? null : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "item_code": itemCode == null ? null : itemCode,
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    // "item_name": itemName == null ? null : itemName,
    "item": item == null ? null : item!.toJson(),
    "description": description == null ? null : description,
    "location": location == null ? null : location!.toJson(),
    "parts": parts == null ? null : List<dynamic>.from(parts!.map((x) => x.toJson())),
    "diagnoses": diagnoses == null ? null : List<dynamic>.from(diagnoses!.map((x) => x.toJson())),
    "treatments": treatments == null ? null : treatments!.toJson(),
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class Item {
  Item({
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

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
    id: json["id"],
    categoryCode: json["category_code"] == null ? null : json["category_code"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    categoryDescription: json["category_description"] == null ? null : json["category_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_code": categoryCode == null ? null : categoryCode,
    "category_name": categoryName == null ? null : categoryName,
    "category_description": categoryDescription == null ? null : categoryDescription,
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

class Treatments {
  Treatments({
    this.id,
    // this.tagId,
    // this.userId,
    this.diagnosis,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.partName,
    this.treatment,
  });

  int? id;
  // int? tagId;
  // int? userId;
  String? diagnosis;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  String? partName;
  String? treatment;

  factory Treatments.fromJson(Map<String, dynamic> json) => Treatments(
    id: json["id"] == null ? null : json["id"],
    // tagId: json["tag_id"] == null ? null : json["tag_id"],
    // userId: json["user_id"] == null ? null : json["user_id"],
    diagnosis: json["diagnosis"] == null ? null : json["diagnosis"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    partName: json["part_name"] == null ? null : json["part_name"],
    treatment: json["treatment"] == null ? null : json["treatment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    // "tag_id": tagId == null ? null : tagId,
    // "user_id": userId == null ? null : userId,
    "diagnosis": diagnosis == null ? null : diagnosis,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "user": user == null ? null : user!.toJson(),
    "part_name": partName == null ? null : partName,
    "treatment": treatment == null ? null : treatment,
  };
}

class User {
  User({
    this.id,
    this.username,
    this.name,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? username;
  String? name;
  int? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    name: json["name"] == null ? null : json["name"],
    role: json["role"] == null ? null : json["role"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "name": name == null ? null : name,
    "role": role == null ? null : role,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class Image {
  Image({
    this.id,
    this.tagId,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? tagId;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"] == null ? null : json["id"],
    tagId: json["tag_id"] == null ? null : json["tag_id"],
    url: json["url"] == null ? null : json["url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "tag_id": tagId == null ? null : tagId,
    "url": url == null ? null : url,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class Location {
  Location({
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

  factory Location.fromJson(Map<String, dynamic> json) => Location(
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
