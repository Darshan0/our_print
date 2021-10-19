import 'package:flutter/material.dart';
import 'package:ourprint/utils/error_handling.dart';

class ErrorSnackBar {
  static show(context, error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(ErrorHandling.parseError(context, error).toString()),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
