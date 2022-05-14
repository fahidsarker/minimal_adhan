import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedbackTaker extends StatelessWidget {
  final String url;
  final String title;

  const FeedbackTaker(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(title),
        actions: [
          IconButton(onPressed: ()=>launchUrl(Uri.parse(url)), icon: const Icon(Icons.open_in_new))
        ],
      ),
        body: WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }
}
