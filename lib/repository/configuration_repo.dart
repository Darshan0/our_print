import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/dependent_config_price.dart';

class ConfigurationsRepo {
  static Future<List<ConfigurationModel>> getConfigs() async {
    var response = await apiClient.get(Api.configurations) as List;
    return response.map((data) => ConfigurationModel.fromMap(data)).toList();
  }

  static Future<DependentConfigPrice> getDependentConfigPrice() async {
    var response = await apiClient.get(Api.getDependentConfigPrice);
    return DependentConfigPrice.fromMap(response);
  }
}
