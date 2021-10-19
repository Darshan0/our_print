import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/address_model.dart';

class AddressRepo {
  static addAddress(AddressModel model) async {
    var response = await apiClient.post(Api.addAddress, model.toMap());
    return response;
  }

  static editAddress(AddressModel model) async {
    var response = await apiClient.post(
      Api.editAddress,
      model.toMap(),
    );
    return response;
  }

  static Future<List<AddressModel>> getAddress() async {
    var response = await apiClient
        .get(Api.addresses, query: {'user': await Prefs.getUserId()});
    var list = response['results'] as List;
    return list.map((data) => AddressModel.fromMap(data)).toList();
  }

  static Future<List> getStates() async {
    return await apiClient.get(Api.states);
  }

  static Future<List> getPinCodes() async {
    var response = await apiClient.get(Api.pinCodes) as List;
    return response.map((e) => e['pin_code']).toList();
  }

  static Future deleteAddress(int id) async {
    return await apiClient.delete(Api.addresses + '$id/');
  }
}
