import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/firebase/firebase_token_setup.dart';
import 'flutter_local_notification.dart';

class FirebaseNotificationListener {
  static FirebaseMessaging _firebaseMessaging;

  static init() {
    _firebaseMessaging = FirebaseMessaging();
    listen();
  }

  static listen() {
    try {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showNotification(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
    } catch (e) {
      print('CANt configure');
    }
  }

  static showNotification(msg) async {
    FlutterLocalNotification().showNotification(
      msg['notification']['title'],
      msg['notification']['body'],
    );
  }

 static Future sendNotification() async {
    print('sending notification...');
    print('FCM is ');
    var fcm = await FirebaseTokenSetup.getToken();
    print(fcm);
    final String serverToken =
        "AAAAaS9o5uk:APA91bEUxvsQecB6ZjTEZMY_TF780V3FWH3IjQ05Zs0AXM8M7jyaJEm91f"
        "jDr-k6-Ia3gAIbqTJ7ZxLt7azfCNe6e13DbEKPTc7KJjPPjFtd2VvSxOuhLHLUoqyCfvT"
        "HstReg1ZKVGEj";
    await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));

    try {
      var response = await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        data: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Your order has been confirmed',
              'title': 'Our Print',
              "large_icon": "app_icon", // notification icon
              "icon": "app_icon",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': await Prefs.getUserId(),
              'status': 'done'
            },
            'to': fcm,
          },
        ),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverToken',
          },
        ),
      );
      print('Notification sent');
    } on DioError catch (e) {
      print(e.error);
      print(e.response.data);
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {}
