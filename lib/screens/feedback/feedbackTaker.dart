import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedbackTaker extends StatelessWidget {
  final String url;

  FeedbackTaker(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
        body: WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }
}
