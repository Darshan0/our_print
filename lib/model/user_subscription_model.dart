// To parse this JSON data, do
//
//     final userSubscriptionModel = userSubscriptionModelFromMap(jsonString);

import 'dart:convert';

UserSubscriptionModel userSubscriptionModelFromMap(String str) =>
    UserSubscriptionModel.fromMap(json.decode(str));

String userSubscriptionModelToMap(UserSubscriptionModel data) =>
    json.encode(data.toMap());

class UserSubscriptionModel {
  UserSubscriptionModel({
    this.success,
    this.userSubscriptionId,
    this.haveSubscription,
    this.subscription,
    this.expireOn,
    this.createdAt,
    this.pageLeft,
  });

  final int userSubscriptionId;
  final bool success;
  final bool haveSubscription;
  final Subscription subscription;
  final DateTime expireOn;
  final DateTime createdAt;
  final int pageLeft;

  factory UserSubscriptionModel.fromMap(Map<String, dynamic> json) =>
      UserSubscriptionModel(
        success: json["success"] == null ? null : json["success"],
        userSubscriptionId: json["user_subscription_id"] == null
            ? null
            : json["user_subscription_id"],
        haveSubscription: json["have_subscription"] == null
            ? null
            : json["have_subscription"],
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromMap(json["subscription"]),
        expireOn: json["expire_on"] == null
            ? null
            : DateTime.parse(json["expire_on"]),
        pageLeft: json["page_left"] == null ? null : json["page_left"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "user_subscription_id":
            userSubscriptionId == null ? null : userSubscriptionId,
        "have_subscription": haveSubscription == null ? null : haveSubscription,
        "subscription": subscription == null ? null : subscription.toMap(),
        "expire_on": expireOn == null ? null : expireOn.toIso8601String(),
        "page_left": pageLeft == null ? null : pageLeft,
        "created_at": createdAt == null ? null : createdAt,
      };
}

class Subscription {
  Subscription({
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
  final String price;
  final int pageCounter;
  final double blackWhiteSingleSide;
  final double blackWhiteDoubleSide;
  final double colorSingleSide;
  final double colorDoubleSide;
  final double bondColorSingleSide;
  final int validForInMonths;

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        pageCounter: json["page_counter"] == null ? null : json["page_counter"],
        blackWhiteSingleSide: json["black_white_single_side"] == null
            ? null
            : double.parse(json["black_white_single_side"]),
        blackWhiteDoubleSide: json["black_white_double_side"] == null
            ? null
            : double.parse(json["black_white_double_side"]),
        colorSingleSide: json["color_single_side"] == null
            ? null
            : double.parse(json["color_single_side"]),
        colorDoubleSide: json["color_double_side"] == null
            ? null
            : double.parse(json["color_double_side"]),
        bondColorSingleSide: json["bond_color_single_side"] == null
            ? null
            : double.parse(json["bond_color_single_side"]),
        validForInMonths: json["valid_for_in_months"] == null
            ? null
            : json["valid_for_in_months"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "page_counter": pageCounter == null ? null : pageCounter,
        "black_white_single_side":
            blackWhiteSingleSide == null ? null : blackWhiteSingleSide,
        "black_white_double_side":
            blackWhiteDoubleSide == null ? null : blackWhiteDoubleSide,
        "color_single_side": colorSingleSide == null ? null : colorSingleSide,
        "color_double_side": colorDoubleSide == null ? null : colorDoubleSide,
        "bond_color_single_side":
            bondColorSingleSide == null ? null : bondColorSingleSide,
        "valid_for_in_months":
            validForInMonths == null ? null : validForInMonths,
      };
}
