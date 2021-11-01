// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

List<GroupModel> groupModelFromJson(String str) => List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  GroupModel({
    this.groupCode,
    this.groupName,
  });

  String? groupCode;
  String? groupName;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    groupCode: json["group_code"] == null ? null : json["group_code"],
    groupName: json["group_name"] == null ? null : json["group_name"],
  );

  Map<String, dynamic> toJson() => {
    "group_code": groupCode == null ? null : groupCode,
    "group_name": groupName == null ? null : groupName,
  };
}
