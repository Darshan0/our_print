import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/data/network/api_client.dart';
import 'package:ourprint/data/network/api_endpoints.dart';
import 'package:ourprint/model/voucher_model/purchased_voucher_model.dart';
import 'package:ourprint/model/voucher_model/qrcode_model.dart';
import 'package:ourprint/model/voucher_model/user_coin_model.dart';
import 'package:ourprint/model/voucher_model/voucher_model.dart';

class VoucherRepo {
  static Future<List<QrCodeModel>> getQrCodes() async {
    final response = await apiClient.get(Api.getQRCodes) as List;
    return response.map(((data) => QrCodeModel.fromJson(data))).toList();
  }

  static Future<Map> scanQrCode(String qrCode) async {
    final response = await apiClient.get(Api.scanQRCodes, query: {
      'user_id': await Prefs.getUserId(),
      'qr_code': qrCode,
    });
    return response;
  }

  static Future<List<VoucherModel>> getAllVouchers() async {
    final response = await apiClient.get(Api.getAllVouchers) as List;
    return response.map(((data) => VoucherModel.fromJson(data))).toList();
  }

  static Future<List<PurchasedVoucherModel>> getPurchasedVouchers() async {
    final response = await apiClient.get(Api.getPurchasedVouchers, query: {
      'user_id': await Prefs.getUserId(),
    }) as List;
    return response
        .map(((data) => PurchasedVoucherModel.fromJson(data)))
        .toList();
  }

  static Future<List<UserCoinModel>> getUserCoinInfo() async {
    final response = await apiClient.get(Api.getUserCoinInfo, query: {
      'user_id': await Prefs.getUserId(),
    }) as List;
    return response.map(((data) => UserCoinModel.fromJson(data))).toList();
  }

   static Future<Map> purchaseVoucher(int voucherId) async {
    final response = await apiClient.post(Api.purchaseVoucher, {
      'user': await Prefs.getUserId(),
      'voucher': voucherId,
    });
    return response;
  }
}
