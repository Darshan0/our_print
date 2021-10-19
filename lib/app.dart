import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourprint/resources/theme.dart';
import 'package:ourprint/screens/splash_page/splash_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
