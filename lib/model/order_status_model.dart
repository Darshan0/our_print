// To parse this JSON data, do
//
//     final orderStatusModel = orderStatusModelFromJson(jsonString);

import 'dart:convert';

OrderStatusModel orderStatusModelFromJson(String str) => OrderStatusModel.fromMap(json.decode(str));

String orderStatusModelToJson(OrderStatusModel data) => json.encode(data.toMap());

class OrderStatusModel {
  int id;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int order;
  int user;

  OrderStatusModel({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.user,
  });

  factory OrderStatusModel.fromMap(Map<String, dynamic> json) => OrderStatusModel(
    id: json["id"] == null ? null : json["id"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    order: json["order"] == null ? null : json["order"],
    user: json["user"] == null ? null : json["user"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "order": order == null ? null : order,
    "user": user == null ? null : user,
  };
}
