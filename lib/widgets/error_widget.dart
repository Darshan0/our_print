import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/utils/error_handling.dart';

class CustomErrorWidget extends StatefulWidget {
  final error;
  final bool _simple;
  final Function refreshRequest;
  final Function repoFunction;

  const CustomErrorWidget(
      {Key key, @required this.error, this.refreshRequest, this.repoFunction})
      : _simple = false,
        super(key: key);

  const CustomErrorWidget.simple(
      {Key key, @required this.error, this.refreshRequest, this.repoFunction})
      : _simple = true,
        super(key: key);

  @override
  _CustomErrorWidgetState createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (widget._simple)
      return Material(
        child: Text(
          ErrorHandling.parseError(context, widget.error),
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14),
        ),
      );
    var error = ErrorHandling.parseError(context, widget.error);
    return Material(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: widget.error is DioError &&
                  widget.error.type == DioErrorType.DEFAULT
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(Images.noInternet),
                    SizedBox(height: 25),
                    Text('Bad Connection', style: textTheme.headline),
                    SizedBox(height: 20),
                    Text(
                      'There seems to be a problem with internet.'
                      '\nCheck Your connection and try again.',
                      style: textTheme.caption,
                    ),
                    SizedBox(height: 28),
                    RaisedButton(
                      onPressed: () async {
                        try {
                          HomePage.openAndRemoveUntil(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('RETRY'),
                    )
                  ],
                )
              : error is String
                  ? Text(
                      ErrorHandling.parseError(context, widget.error),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: 18),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        SizedBox(height: 50),
                        Text('Page not found', style: textTheme.headline),
                        SizedBox(height: 50),
                      ],
                    ),
        ),
      ),
    );
  }
}
