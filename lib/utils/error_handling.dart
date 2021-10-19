import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/screens/login_page/login.dart';
import 'package:ourprint/screens/splash_page/splash_page.dart';

class ErrorHandling {
  static parseError(BuildContext context, error) {
    try {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.RESPONSE:
            if (error.response.statusCode == 400) {
              Map<String, dynamic> map = error.response.data;
              var entry = map.entries.first;
              return '${entry.key} : ${entry.value.first}';
            } else if (error.response.statusCode == 422) {
              return error.response.data['error'];
            } else if (error.response.statusCode == 401) {
              Prefs.clearPrefs()
                  .then((_) => _showTokenExpiredDialog(context))
                  .catchError((e) => print(e));
              return 'Token Expired';
            } else if (error.response.statusCode == 404) {
              return 'Page not found';
            }
            return error.message;
          default:
            return error.message;
        }
      }
    } catch (e) {
      return 'Unknown error!';
    }
    return error?.toString() ?? 'Unknown error!';
  }

  static void _showTokenExpiredDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            content: Text('Your token has expired. Please login again.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => LoginPage.openAndRemoveUntil(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
