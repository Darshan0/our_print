// To parse this JSON data, do
//
//     final orderFileModel = orderFileModelFromMap(jsonString);

import 'dart:convert';

import 'package:ourprint/model/dependent_config_price.dart';

OrderFileModel orderFileModelFromMap(String str) =>
    OrderFileModel.fromMap(json.decode(str));

String orderFileModelToMap(OrderFileModel data) => json.encode(data.toMap());

class OrderFileModel {
  OrderFileModel(
      {this.id,
      this.pdf,
      this.title,
      this.notes,
      this.multiColorNotes,
      this.frontCoverPdf,
      this.frontCoverPdfInfo,
      this.configList,
      this.pdfPageCount,
      this.fileName,
      this.amount,
      this.numOfCopies,
      this.configurations,
      this.pageCounterUsed,
      this.exceededPageConfig});

  final int id;
  final String pdf;
  final String title;
  final String notes;
  final String multiColorNotes;
  final dynamic frontCoverPdf;
  final String frontCoverPdfInfo;
  final String configList;
  final int pdfPageCount;
  final String fileName;
  final dynamic amount;
  final int numOfCopies;
  final List<int> configurations;
  final int pageCounterUsed;
  final List<Map<String, dynamic>> exceededPageConfig;

  factory OrderFileModel.fromMap(Map<String, dynamic> json) => OrderFileModel(
        id: json["id"] == null ? null : json["id"],
        pdf: json["pdf"] == null ? null : json["pdf"],
        title: json["title"] == null ? null : json["title"],
        notes: json["notes"] == null ? null : json["notes"],
        multiColorNotes: json["multi_color_notes"] == null
            ? null
            : json["multi_color_notes"],
        frontCoverPdf: json["front_cover_pdf"],
        frontCoverPdfInfo: json["front_cover_pdf_info"] == null
            ? null
            : json["front_cover_pdf_info"],
        configList: json["config_list"] == null ? null : json["config_list"],
        pdfPageCount:
            json["pdf_page_count"] == null ? null : json["pdf_page_count"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        amount: json["amount"],
        pageCounterUsed: json["page_counter_used"],
        numOfCopies:
            json["num_of_copies"] == null ? null : json["num_of_copies"],
        configurations: json["configurations"] == null
            ? null
            : List<int>.from(json["configurations"].map((x) => x)),
        exceededPageConfig: json["exceeded_page_config"] == null ||
                json["exceeded_page_config"] == ''
            ? null
            : List<Map<String, dynamic>>.from(
                jsonDecode(json["exceeded_page_config"]).map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "pdf": pdf == null ? null : pdf,
        "title": title == null ? null : title,
        "notes": notes == null ? null : notes,
        "page_counter_used": pageCounterUsed == null ? null : pageCounterUsed,
        "multi_color_notes": multiColorNotes == null ? null : multiColorNotes,
        "front_cover_pdf": frontCoverPdf,
        "front_cover_pdf_info":
            frontCoverPdfInfo == null ? null : frontCoverPdfInfo,
        "config_list": configList == null ? null : configList,
        "pdf_page_count": pdfPageCount == null ? null : pdfPageCount,
        "file_name": fileName == null ? null : fileName,
        "amount": amount,
        "num_of_copies": numOfCopies == null ? null : numOfCopies,
        "configurations": configurations == null
            ? null
            : List<dynamic>.from(configurations.map((x) => x)),
        "exceeded_page_config": exceededPageConfig == null
            ? null
            : List<Map<String, dynamic>>.from(exceededPageConfig.map((x) => x)),
      };
}
