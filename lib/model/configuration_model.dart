// To parse this JSON data, do
//
//     final configurationModel = configurationModelFromJson(jsonString);

import 'dart:convert';

ConfigurationModel configurationModelFromJson(String str) =>
    ConfigurationModel.fromMap(json.decode(str));

String configurationModelToJson(ConfigurationModel data) =>
    json.encode(data.toMap());

class ConfigurationModel {
  int id;
  String title;
  String type;
  double price;
  String priceType;
  double strikePrice;
  int perPageCount;

  ConfigurationModel(
      {this.id,
      this.title,
      this.type,
      this.price,
      this.priceType,
      this.strikePrice,
      this.perPageCount});

  factory ConfigurationModel.fromMap(Map<String, dynamic> json) =>
      ConfigurationModel(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        price: json["price"].toDouble(),
        priceType: json["price_type"],
        strikePrice: json["strike_price"],
        perPageCount: json["per_page_count"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "type": type,
        "price": price,
        "price_type": priceType,
        "strike_price": strikePrice,
        "per_page_count": perPageCount,
      };
}
