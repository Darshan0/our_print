class PurchasedVoucherModel {
  int id;
  int client;
  String createdOn;
  bool isSingle;
  String voucherDetail;
  int cost;
  String voucherCode;
  String expiryDate;
  String image;

  PurchasedVoucherModel({
    this.id,
    this.client,
    this.createdOn,
    this.isSingle,
    this.voucherDetail,
    this.cost,
    this.expiryDate,
    this.image,
  });

  PurchasedVoucherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    client = json['client'];
    createdOn = json['created_on'];
    isSingle = json['is_single'];
    voucherDetail = json['voucher_detail'];
    voucherCode = json['voucher_code'];
    cost = json['cost'];
    expiryDate = json['expiry_date'];
    image = json['image'];
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
    data['image'] = this.image;
    return data;
  }
}
