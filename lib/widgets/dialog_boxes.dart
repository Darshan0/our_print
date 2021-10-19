import 'package:flutter/material.dart';
import 'package:ourprint/utils/error_handling.dart';
import 'image_from_net.dart';

class DialogBox {
  static Future showSuccessDialog(context, msg) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(msg),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  static Future showErrorDialog(context, e) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(e),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  static Future parseAndShowErrorDialog(context, e) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(ErrorHandling.parseError(context, e)),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}
