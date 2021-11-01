// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserDetail userFromJson(String str) => UserDetail.fromJson(json.decode(str));

String userToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  UserDetail({
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

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
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
