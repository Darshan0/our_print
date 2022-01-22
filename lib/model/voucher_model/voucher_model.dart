class VoucherModel {
  int id;
  int client;
  String createdOn;
  bool isSingle;
  String voucherDetail;
  int cost;
  String expiryDate;
  List<Vouchers> vouchers;
  String image;

  VoucherModel({
    this.id,
    this.client,
    this.createdOn,
    this.isSingle,
    this.voucherDetail,
    this.cost,
    this.expiryDate,
    this.vouchers,
    this.image,
  });

  VoucherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    client = json['client'];
    createdOn = json['created_on'];
    isSingle = json['is_single'];
    voucherDetail = json['voucher_detail'];
    cost = json['cost'];
    expiryDate = json['expiry_date'];
    if (json['vouchers'] != null) {
      vouchers = [];
      json['vouchers'].forEach((v) {
        vouchers.add(new Vouchers.fromJson(v));
      });
    }
    image = json['image'] != null ? json['image'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client'] = this.client;
    data['created_on'] = this.createdOn;
    data['is_single'] = this.isSingle;
    data['voucher_detail'] = this.voucherDetail;
    data['cost'] = this.cost;
    data['expiry_date'] = this.expiryDate;
    if (this.vouchers != null) {
      data['vouchers'] = this.vouchers.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    return data;
  }
}

class Vouchers {
  int id;
  String createdOn;
  bool isAssigned;
  String voucherCode;
  bool isActive;
  int voucherInfoId;

  Vouchers({
    this.id,
    this.createdOn,
    this.isAssigned,
    this.voucherCode,
    this.isActive,
    this.voucherInfoId,
  });

  Vouchers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['created_on'];
    isAssigned = json['is_assigned'];
    voucherCode = json['voucher_code'];
    isActive = json['is_active'];
    voucherInfoId = json['voucherInfoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_on'] = this.createdOn;
    data['is_assigned'] = this.isAssigned;
    data['voucher_code'] = this.voucherCode;
    data['is_active'] = this.isActive;
    data['voucherInfoId'] = this.voucherInfoId;
    return data;
  }
}
