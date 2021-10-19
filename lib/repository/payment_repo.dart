import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';

class PaymentRepo{
  static verifyPayment(Map body)async{
    var response = await apiClient.post(Api.verifyPayment, body);
    return response;
  }
  static verifySubscriptionPayment(Map body)async{
    var response = await apiClient.post(Api.verifySubscriptionPayment, body);
    return response;
  }
}