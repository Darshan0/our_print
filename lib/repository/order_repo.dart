import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/order_file_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/model/order_status_model.dart';

class OrderRepo {
  static createOrder(Map body) async {
    var response = await apiClient
        .post('${Api.orders}', body, query: {'is_payment_complete': 'False'});
    return response;
  }

  static createSubscriptionOrder(body, {@required isPaid}) async {
    body.addAll({'is_payment_complete': isPaid});
    var response = await apiClient
        .post('${Api.orders}', body, query: {'is_payment_complete': 'False'});
    return response;
  }

  static Future<OrderModel> uploadPDF(body, ProgressCallback onProgress) async {
    var response = await apiClient.postProgress(Api.orderFiles, body,
        onProgress: onProgress);
    return OrderModel.fromMap(response);
  }

  static Future<OrderModel> addPDF(
      int id, body, ProgressCallback onProgress) async {
    var response = await apiClient.patchProgress(
      '${Api.orderFiles}$id/',
      body,
      query: {'is_payment_complete': 'False'},
      onProgress: onProgress,
    );
    return OrderModel.fromMap(response);
  }

  static Future<OrderModel> updatePDFDetails(int id, body) async {
    var response = await apiClient.patch(
      '${Api.orderFiles}$id/',
      body,
      query: {'is_payment_complete': 'False'},
    );
    return OrderModel.fromMap(response);
  }

  static Future<List<OrderModel>> getOrders() async {
    var response = await apiClient.get(Api.orders, query: {
      'user': await Prefs.getUserId(),
      'exclude_status': 'incomplete',
      'is_payment_complete': 'True',
    }) as List;
    return response.map((data) => OrderModel.fromMap(data)).toList();
  }

  static Future<OrderFileModel> getOrderFile(int orderFileId) async {
    var response = await apiClient.get(Api.orderFiles + '/$orderFileId');
    return OrderFileModel.fromMap(response);
  }

  static Future getOrderDeliveryCharges(body) async {
    var response = await apiClient.post(Api.getDeliveryCharges, body);
    return response;
  }

  static Future<List<OrderStatusModel>> getOrdersStatus(int orderId) async {
    var response = await apiClient.get(Api.ordersStatus, query: {
      'user': await Prefs.getUserId(),
      'order': orderId,
    }) as List;
    return response.map((data) => OrderStatusModel.fromMap(data)).toList();
  }

  static getSpiralBindingCharges(Map body) async {
    var response = await apiClient.post(Api.getSpiralBindingCharges, body);
    return response;
  }

  static Future uploadPdf(body) async {
    var response = await apiClient.post(Api.orderFiles, body);
    return response;
  }

  static Future<OrderModel> getOrder(orderId) async {
    var response = await apiClient.get(Api.orders + '$orderId/', query: {
      'is_payment_complete': 'False',
    });
    return OrderModel.fromMap(response);
  }
}
