import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification {
  initNotificationPlugin() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notification.initialize(initializationSettings);
  }

  FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();
  var androidPlatform = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: BigTextStyleInformation(''),
  );
  var iosPlatform = IOSNotificationDetails();

  showNotification(title, body) async {
    var hybridPlatform =
        NotificationDetails(android: androidPlatform, iOS: iosPlatform);
    await initNotificationPlugin();
    notification.show(
      1,
      title,
      body,
      hybridPlatform,
    );
  }
}
