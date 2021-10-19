import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/model/user_profile_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class UserRepo {
  static requestOTP(String mobile) async {
    final appSignature = await SmsAutoFill().getAppSignature;
    var body = {'mobile': mobile, 'app_signature': appSignature};
    return apiClient.post(Api.requestOtp, body);
  }

  static verifyOTP(Map body) async {
    final response = await await apiClient.post(Api.verifyOtp, body);
    return UserProfileModel.fromMap(response);
  }

  static register(Map body) async {
    final response = await apiClient.post(Api.register, body);
    return UserProfileModel.fromMap(response);
  }

  static Future<UserProfileModel> getProfile(int id) async {
    final response = await apiClient.get(Api.users + id.toString());
    return UserProfileModel.fromMap(response);
  }

  static editProfile(body) async {
    final response =
        await apiClient.patch('${Api.users}${await Prefs.getUserId()}/', body);
    return UserProfileModel.fromMap(response);
  }

  static Future isFreemiumAvailable() async {
    return apiClient.get(Api.isFreemium);
  }

  static Future<List<OrderModel>> getFreemiumUsage(isFreemium) async {
    final response = await apiClient.get(Api.orders, query: {
      'user': await Prefs.getUserId(),
      'is_freemium': isFreemium,
      'is_payment_complete': 'True',
    }) as List;
    return response.map(((data) => OrderModel.fromMap(data))).toList();
  }

  static sendEmailForVerification() async {
    return await apiClient.post(
        Api.emailVerification, {'user_email': await Prefs.getUserEmail()});
  }

  static Future getTotalPrints() async {
    return await apiClient.get(
      Api.userTotalPrints,
      query: {'user': await Prefs.getUserId()},
    );
  }
}
