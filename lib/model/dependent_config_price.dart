// To parse this JSON data, do
//
//     final dependentConfigPrice = dependentConfigPriceFromMap(jsonString);

import 'dart:convert';

DependentConfigPrice dependentConfigPriceFromMap(String str) => DependentConfigPrice.fromMap(json.decode(str));

String dependentConfigPriceToMap(DependentConfigPrice data) => json.encode(data.toMap());

class DependentConfigPrice {
  DependentConfigPrice({
    this.success,
    this.blackWhiteSingleSide,
    this.blackWhiteSingleSideStrike,
    this.blackWhiteDoubleSide,
    this.blackWhiteDoubleSideStrike,
    this.colorSingleSide,
    this.colorSingleSideStrike,
    this.colorDoubleSide,
    this.colorDoubleSideStrike,
  });

  final bool success;
  final double blackWhiteSingleSide;
  final double blackWhiteSingleSideStrike;
  final double blackWhiteDoubleSide;
  final double blackWhiteDoubleSideStrike;
  final double colorSingleSide;
  final double colorSingleSideStrike;
  final double colorDoubleSide;
  final double colorDoubleSideStrike;

  factory DependentConfigPrice.fromMap(Map<String, dynamic> json) => DependentConfigPrice(
    success: json["success"] == null ? null : json["success"],
    blackWhiteSingleSide: json["black_white_single_side"] == null ? null : json["black_white_single_side"].toDouble(),
    blackWhiteSingleSideStrike: json["black_white_single_side_strike"] == null ? null : json["black_white_single_side_strike"].toDouble(),
    blackWhiteDoubleSide: json["black_white_double_side"] == null ? null : json["black_white_double_side"].toDouble(),
    blackWhiteDoubleSideStrike: json["black_white_double_side_strike"] == null ? null : json["black_white_double_side_strike"],
    colorSingleSide: json["color_single_side"] == null ? null : json["color_single_side"],
    colorSingleSideStrike: json["color_single_side_strike"] == null ? null : json["color_single_side_strike"],
    colorDoubleSide: json["color_double_side"] == null ? null : json["color_double_side"],
    colorDoubleSideStrike: json["color_double_side_strike"] == null ? null : json["color_double_side_strike"],
  );

  Map<String, dynamic> toMap() => {
    "success": success == null ? null : success,
    "black_white_single_side": blackWhiteSingleSide == null ? null : blackWhiteSingleSide,
    "black_white_single_side_strike": blackWhiteSingleSideStrike == null ? null : blackWhiteSingleSideStrike,
    "black_white_double_side": blackWhiteDoubleSide == null ? null : blackWhiteDoubleSide,
    "black_white_double_side_strike": blackWhiteDoubleSideStrike == null ? null : blackWhiteDoubleSideStrike,
    "color_single_side": colorSingleSide == null ? null : colorSingleSide,
    "color_single_side_strike": colorSingleSideStrike == null ? null : colorSingleSideStrike,
    "color_double_side": colorDoubleSide == null ? null : colorDoubleSide,
    "color_double_side_strike": colorDoubleSideStrike == null ? null : colorDoubleSideStrike,
  };
}
