class UserCoinModel {
  int id;
  String createdOn;
  int coinAdded;
  int coinUsed;
  int user;
  int voucher;
  int qrCode;

  UserCoinModel({
    this.id,
    this.createdOn,
    this.coinAdded,
    this.coinUsed,
    this.user,
    this.voucher,
    this.qrCode,
  });

  UserCoinModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['created_on'];
    coinAdded = json['coin_added'];
    coinUsed = json['coin_used'];
    user = json['user'];
    voucher = json['voucher'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_on'] = this.createdOn;
    data['coin_added'] = this.coinAdded;
    data['coin_used'] = this.coinUsed;
    data['user'] = this.user;
    data['voucher'] = this.voucher;
    data['qr_code'] = this.qrCode;
    return data;
  }
}
