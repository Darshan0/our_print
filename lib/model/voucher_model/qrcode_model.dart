class QrCodeModel {
  int id;
  String code;
  String generatedDate;
  double value;
  String validity;
  String company;
  double count;
  String image;
  String redirectionUrl;
  bool isActive;

  QrCodeModel({
    this.id,
    this.code,
    this.generatedDate,
    this.value,
    this.validity,
    this.company,
    this.count,
    this.image,
    this.redirectionUrl,
    this.isActive,
  });

  QrCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    generatedDate = json['generated_date'];
    value = json['value'];
    validity = json['validity'];
    company = json['company'];
    count = json['count'];
    image = json['image'];
    redirectionUrl = json['redirection_url'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['generated_date'] = this.generatedDate;
    data['value'] = this.value;
    data['validity'] = this.validity;
    data['company'] = this.company;
    data['count'] = this.count;
    data['image'] = this.image;
    data['redirection_url'] = this.redirectionUrl;
    data['is_active'] = this.isActive;
    return data;
  }
}
