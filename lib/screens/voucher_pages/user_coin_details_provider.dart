import 'package:shared_preferences/shared_preferences.dart';

class UserCoinDetailsProvider {
  static final instance = UserCoinDetailsProvider._();
  UserCoinDetailsProvider._();

  Future<void> setUserCoinDetails(int coinValue) async {
    final storage = await SharedPreferences.getInstance();
    storage.setInt(_userCoinKey, coinValue);
  }

  Future<void> addUserCoinDetails(int coinValue) async {
    final totalCoinBalance =
        await UserCoinDetailsProvider.instance.getUserCoinDetails();
    final storage = await SharedPreferences.getInstance();
    storage.setInt(
      _userCoinKey,
      coinValue + totalCoinBalance,
    );
  }

  Future<void> subtractUserCoinDetails(int coinValue) async {
    final totalCoinBalance =
        await UserCoinDetailsProvider.instance.getUserCoinDetails();
    final storage = await SharedPreferences.getInstance();
    storage.setInt(
      _userCoinKey,
      totalCoinBalance - coinValue,
    );
  }

  Future<int> getUserCoinDetails() async {
    int coinBalance;
    final storage = await SharedPreferences.getInstance();
    if (storage.containsKey(_userCoinKey)) {
      coinBalance = storage.getInt(_userCoinKey);
      if (coinBalance == null) {
        coinBalance = 0;
      }
    } else {
      coinBalance = 0;
    }

    return coinBalance;
  }

  Future<void> clearUserCoinDetails() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(_userCoinKey);
  }
}

const _userCoinKey = "com.ourprint.userCoin";
