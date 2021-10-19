import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ourprint/data/local/shared_prefs.dart';

class FirebaseTokenSetup {
  static init() async {
    final token = await FirebaseMessaging().getToken();
    print('my token is $token');
    await _sendTokenToServer(token);
  }

  static Future<String> getToken() async {
    final token = await FirebaseMessaging().getToken();
    return token;
  }

  static _sendTokenToServer(String token) async {
    final userId = await Prefs.getUserId();
    final child = {'$userId': token};
    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child('fcm_tokens')
        .update(child)
        .catchError((err) {
      print('errrrrrrrrrrrr');
      print(err);
    }).then((value) {
      print('successfully sent token');
    });
  }
}
