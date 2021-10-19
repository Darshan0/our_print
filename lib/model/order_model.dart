// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'dependent_config_price.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromMap(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toMap());

class OrderModel {
  int id;
  String status;
  double amount;
  dynamic pdf;
  String title;
  String notes;
  String multiColorNotes;
  dynamic frontCoverPdf;
  var deliveryCharge;
  String priceList;
  int pdfPageCount;
  DateTime createdAt;
  DateTime deliveryDate;
  String fileName;
  bool isFreemium;
  int user;
  int address;
  List<int> configurations;
  String pageConfig;
  String frontCoverPDFInfo;
  String orderId;
  String orderType;
  String configList;
  String deliveryId;
  List<int> orderFiles;
  final DependentConfigPrice dependentConfigPrice;
  final int totalPages;
  final int pageCounterUsed;
  final String trackUrl;

  OrderModel(
      {this.id,
      this.status,
      this.amount,
      this.pdf,
      this.title,
      this.notes,
      this.multiColorNotes,
      this.frontCoverPdf,
      this.deliveryCharge,
      this.priceList,
      this.pdfPageCount,
      this.createdAt,
      this.deliveryDate,
      this.fileName,
      this.isFreemium,
      this.user,
      this.address,
      this.configurations,
      this.pageConfig,
      this.frontCoverPDFInfo,
      this.orderId,
      this.orderType,
      this.configList,
      this.deliveryId,
      this.orderFiles,
      this.dependentConfigPrice,
      this.totalPages,
      this.pageCounterUsed,
      this.trackUrl});

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
      id: json["id"] == null ? null : json["id"],
      status: json["status"] == null ? null : json["status"],
      amount: json["amount"] == null ? null : json["amount"].toDouble(),
      pdf: json["pdf"] == null ? null : json["pdf"],
      title: json["title"] == null ? null : json["title"],
      notes: json["notes"] == null ? null : json["notes"],
      multiColorNotes:
          json["multi_color_notes"] == null ? null : json["multi_color_notes"],
      frontCoverPdf:
          json["front_cover_pdf"] == null ? null : json["front_cover_pdf"],
      deliveryCharge:
          json["delivery_charge"] == null ? null : json["delivery_charge"],
      priceList: json["price_list"] == null ? null : json["price_list"],
      pdfPageCount:
          json["pdf_page_count"] == null ? null : json["pdf_page_count"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      deliveryDate: json["delivery_date"] == null
          ? null
          : DateTime.parse(json["delivery_date"]),
      fileName: json["file_name"] == null ? null : json["file_name"],
      isFreemium: json["is_freemium"] == null ? null : json["is_freemium"],
      user: json["user"] == null ? null : json["user"],
      address: json["address"] == null ? null : json["address"],
      configurations: json["configurations"] == null
          ? null
          : List<int>.from(json["configurations"].map((x) => x)),
      orderFiles: json["order_files"] == null
          ? null
          : List<int>.from(json["order_files"].map((x) => x)),
      pageConfig: json["page_config"] == null ? null : json["page_config"],
      frontCoverPDFInfo: json["front_cover_pdf_info"] == null
          ? null
          : json["front_cover_pdf_info"],
      orderId: json["order_id"] == null ? null : json["order_id"],
      orderType: json["order_type"] == null ? null : json["order_type"],
      configList: json["config_list"] == null ? null : json["config_list"],
      deliveryId: json["delivery_id"] == null ? null : json["delivery_id"],
      totalPages: json["total_pages"] == null ? null : json["total_pages"],
      trackUrl: json["track_url"] == null ? null : json["track_url"],
      pageCounterUsed:
          json["page_counter_used"] == null ? null : json["page_counter_used"],
      dependentConfigPrice: json["dependent_page_config"] == null
          ? null
          : DependentConfigPrice.fromMap(
              jsonDecode(json["dependent_page_config"])));

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "status": status == null ? null : status,
        "amount": amount == null ? null : amount,
        "pdf": pdf == null ? null : pdf,
        "title": title == null ? null : title,
        "notes": notes == null ? null : notes,
        "multi_color_notes": multiColorNotes == null ? null : multiColorNotes,
        "front_cover_pdf": frontCoverPdf == null ? null : frontCoverPdf,
        "delivery_charge": deliveryCharge == null ? null : deliveryCharge,
        "price_list": priceList == null ? null : priceList,
        "pdf_page_count": pdfPageCount == null ? null : pdfPageCount,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "delivery_date":
            deliveryDate == null ? null : deliveryDate.toIso8601String(),
        "file_name": fileName == null ? null : fileName,
        "is_freemium": isFreemium == null ? null : isFreemium,
        "user": user == null ? null : user,
        "address": address == null ? null : address,
        "page_config": pageConfig == null ? null : pageConfig,
        "front_cover_pdf_info":
            frontCoverPDFInfo == null ? null : frontCoverPDFInfo,
        "order_id": orderId == null ? null : orderId,
        "order_type": orderType == null ? null : orderType,
        "config_list": configList == null ? null : configList,
        "delivery_id": deliveryId == null ? null : deliveryId,
        "total_pages": totalPages == null ? null : totalPages,
        "track_url": trackUrl == null ? null : trackUrl,
        "configurations": configurations == null
            ? null
            : List<dynamic>.from(configurations.map((x) => x)),
        "order_files": orderFiles == null
            ? null
            : List<dynamic>.from(orderFiles.map((x) => x)),
        "dependent_page_config":
            dependentConfigPrice == null ? null : dependentConfigPrice,
        "page_counter_used": pageCounterUsed == null ? null : pageCounterUsed,
      };

  OrderModel add(
      {OrderModel model,
      int id,
      int user,
      double amount,
      String title,
      dynamic configurations,
      String notes,
      int address,
      dynamic pdf,
      String multiColorNotes,
      dynamic frontCoverPDF,
      int pdfPageCount,
      dynamic priceList,
      String status,
      String createdAt,
      DateTime deliveryDate,
      String fileName,
      bool isFreemium,
      String pageConfig,
      var deliveryCharges,
      String frontCoverPdfInfo,
      String orderType,
      List<int> orderFiles,
      String configList}) {
    return OrderModel.fromMap({
      "id": id ?? model?.id,
      "user": model?.user ?? user,
      "amount": model?.amount ?? amount,
      "title": model?.title ?? title,
      "configurations": configurations ?? model?.configurations,
      "notes": model?.notes ?? notes,
      "address": model?.address ?? address,
      "pdf": pdf ?? model?.pdf,
      "multi_color_notes": model?.multiColorNotes ?? multiColorNotes,
      "front_cover_pdf": frontCoverPDF ?? model?.frontCoverPdf,
      "pdf_page_count": model?.pdfPageCount ?? pdfPageCount,
      "price_list": model?.priceList ?? priceList,
      "status": model?.status ?? status,
      "id": model?.id,
      "created_at": model?.createdAt,
      "delivery_date": model?.deliveryDate ?? deliveryDate,
      "file_name": model?.fileName ?? fileName,
      "is_freemium": model?.isFreemium ?? isFreemium,
      "page_config": model?.pageConfig ?? pageConfig,
      "delivery_charge": model?.deliveryCharge ?? deliveryCharges,
      "front_cover_pdf_info": model?.frontCoverPDFInfo ?? frontCoverPdfInfo,
      "order_type": model?.orderType ?? orderType,
      "config_list": model?.configList ?? configList,
      "order_files": model?.orderFiles ?? orderFiles,
    });
  }
}
