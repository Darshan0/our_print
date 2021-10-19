// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromMap(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromMap(String str) => SubscriptionModel.fromMap(json.decode(str));

String subscriptionModelToMap(SubscriptionModel data) => json.encode(data.toMap());

class SubscriptionModel {
  SubscriptionModel({
    this.id,
    this.name,
    this.price,
    this.pageCounter,
    this.blackWhiteSingleSide,
    this.blackWhiteDoubleSide,
    this.colorSingleSide,
    this.colorDoubleSide,
    this.bondColorSingleSide,
    this.validForInMonths,
  });

  final int id;
  final String name;
  final double price;
  final int pageCounter;
  final double blackWhiteSingleSide;
  final double blackWhiteDoubleSide;
  final double colorSingleSide;
  final double colorDoubleSide;
  final double bondColorSingleSide;
  final int validForInMonths;

  factory SubscriptionModel.fromMap(Map<String, dynamic> json) => SubscriptionModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"],
    pageCounter: json["page_counter"] == null ? null : json["page_counter"],
    blackWhiteSingleSide: json["black_white_single_side"] == null ? null : json["black_white_single_side"].toDouble(),
    blackWhiteDoubleSide: json["black_white_double_side"] == null ? null : json["black_white_double_side"],
    colorSingleSide: json["color_single_side"] == null ? null : json["color_single_side"],
    colorDoubleSide: json["color_double_side"] == null ? null : json["color_double_side"].toDouble(),
    bondColorSingleSide: json["bond_color_single_side"] == null ? null : json["bond_color_single_side"].toDouble(),
    validForInMonths: json["valid_for_in_months"] == null ? null : json["valid_for_in_months"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "price": price == null ? null : price,
    "page_counter": pageCounter == null ? null : pageCounter,
    "black_white_single_side": blackWhiteSingleSide == null ? null : blackWhiteSingleSide,
    "black_white_double_side": blackWhiteDoubleSide == null ? null : blackWhiteDoubleSide,
    "color_single_side": colorSingleSide == null ? null : colorSingleSide,
    "color_double_side": colorDoubleSide == null ? null : colorDoubleSide,
    "bond_color_single_side": bondColorSingleSide == null ? null : bondColorSingleSide,
    "valid_for_in_months": validForInMonths == null ? null : validForInMonths,
  };
}
