import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlViewer extends StatefulWidget {
  final String url;

  final String title;

  const HtmlViewer({Key key, this.url, this.title}) : super(key: key);

  static open(context, String url, String title) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewer(url: url, title: title),
        ),
      );

  @override
  _HtmlViewerState createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  @override
  void initState() {
    super.initState();
  }

  WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: widget.url,
        onWebViewCreated: (contr) {
          webViewController = contr;
        },
      ),
    );
  }
}
