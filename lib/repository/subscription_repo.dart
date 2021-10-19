import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/subscription_model.dart';
import 'package:ourprint/model/user_subscription_model.dart';

class SubscriptionRepo {
  static Future<List<SubscriptionModel>> getSubscriptions() async {
    var response = await apiClient.get(Api.subscriptionPlans) as List;
    return response.map((e) => SubscriptionModel.fromMap(e)).toList();
  }

  static Future<UserSubscriptionModel> checkIfSubscribed() async {
    var response = await apiClient.get(Api.haveSubscription);
    return UserSubscriptionModel.fromMap(response);
  }

  static Future createSubscriptionPlan(body) async {
    var response = await apiClient.post(Api.userSubscriptionPlans, body);
    return response;
  }

  static Future changePageCounter(counter, int subsPlanId) async {
    var response =
        await apiClient.patch(Api.userSubscriptionPlans + '$subsPlanId/', {
      'page_left': counter,
    });
    return response;
  }
}
