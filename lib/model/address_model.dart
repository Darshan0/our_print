// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromMap(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toMap());

class AddressModel {
  int id;
  String addressLine1;
  String addressLine2;
  String landmark;
  String city;
  String pinCode;
  String state;
  String alternateMob;
  dynamic addressName;
  int user;

  AddressModel({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.pinCode,
    this.state,
    this.alternateMob,
    this.addressName,
    this.user,
  });

  factory AddressModel.fromMap(Map<String, dynamic> json) => AddressModel(
        id: json["id"] == null ? null : json["id"],
        addressLine1:
            json["address_line1"] == null ? null : json["address_line1"],
        addressLine2:
            json["address_line2"] == null ? null : json["address_line2"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        city: json["city"] == null ? null : json["city"],
        pinCode: json["pin_code"] == null ? null : json["pin_code"],
        state: json["state"] == null ? null : json["state"],
        alternateMob:
            json["alternate_number"] == null ? null : json["alternate_number"],
        addressName: json["address_name"],
        user: json["user"] == null ? null : json["user"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "address_line1": addressLine1 == null ? null : addressLine1,
        "address_line2": addressLine2 == null ? null : addressLine2,
        "landmark": landmark == null ? null : landmark,
        "city": city == null ? null : city,
        "pin_code": pinCode == null ? null : pinCode,
        "state": state == null ? null : state,
        "alternate_number": alternateMob == null ? null : alternateMob,
        "address_name": addressName,
        "user": user == null ? null : user,
      };
}
